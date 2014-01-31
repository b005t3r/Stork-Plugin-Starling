/**
 * User: booster
 * Date: 31/01/14
 * Time: 16:42
 */
package {
import starling.display.Quad;

public class RightPaddleController extends PaddleController {
    public function RightPaddleController() {
        super("Right Controller");
    }

    [StarlingReference("right")]
    override public function set paddle(value:Quad):void { super.paddle = value; }
}
}
