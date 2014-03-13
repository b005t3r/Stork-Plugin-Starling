/**
 * User: booster
 * Date: 12/03/14
 * Time: 17:07
 */
package stork.starling {
import flash.geom.Rectangle;

import starling.display.Stage;

public class SimpleResizePolicy implements IStageResizePolicy {
    public function resize(stage:Stage, viewPort:Rectangle, newWidth:Number, newHeight:Number):void {
        stage.stageWidth = newWidth;
        stage.stageHeight = newHeight;

        viewPort.setTo(0, 0, newWidth, newHeight);
    }
}
}
