/**
 * User: booster
 * Date: 30/01/14
 * Time: 9:13
 */
package {
import starling.display.Quad;
import starling.display.Sprite;
import starling.display.StorkRoot;
import starling.events.Event;
import starling.utils.Color;

public class PongDemoRoot extends StorkRoot {
    public static const WIDTH:Number           = 800;
    public static const HEIGHT:Number          = 600;

    public static const PADDLE_WIDTH:Number    = 32;
    public static const PADDLE_HEIGHT:Number   = 128;

    public static const BALL_SIZE:Number       = 32;

    private static const DOT_WIDTH:Number       = 16;
    private static const DOT_HEIGHT:Number      = 48;
    private static const DOT_SPACE:Number       = 32;

    private static const MARGIN:Number          = 64;

    private var _dottedLine:Sprite;
    private var _leftPaddle:Quad;
    private var _rightPaddle:Quad;
    private var _ball:Quad;

    public function PongDemoRoot() {
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
    }

    private function onAddedToStage(event:Event):void {
        removeEventListener(Event.ADDED, onAddedToStage);

        _leftPaddle = new Quad(PADDLE_WIDTH, PADDLE_HEIGHT, Color.WHITE);

        _leftPaddle.name = "left";
        _leftPaddle.alignPivot();
        _leftPaddle.x = MARGIN; _leftPaddle.y = HEIGHT / 2;

        addChild(_leftPaddle);

        _rightPaddle = new Quad(PADDLE_WIDTH, PADDLE_HEIGHT, Color.WHITE);

        _rightPaddle.name = "right";
        _rightPaddle.alignPivot();
        _rightPaddle.x = WIDTH - MARGIN; _rightPaddle.y = HEIGHT / 2;

        addChild(_rightPaddle);

        _ball = new Quad(BALL_SIZE, BALL_SIZE, Color.WHITE);

        _ball.name = "ball";
        _ball.alignPivot();
        _ball.x = WIDTH / 2; _ball.y = HEIGHT / 2;

        addChild(_ball);

        _dottedLine = new Sprite();

        _dottedLine.width = DOT_WIDTH; _dottedLine.height = HEIGHT;
        _dottedLine.x = (WIDTH - DOT_WIDTH )/ 2; _dottedLine.y = 0;

        addChild(_dottedLine);

        var count:int = HEIGHT / (DOT_HEIGHT + DOT_SPACE);
        for(var i:int = 0; i < count; ++i) {
            var dot:Quad = new Quad(DOT_WIDTH, DOT_HEIGHT, Color.WHITE);

            _dottedLine.addChild(dot);
            dot.y += DOT_SPACE + i * (DOT_HEIGHT + DOT_SPACE);
        }
    }
}
}
