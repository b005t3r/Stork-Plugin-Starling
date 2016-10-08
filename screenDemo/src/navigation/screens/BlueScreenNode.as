/**
 * User: booster
 * Date: 08/10/16
 * Time: 08:34
 */
package navigation.screens {
import starling.core.Starling;
import starling.display.DisplayObject;
import starling.display.Quad;
import starling.utils.Color;

import stork.core.Node;
import stork.starling.screen.ActivableScreenNode;

public class BlueScreenNode extends ActivableScreenNode {
    public static const ACTIVATOR_IDS:Vector.<String> = new <String>["A", "D", "E"];

    public static const INACTIVE_ALPHA:Number   = 0.35;
    public static const ACTIVE_ALPHA:Number     = 1.0;
    public static const PAUSED_COLOR:uint       = Color.rgb(0, 0, 128);
    public static const ACTIVE_COLOR:uint       = Color.BLUE;

    private var _nodeA:Node;
    private var _nodeD:Node;
    private var _nodeE:Node;

    public function BlueScreenNode() {
        super(ACTIVATOR_IDS, "Blue");
    }

    private function get quad():Quad { return Quad(display); }

    [GlobalReference("NodeA")]
    public function get nodeA():Node { return _nodeA; }
    public function set nodeA(value:Node):void { _nodeA = value; }

    [GlobalReference("NodeD")]
    public function get nodeD():Node { return _nodeD; }
    public function set nodeD(value:Node):void { _nodeD = value; }

    [GlobalReference("NodeE")]
    public function get nodeE():Node { return _nodeE; }
    public function set nodeE(value:Node):void { _nodeE = value; }

    [OnReferenceChanged("nodeA")]
    public function onNodeA(available:Boolean):void {
        if(available)
            triggerActivator("A");
        else
            resetActivator("A");
    }

    [OnReferenceChanged("nodeD")]
    public function onNodeD(available:Boolean):void {
        if(available)
            triggerActivator("D");
        else
            resetActivator("D");
    }

    [OnReferenceChanged("nodeE")]
    public function onNodeC(available:Boolean):void {
        if(available)
            triggerActivator("E");
        else
            resetActivator("E");
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
        trace("[Blue]  triggered:", activatorID);
        super.triggerActivator(activatorID);
    }

    override protected function resetActivator(activatorID:String):void {
        trace("[Blue]  reset:", activatorID);
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
                    color : ACTIVE_COLOR,
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

        trace("[Blue]  paused");
        super.internalPause();
    }

    override protected function internalResume():void {
        quad.color = ACTIVE_COLOR;

        trace("[Blue]  resumed");
        super.internalResume();
    }

    private function superInternalActivate(animated:Boolean):void {
        trace("[Blue]  activated");
        super.internalActivate(animated);
    }

    private function superInternalDeactivate(animated:Boolean):void {
        trace("[Blue]  deactivated");
        super.internalDeactivate(animated);
    }
}
}
