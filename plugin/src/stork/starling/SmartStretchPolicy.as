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
    private var _maxScale:Number;

    public function SmartStretchPolicy(targetWidth:Number, targetHeight:Number, maxScale:Number = NaN) {
        _targetWidth    = targetWidth;
        _targetHeight   = targetHeight;
        _maxScale       = maxScale;
    }

    public function resize(stage:Stage, viewPort:Rectangle, newWidth:Number, newHeight:Number, stageScaleFactor:Number):void {
        const w:Number          = _targetWidth;
        const h:Number          = _targetHeight;

        var baseRatio:Number    = w / h;
        var ratio:Number        = newWidth / newHeight;

        var stageWidth:Number;
        var stageHeight:Number;

        // base dimensions wider
        if(baseRatio > ratio) {
            stageWidth    = w;
            stageHeight   = w / ratio;
        }
        // base dimensions higher
        else {
            stageWidth    = h * ratio;
            stageHeight   = h;
        }

        viewPort.setTo(0, 0, newWidth, newHeight);

        var wScale:Number = viewPort.width / stageWidth;
        var hScale:Number = viewPort.height / stageHeight;

        var scale:Number = wScale < hScale ? hScale : wScale;

        if(isNaN(_maxScale) || scale <= _maxScale) {
            stage.stageWidth    = stageWidth;
            stage.stageHeight   = stageHeight;
        }
        else {
            stage.stageWidth    = viewPort.width / _maxScale;
            stage.stageHeight   = viewPort.height / _maxScale;
        }
    }
}
}
