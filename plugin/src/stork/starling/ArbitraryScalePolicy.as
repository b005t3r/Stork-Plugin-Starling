/**
 * User: booster
 * Date: 18/09/15
 * Time: 12:20
 */
package stork.starling {
import flash.geom.Rectangle;

import starling.display.Stage;

public class ArbitraryScalePolicy implements IStageResizePolicy {
    private var _scale:Number;

    public function ArbitraryScalePolicy(scale:Number) {
        _scale = scale;
    }

    public function resize(stage:Stage, viewPort:Rectangle, newWidth:Number, newHeight:Number, stageScaleFactor:Number):void {
        stage.stageWidth = newWidth / (_scale / stageScaleFactor);
        stage.stageHeight = newHeight / (_scale / stageScaleFactor);

        viewPort.setTo(0, 0, newWidth, newHeight);
    }
}
}
