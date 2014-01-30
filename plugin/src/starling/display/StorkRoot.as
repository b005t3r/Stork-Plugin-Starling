/**
 * User: booster
 * Date: 29/01/14
 * Time: 16:48
 */
package starling.display {
import flash.utils.getTimer;

import starling.events.Event;

import stork.core.SceneNode;
import stork.core.stork_internal;

public class StorkRoot extends Sprite {
    public static const OBJECT_NAME:String  = "StorkRoot";

    private var _sceneNode:SceneNode        = null;
    private var _prevTime:int               = -1;

    public function StorkRoot() {
        super();

        addEventListener(Event.ENTER_FRAME, onNextFrame);
    }

    stork_internal function setSceneNode(sceneNode:SceneNode):void { _sceneNode = sceneNode; }

    private function onNextFrame(event:Event):void {
        if(_sceneNode == null) return;

        if(_prevTime == -1) {
            _prevTime = getTimer();
        }
        else {
            var currTime:int    = getTimer();
            var dt:Number       = (currTime - _prevTime) / 1000.0;

            _sceneNode.stork_internal::step(dt);

            _prevTime = currTime;
        }
    }
}
}
