/**
 * User: booster
 * Date: 31/01/14
 * Time: 16:23
 */
package {
import starling.display.Quad;

import stork.core.Node;
import stork.event.SceneStepEvent;

public class BallController extends Node {
    private static const SPEED:Number = 125;

    private var _ball:Quad;

    [StarlingReference("left")]
    public var _leftPaddle:Quad;

    [StarlingReference("right")]
    public var _rightPaddle:Quad;

    private var _xSpeed:Number = SPEED;
    private var _ySpeed:Number = -SPEED;

    public function BallController() {
        super("Ball Controller");
    }

    [StarlingReference("ball")]
    public function get ball():Quad { return _ball; }
    public function set ball(value:Quad):void {
        if(_ball == value)
            return;

        sceneNode.removeEventListener(SceneStepEvent.STEP, onStep);

        _ball = value;

        if(_ball != null)
            sceneNode.addEventListener(SceneStepEvent.STEP, onStep);
    }

    private function onStep(event:SceneStepEvent):void {
        _ball.x += _xSpeed * event.dt;
        _ball.y += _ySpeed * event.dt;

        if(_ball.y < PongDemoRoot.BALL_SIZE / 2 || _ball.y > PongDemoRoot.HEIGHT - PongDemoRoot.BALL_SIZE / 2)
            _ySpeed *= -1;

        if(_ball.x + PongDemoRoot.BALL_SIZE / 2 > _rightPaddle.x - PongDemoRoot.PADDLE_WIDTH / 2
        || _ball.x - PongDemoRoot.BALL_SIZE / 2 < _leftPaddle.x + PongDemoRoot.PADDLE_WIDTH / 2)
            _xSpeed *= -1;
    }
}
}
