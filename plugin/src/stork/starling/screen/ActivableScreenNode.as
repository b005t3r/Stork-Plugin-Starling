/**
 * User: booster
 * Date: 06/10/16
 * Time: 15:51
 */
package stork.starling.screen {
import starling.display.DisplayObject;

import stork.event.ScreenEvent;

public class ActivableScreenNode extends ScreenNode {
    protected var _display:DisplayObject;

    private var _active:Boolean;
    private var _paused:Boolean;

    private var _activationTriggered:Boolean;
    private var _activationAnimated:Boolean;

    private var _deactivationTriggered:Boolean;
    private var _deactivationAnimated:Boolean;

    private var _activators:Object;

    public function ActivableScreenNode(activatorIds:Vector.<String>, name:String = "ActivableScreen") {
        super(name);

        initActivators(activatorIds);
    }

    public function get paused():Boolean { return _paused; }
    override public function get active():Boolean { return _active; }

    override public function get display():DisplayObject {
        if(_display == null)
            _display = createDisplay();

        return _display;
    }

    override public function activate(animated:Boolean):void {
        triggerActivation(animated);
    }

    override public function deactivate(animated:Boolean):void {
        resetActivation(animated);
    }

    protected function createDisplay():DisplayObject { throw new Error("abstract method"); }

    protected function isActivatorTriggered(activatorID:String):Boolean {
        if(! _activators.hasOwnProperty(activatorID))
            throw new Error("no such activator ID: " + activatorID);

        return _activators[activatorID];
    }

    protected function triggerActivator(activatorID:String):void {
        if(isActivatorTriggered(activatorID))
            throw new Error("activator already active: " + activatorID);

        _activators[activatorID] = true;

        if((_activationTriggered || _paused) && allActivatorsTriggered()) {
            if(! _active)
                internalActivate(_activationAnimated);
            else if(_paused)
                internalResume();
        }
    }

    protected function resetActivator(activatorID:String):void {
        if(! _activators.hasOwnProperty(activatorID))
            throw new Error("no such activator ID: " + activatorID);

        _activators[activatorID] = false;

        if(! _active || _paused)
            return;

        internalPause();
    }

    /**
     * Override for animated activation. By default it simply sets active to true and calls dispatchActivatedEvent() method.
     * If you override this method, make sure to call the default implementation once the animation finished to dispatch the event and
     * set activated member accordingly.
     */
    protected function internalActivate(animated:Boolean):void {
        _activationTriggered = _activationAnimated = false;

        _active = true;
        dispatchActivatedEvent(animated);
    }

    /**
     * Override for animated deactivation. By default it simply sets active to false and calls dispatchDeactivatedEvent() method.
     * If you override this method, make sure to call the default implementation once the animation finished to dispatch the event and
     * set activated member accordingly.
     */
    protected function internalDeactivate(animated:Boolean):void {
        _deactivationTriggered = _deactivationAnimated = false;

        _active = _paused = false;
        dispatchDeactivatedEvent(animated);
    }

    /**
     * Override to react on when this screen switches to paused state (after being activated, one or more activators has been reset).
     * Always call the default implementation.
     */
    protected function internalPause():void {
        _paused = true;
    }

    /**
     * Override to react on when this screen switches back to active state (after being paused, when all activators has been triggered again).
     * Always call the default implementation.
     */
    protected function internalResume():void {
        _paused = false;
    }

    private function initActivators(activatorIds:Vector.<String>):void {
        if(_activators != null)
            throw new Error("activators already initialized");

        _activators = {};

        if(activatorIds == null)
            return;

        var count:int = activatorIds.length;
        for(var i:int = 0; i < count; ++i) {
            var activator:String = activatorIds[i];

            _activators[activator] = false;
        }
    }

    private function resetAllActivators():void {
        for(var activatorID:String in _activators) {
            if(! _activators.hasOwnProperty(activatorID))
                continue;

            _activators[activatorID] = false;
        }
    }

    private function triggerActivation(animated:Boolean):void {
        if(_activationTriggered)
            throw new Error("activation already triggered");

        if(! _active) {
            _activationTriggered    = true;
            _activationAnimated     = animated;

            if(! allActivatorsTriggered())
                return;

            internalActivate(_activationAnimated);
        }
        else if(_deactivationTriggered) {
            addEventListener(ScreenEvent.DEACTIVATED, function(event:ScreenEvent):void {
                removeEventListener(event.type, arguments.callee);

                triggerActivation(animated);
            });
        }
        else {
            throw new Error("already activated");
        }
    }

    private function resetActivation(animated:Boolean):void {
        if(_deactivationTriggered)
            throw new Error("deactivation already triggered");

        if(_active) {
            _deactivationTriggered = true;
            _deactivationAnimated = animated;

            internalDeactivate(_deactivationAnimated);
        }
        else if(_activationTriggered) {
            addEventListener(ScreenEvent.ACTIVATED, function(event:ScreenEvent):void {
                removeEventListener(event.type, arguments.callee);

                resetActivation(animated);
            });
        }
        else {
            throw new Error("already deactivated");
        }
    }

    private  function allActivatorsTriggered():Boolean {
        for(var activatorID:String in _activators) {
            if(! _activators.hasOwnProperty(activatorID))
                continue;

            if(_activators[activatorID])
                continue;

            return false;
        }

        return true;
    }
}
}
