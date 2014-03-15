/**
 * User: booster
 * Date: 13/03/14
 * Time: 15:24
 */
package stork.event {
import stork.starling.screen.ScreenNavigatorNode;
import stork.starling.screen.ScreenNode;

public class ScreenTransitionEvent extends Event {
    public static const TRANSITION_COMPLETE:String = "screenTransitionEventComplete";

    private var _oldScreen:ScreenNode;
    private var _newScreen:ScreenNode;

    public function ScreenTransitionEvent(type:String) {
        super(type, false);
    }

    public function get screenNavigator():ScreenNavigatorNode { return target as ScreenNavigatorNode; }
    public function get oldScreen():ScreenNode { return _oldScreen; }
    public function get newScreen():ScreenNode { return _newScreen; }

    public function resetEvent(oldScreen:ScreenNode, newScreen:ScreenNode):ScreenTransitionEvent {
        _oldScreen = oldScreen;
        _newScreen = newScreen;

        return reset() as ScreenTransitionEvent;
    }
}
}
