/**
 * User: booster
 * Date: 07/10/16
 * Time: 15:16
 */
package navigation {
import starling.display.DisplayObjectContainer;
import starling.display.StorkRoot;

import stork.starling.screen.ScreenNavigatorNode;

public class DemoScreenNavigatorNode extends ScreenNavigatorNode {
    private var _root:StorkRoot;
    private var _sprite:DemoScreenNavigatorSprite;

    public function DemoScreenNavigatorNode() {
        super("DemoScreenNavigator");
    }

    [ObjectReference("StorkRoot")]
    public function get root():StorkRoot { return _root; }
    public function set root(value:StorkRoot):void { _root = value; }

    [OnReferenceChanged("root")]
    public function onRootChanged(available:Boolean):void {
        if(available) {
            if(_sprite == null) {
                _sprite = new DemoScreenNavigatorSprite(1024, 768);

                _root.addChild(_sprite);
            }
        }
        else {
            if(_sprite != null) {
                _sprite.removeFromParent(true);
                _sprite = null;
            }
        }
    }

    override public function get displayContainer():DisplayObjectContainer { return _sprite; }
}
}
