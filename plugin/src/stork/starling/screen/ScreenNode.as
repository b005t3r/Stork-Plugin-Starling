/**
 * User: booster
 * Date: 13/03/14
 * Time: 12:30
 */
package stork.starling.screen {

import starling.display.DisplayObject;

import stork.core.Node;
import stork.event.ScreenEvent;

public class ScreenNode extends Node {
    private var _activatedEvent:ScreenEvent     = new ScreenEvent(ScreenEvent.ACTIVATED);
    private var _deactivatedEvent:ScreenEvent   = new ScreenEvent(ScreenEvent.DEACTIVATED);

    public function ScreenNode(name:String = "Screen") {
        super(name);
    }

    public function get navigator():ScreenNavigatorNode { return parentNode as ScreenNavigatorNode; }

    public function get active():Boolean { throw new Error("abstract method call"); }
    public function get display():DisplayObject { throw new Error("abstract method call");  }

    public function setUpDisplay(width:Number, height:Number):void { }
    public function cleanUpDisplay():void { }

    public function activate(animated:Boolean):void { throw new Error("abstract method call"); }
    public function deactivate(animated:Boolean):void { throw new Error("abstract method call"); }

    protected function dispatchActivatedEvent(animated:Boolean):void { dispatchEvent(_activatedEvent.resetEvent(animated)); }
    protected function dispatchDeactivatedEvent(animated:Boolean):void { dispatchEvent(_deactivatedEvent.resetEvent(animated)); }
}
}
