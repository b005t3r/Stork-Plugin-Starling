/**
 * User: booster
 * Date: 13/03/14
 * Time: 12:30
 */
package stork.starling.screen {
import flash.errors.IllegalOperationError;

import starling.display.DisplayObjectContainer;

import stork.core.ContainerNode;
import stork.core.Node;
import stork.event.Event;
import stork.event.ScreenTransitionEvent;

public class ScreenNavigatorNode extends ContainerNode {
    private var _currentTransition:Transition;

    public function ScreenNavigatorNode(name:String = "ScreenNavigator") {
        super(name);

        addEventListener(Event.ADDED_TO_PARENT, onChildAdded);
        addEventListener(ScreenTransitionEvent.TRANSITION_COMPLETE, onTransitionComplete);
    }

    public function get inTransition():Boolean { return _currentTransition != null; }

    public function get displayContainer():DisplayObjectContainer { throw new Error("abstract method call"); }

    public function transition(oldScreen:ScreenNode, newScreen:ScreenNode, onComplete:Function):void {
        onComplete();
    }

    public function pushScreen(screen:ScreenNode, animated:Boolean):void {
        if(_currentTransition != null)
            throw new IllegalOperationError("pushing a new screen before current transition completes");

        _currentTransition = new Transition(this, currentScreen, screen, animated);
        _currentTransition.start();
    }

    public function popScreen(animated:Boolean):ScreenNode {
        if(_currentTransition != null)
            throw new IllegalOperationError("popping a screen before current transition completes");

        var screen:ScreenNode = currentScreen;

        _currentTransition = new Transition(this, screen, previousScreen, animated);
        _currentTransition.start();

        return screen;
    }

    public function get currentScreen():ScreenNode {
        if(nodeCount == 0)
            return null;

        return getNodeAt(nodeCount - 1) as ScreenNode;
    }

    public function get previousScreen():ScreenNode {
        if(nodeCount <= 1)
            return null;

        return getNodeAt(nodeCount - 2) as ScreenNode;
    }

    public function get screenCount():int { return nodeCount; }

    private function onChildAdded(event:Event):void {
        var child:Node = event.target as Node;

        if(child.parentNode == this && child is ScreenNode == false)
            throw new TypeError("ScreenContainer can only hold ScreenNodes");
    }

    private function onTransitionComplete(event:ScreenTransitionEvent):void {
        // TODO: this should be set to null before dispatching this event
        _currentTransition = null;
    }
}
}

import stork.event.ScreenEvent;
import stork.event.ScreenTransitionEvent;
import stork.starling.screen.ScreenNavigatorNode;
import stork.starling.screen.ScreenNode;

class Transition {
    public var owner:ScreenNavigatorNode;
    public var oldScreen:ScreenNode;
    public var newScreen:ScreenNode;
    public var animated:Boolean;

    public function Transition(owner:ScreenNavigatorNode, oldScreen:ScreenNode, newScreen:ScreenNode, animated:Boolean) {
        this.owner      = owner;
        this.oldScreen  = oldScreen;
        this.newScreen  = newScreen;
        this.animated   = animated;
    }

    public function start():void {
        // pushing a new screen
        if(newScreen != null && owner.getNodeIndex(newScreen) < 0) {
            if(oldScreen != null) {
                oldScreen.addEventListener(ScreenEvent.DEACTIVATED, onPushScreenDeactivated);
                oldScreen.deactivate(animated);
            }
            else {
                onPushScreenDeactivated();
            }
        }
        // popping an old screen
        else {
            oldScreen.addEventListener(ScreenEvent.DEACTIVATED, onPopScreenDeactivated);
            oldScreen.deactivate(animated);
        }
    }

    // push a new screen

    private function onPushScreenDeactivated(event:ScreenEvent = null):void {
        if(oldScreen != null)
            oldScreen.removeEventListener(ScreenEvent.DEACTIVATED, onPushScreenDeactivated);

        owner.addNode(newScreen);

        owner.displayContainer.addChild(newScreen.display);
        newScreen.setUpDisplay(owner.displayContainer.width, owner.displayContainer.height);

        owner.transition(oldScreen, newScreen, onPushTransitionComplete);
    }

    private function onPushTransitionComplete():void {
        if(oldScreen != null) {
            oldScreen.cleanUpDisplay();
            oldScreen.display.removeFromParent();
        }

        newScreen.addEventListener(ScreenEvent.ACTIVATED, onPushScreenActivated);
        newScreen.activate(animated);
    }

    private function onPushScreenActivated(event:ScreenEvent):void {
        newScreen.removeEventListener(ScreenEvent.ACTIVATED, onPushScreenActivated);

        owner.dispatchEvent(new ScreenTransitionEvent(ScreenTransitionEvent.TRANSITION_COMPLETE).resetEvent(oldScreen, newScreen));
    }

    // pop an old screen

    private function onPopScreenDeactivated(event:ScreenEvent):void {
        oldScreen.removeEventListener(ScreenEvent.DEACTIVATED, onPopScreenDeactivated);

        if(newScreen != null) {
            owner.displayContainer.addChild(newScreen.display);
            newScreen.setUpDisplay(owner.displayContainer.width, owner.displayContainer.height);
        }

        owner.transition(oldScreen, newScreen, onPopTransitionComplete);
    }

    private function onPopTransitionComplete():void {
        owner.removeNode(oldScreen);

        if(newScreen != null) {
            newScreen.addEventListener(ScreenEvent.ACTIVATED, onPopScreenActivated);
            newScreen.activate(animated);
        }
        else {
            onPopScreenActivated();
        }
    }

    private function onPopScreenActivated(event:ScreenEvent = null):void {
        if(newScreen != null)
            newScreen.removeEventListener(ScreenEvent.ACTIVATED, onPopScreenActivated);

        owner.dispatchEvent(new ScreenTransitionEvent(ScreenTransitionEvent.TRANSITION_COMPLETE).resetEvent(oldScreen, newScreen));
    }
}
