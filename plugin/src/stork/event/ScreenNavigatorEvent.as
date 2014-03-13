/**
 * User: booster
 * Date: 13/03/14
 * Time: 15:24
 */
package stork.event {
import stork.starling.screen.ScreenNavigatorNode;

public class ScreenNavigatorEvent extends Event {
    public static const ADD_SCREEN_TRANSITION_COMPLETE:String       = "screenNavigatorEventAddScreenTransitionComplete";
    public static const REMOVE_SCREEN_TRANSITION_COMPLETE:String    = "screenNavigatorEventRemoveScreenTransitionComplete";

    public function ScreenNavigatorEvent(type:String) {
        super(type, false);
    }

    public function get screenNavigator():ScreenNavigatorNode { return target as ScreenNavigatorNode; }
}
}
