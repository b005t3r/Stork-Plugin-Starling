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
import stork.event.ScreenEvent;
import stork.event.ScreenNavigatorEvent;

public class ScreenNavigatorNode extends ContainerNode {
    private var _addScreenTransitionCompleteEvent:ScreenNavigatorEvent = new ScreenNavigatorEvent(ScreenNavigatorEvent.ADD_SCREEN_TRANSITION_COMPLETE);
    private var _removeScreenTransitionCompleteEvent:ScreenNavigatorEvent = new ScreenNavigatorEvent(ScreenNavigatorEvent.REMOVE_SCREEN_TRANSITION_COMPLETE);

    private var _transitionActive:Boolean;
    private var _screenAnimated:Boolean;
    private var _transitionAnimated:Boolean;

    public function ScreenNavigatorNode(name:String = "ScreenNavigator") {
        super(name);

        addEventListener(Event.ADDED_TO_PARENT, onChildAdded);
    }

    public function get displayContainer():DisplayObjectContainer { throw new Error("abstract method call"); }

    public function pushScreen(screen:ScreenNode, animated:Boolean):void {
        if(_transitionActive)
            throw new IllegalOperationError("adding a new screen before current transition completes");

        addNode(screen);

        presentScreen(screen, animated, animated, true);
    }

    public function popScreen(animated:Boolean):ScreenNode {
        if(_transitionActive)
            throw new IllegalOperationError("adding a new screen before current transition completes");

        var screen:ScreenNode = currentScreen;

        if(screen == null)
            throw new IllegalOperationError("screen stack is empty");

        var prevScreen:ScreenNode = previousScreen;

        if(prevScreen != null) {
            displayContainer.addChild(prevScreen.display);
            prevScreen.setUpDisplay(displayContainer.width, displayContainer.height);

            // the one we just added has to go below the current one
            displayContainer.swapChildren(prevScreen.display, screen.display);
        }

        dismissScreen(screen, animated, animated);

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

    protected function beginAddScreenTransition(screen:ScreenNode):void { throw new Error("abstract method call"); }
    protected function dispatchAddScreenTransitionComplete():void { dispatchEvent(_addScreenTransitionCompleteEvent.reset()); }

    protected function beginRemoveScreenTransition(screen:ScreenNode):void { throw new Error("abstract method call"); }
    protected function dispatchRemoveScreenTransitionComplete():void { dispatchEvent(_removeScreenTransitionCompleteEvent.reset()); }

    protected function onScreenActivated(event:ScreenEvent):void {
        event.screen.removeEventListener(ScreenEvent.ACTIVATED, onScreenActivated);

        _transitionActive = false;

        if(! event.screen.active)
            throw new Error("screen has to become active before sending ScreenEvent.ACTIVATED event");

        var prevScreen:ScreenNode = previousScreen;

        if(prevScreen == null || ! prevScreen.active) return;

        dismissScreen(prevScreen, false, false);
    }

    protected function onScreenDeactivated(event:ScreenEvent):void {
        var screen:ScreenNode = event.screen;

        screen.removeEventListener(ScreenEvent.DEACTIVATED, onScreenDeactivated);

        _transitionActive = false;

        if(screen.active)
            throw new Error("screen has to become inactive before sending ScreenEvent.DEACTIVATED event");

        screen.cleanUpDisplay();
        screen.display.removeFromParent();

        if(currentScreen != screen) return;

        removeNode(screen);

        // current screen has changed
        if(currentScreen != null)
            presentScreen(currentScreen, _screenAnimated, false, false);
    }

    protected function onAddScreenTransitionComplete(event:ScreenNavigatorEvent):void {
        removeEventListener(ScreenNavigatorEvent.ADD_SCREEN_TRANSITION_COMPLETE, onAddScreenTransitionComplete);

        currentScreen.activate(_screenAnimated);
    }

    protected function onRemoveScreenTransitionComplete(event:ScreenNavigatorEvent):void {
        removeEventListener(ScreenNavigatorEvent.REMOVE_SCREEN_TRANSITION_COMPLETE, onRemoveScreenTransitionComplete);

        currentScreen.deactivate(_screenAnimated);
    }

    private function presentScreen(screen:ScreenNode, animated:Boolean, transition:Boolean, setUpDisplay:Boolean):void {
        _transitionActive   = true;
        _screenAnimated     = animated;
        _transitionAnimated = transition;

        if(setUpDisplay) {
            displayContainer.addChild(screen.display);
            screen.setUpDisplay(displayContainer.width, displayContainer.height);
        }

        screen.addEventListener(ScreenEvent.ACTIVATED, onScreenActivated);

        if(! transition) {
            screen.activate(animated);

            if(! animated && ! screen.active)
                throw new Error("screen has to become active synchronously when not animated");
        }
        else {
            addEventListener(ScreenNavigatorEvent.ADD_SCREEN_TRANSITION_COMPLETE, onAddScreenTransitionComplete);
            beginAddScreenTransition(screen);
        }
    }

    private function dismissScreen(screen:ScreenNode, animated:Boolean, transition:Boolean):void {
        _transitionActive   = true;
        _screenAnimated     = animated;
        _transitionAnimated = transition;

        screen.addEventListener(ScreenEvent.DEACTIVATED, onScreenDeactivated);

        if(! transition) {
            screen.deactivate(animated);

            if(! animated && screen.active)
                throw new Error("screen has to become inactive synchronously when not animated");
        }
        else {
            addEventListener(ScreenNavigatorEvent.REMOVE_SCREEN_TRANSITION_COMPLETE, onRemoveScreenTransitionComplete);
            beginRemoveScreenTransition(screen);
        }
    }

    private function onChildAdded(event:Event):void {
        var child:Node = event.target as Node;

        if(child.parentNode == this && child is ScreenNode == false)
            throw new TypeError("ScreenContainer can only hold ScreenNodes");
    }
}
}
