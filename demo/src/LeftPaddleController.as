/**
 * User: booster
 * Date: 31/01/14
 * Time: 16:42
 */
package {
import starling.display.Quad;

public class LeftPaddleController extends PaddleController {
    public function LeftPaddleController() {
        super("Left Controller");
    }

    [StarlingReference("left")]
    override public function set paddle(value:Quad):void { super.paddle = value; }
}
}
