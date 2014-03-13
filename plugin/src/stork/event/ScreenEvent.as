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

    public function ScreenEvent(type:String) {
        super(type, false);
    }

    public function get screen():ScreenNode { return target as ScreenNode; }
}
}
