/**
 * User: booster
 * Date: 12/03/14
 * Time: 16:51
 */
package stork.starling {
import flash.geom.Rectangle;

import starling.display.Stage;

public class SmartStretchPolicy implements IStageResizePolicy {
    private var _targetWidth:Number;
    private var _targetHeight:Number;

    public function SmartStretchPolicy(targetWidth:Number, targetHeight:Number) {
        _targetWidth = targetWidth;
        _targetHeight = targetHeight;
    }

    public function resize(stage:Stage, viewPort:Rectangle, newWidth:Number, newHeight:Number):void {
        const w:Number          = _targetWidth;
        const h:Number          = _targetHeight;

        var baseRatio:Number    = w / h;
        var ratio:Number        = newWidth / newHeight;

        // base dimensions wider
        if(baseRatio > ratio) {
            stage.stageWidth    = w;
            stage.stageHeight   = w / ratio;
        }
        // base dimensions higher
        else {
            stage.stageWidth    = h * ratio;
            stage.stageHeight   = h;
        }

        viewPort.setTo(0, 0, newWidth, newHeight);
    }
}
}
