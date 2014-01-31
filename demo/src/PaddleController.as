/**
 * User: booster
 * Date: 31/01/14
 * Time: 16:34
 */
package {
import starling.display.Quad;

import stork.core.Node;
import stork.event.SceneStepEvent;

public class PaddleController extends Node {
    private var _paddle:Quad;
    private var _ball:Quad;

    public function PaddleController(name:String = "PaddleController") {
        super(name);
    }

    public function get paddle():Quad { return _paddle; }
    public function set paddle(value:Quad):void {
        if(_paddle != value)
            sceneNode.removeEventListener(SceneStepEvent.STEP, onStep);

        _paddle = value;

        if(_paddle != null)
            sceneNode.addEventListener(SceneStepEvent.STEP, onStep);
    }

    [StarlingReference("ball")]
    public function get ball():Quad { return _ball; }
    public function set ball(value:Quad):void { _ball = value; }

    private function onStep(event:SceneStepEvent):void {
        _paddle.y = Math.max(PongDemoRoot.PADDLE_HEIGHT / 2, Math.min(_ball.y, PongDemoRoot.HEIGHT - PongDemoRoot.PADDLE_HEIGHT / 2));
    }
}
}
