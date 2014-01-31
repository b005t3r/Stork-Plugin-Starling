/**
 * User: booster
 * Date: 31/01/14
 * Time: 9:51
 */
package strok.test {
import flash.events.Event;

public class SceneSetupCompleteEvent extends Event {
    public static const SETUP_COMPLETE:String = "setupCompleteEvent";

    public function SceneSetupCompleteEvent(type:String) {
        super(type, false, false);
    }
}
}
