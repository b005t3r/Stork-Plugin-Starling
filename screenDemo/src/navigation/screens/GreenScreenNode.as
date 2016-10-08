/**
 * User: booster
 * Date: 07/10/16
 * Time: 15:23
 */
package navigation.screens {
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Quad;
import starling.utils.Color;

import stork.core.Node;
import stork.starling.screen.ActivableScreenNode;

public class GreenScreenNode extends ActivableScreenNode {
    public static const ACTIVATOR_IDS:Vector.<String> = new <String>["A", "B", "C"];

    public static const INACTIVE_ALPHA:Number   = 0.35;
    public static const ACTIVE_ALPHA:Number     = 1.0;
    public static const PAUSED_COLOR:uint       = Color.rgb(0, 64, 0);
    public static const ACTIVE_COLOR:uint       = Color.GREEN;

    private var _nodeA:Node;
    private var _nodeB:Node;
    private var _nodeC:Node;

    public function GreenScreenNode() {
        super(ACTIVATOR_IDS, "Green");
    }

    private function get quad():Quad { return Quad(display); }

    [GlobalReference("NodeA")]
    public function get nodeA():Node { return _nodeA; }
    public function set nodeA(value:Node):void { _nodeA = value; }

    [GlobalReference("NodeB")]
    public function get nodeB():Node { return _nodeB; }
    public function set nodeB(value:Node):void { _nodeB = value; }

    [GlobalReference("NodeC")]
    public function get nodeC():Node { return _nodeC; }
    public function set nodeC(value:Node):void { _nodeC = value; }

    [OnReferenceChanged("nodeA")]
    public function onNodeA(available:Boolean):void {
        if(available)
            triggerActivator("A");
        else
            resetActivator("A");
    }

    [OnReferenceChanged("nodeB")]
    public function onNodeB(available:Boolean):void {
        if(available)
            triggerActivator("B");
        else
            resetActivator("B");
    }

    [OnReferenceChanged("nodeC")]
    public function onNodeC(available:Boolean):void {
        if(available)
            triggerActivator("C");
        else
            resetActivator("C");
    }

    override protected function createDisplay():DisplayObject {
        var greenQuad:Quad = new Quad(1, 1, ACTIVE_COLOR);
        greenQuad.alpha = INACTIVE_ALPHA;

        return greenQuad;
    }

    override public function setUpDisplay(width:Number, height:Number):void {
        display.width   = width;
        display.height  = height;
    }

    override protected function triggerActivator(activatorID:String):void {
        trace("[Green] triggered:", activatorID);
        super.triggerActivator(activatorID);
    }

    override protected function resetActivator(activatorID:String):void {
        trace("[Green] reset:", activatorID);
        super.resetActivator(activatorID);
    }

    override protected function internalActivate(animated:Boolean):void {
        if(! animated) {
            quad.alpha = ACTIVE_ALPHA;

            superInternalActivate(false);
        }
        else {
            Starling.current.juggler.tween(
                quad,
                1.5,
                {
                    alpha : ACTIVE_ALPHA,
                    onComplete : function():void {
                        superInternalActivate(true);
                    }
                });
        }
    }

    override protected function internalDeactivate(animated:Boolean):void {
        if(! animated) {
            quad.alpha = INACTIVE_ALPHA;

            superInternalDeactivate(false);
        }
        else {
            Starling.current.juggler.tween(
                quad,
                1.5,
                {
                    alpha : INACTIVE_ALPHA,
                    onComplete : function():void {
                        superInternalDeactivate(true);
                    }
                });
        }
    }

    override protected function internalPause():void {
        quad.color = PAUSED_COLOR;

        trace("[Green] paused");
        super.internalPause();
    }

    override protected function internalResume():void {
        quad.color = ACTIVE_COLOR;

        trace("[Green] resumed");
        super.internalResume();
    }

    private function superInternalActivate(animated:Boolean):void {
        trace("[Green] activated");
        super.internalActivate(animated);
    }

    private function superInternalDeactivate(animated:Boolean):void {
        trace("[Green] deactivated");
        super.internalDeactivate(animated);
    }
}
}
