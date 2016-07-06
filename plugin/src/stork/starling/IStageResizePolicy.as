/**
 * User: booster
 * Date: 12/03/14
 * Time: 16:50
 */
package stork.starling {
import flash.geom.Rectangle;

import starling.display.Stage;

public interface IStageResizePolicy {
    function resize(stage:Stage, viewPort:Rectangle, newWidth:Number, newHeight:Number, stageScaleFactor:Number):void
}
}
