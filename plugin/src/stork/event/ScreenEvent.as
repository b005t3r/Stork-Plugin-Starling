/**
 * User: booster
 * Date: 13/03/14
 * Time: 14:38
 */
package stork.event {
import stork.starling.screen.ScreenNode;

public class ScreenEvent extends Event {
    public static const ACTIVATED:String    = "screenEventActivated";
    public static const DEACTIVATED:String  = "screenEventDeactivated";

    private var _animated:Boolean;

    public function ScreenEvent(type:String) {
        super(type, false);
    }

    public function get screen():ScreenNode { return target as ScreenNode; }
    public function get animated():Boolean { return _animated; }

    public function resetEvent(animated:Boolean):ScreenEvent {
        _animated = animated;

        return ScreenEvent(reset());
    }
}
}
