/**
 * User: booster
 * Date: 30/01/14
 * Time: 9:13
 */
package {
import starling.display.Quad;
import starling.display.StorkRoot;
import starling.events.Event;
import starling.utils.Color;

public class SimpleDemoRoot extends StorkRoot {
    public function SimpleDemoRoot() {
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
    }

    private function onAddedToStage(event:Event):void {
        removeEventListener(Event.ADDED, onAddedToStage);

        var quad:Quad = new Quad(100, 100, Color.RED);
        quad.x = 100; quad.y = 100;

        addChild(quad);
    }
}
}
