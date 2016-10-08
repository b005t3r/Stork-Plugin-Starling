/**
 * User: booster
 * Date: 07/10/16
 * Time: 15:46
 */
package navigation {
import flash.geom.Matrix;
import flash.geom.Rectangle;

import medkit.geom.GeomUtil;
import medkit.geom.shapes.Point2D;

import starling.display.DisplayObject;
import starling.display.Sprite;

public class DemoScreenNavigatorSprite extends Sprite {
    private static const helperMatrix:Matrix = new Matrix();
    private static const helperPointA:Point2D = new Point2D();
    private static const helperPointB:Point2D = new Point2D();

    protected var _w:Number, _h:Number;

    public function DemoScreenNavigatorSprite(w:Number, h:Number) {
        _w = w;
        _h = h;
    }

    public function get w():Number { return _w; }
    public function set w(value:Number):void { _w = value; }

    public function get h():Number { return _h; }
    public function set h(value:Number):void { _h = value; }

    override public function getBounds(targetSpace:DisplayObject, resultRect:Rectangle = null):Rectangle {
        if(resultRect == null) resultRect = new Rectangle();

        // optimization
        if(targetSpace == this) {
            resultRect.setTo(0.0, 0.0, _w, _h);
        }
        // optimization
        else if(targetSpace == parent && rotation == 0.0) {
            var scaleX:Number = this.scaleX;
            var scaleY:Number = this.scaleY;

            resultRect.setTo(
                x - pivotX * scaleX,
                y - pivotY * scaleY,
                _w * scaleX,
                _h * scaleY
            );

            if(scaleX < 0) {
                resultRect.width *= -1;
                resultRect.x -= resultRect.width;
            }
            if(scaleY < 0) {
                resultRect.height *= -1;
                resultRect.y -= resultRect.height;
            }
        }
        else {
            getTransformationMatrix(targetSpace, helperMatrix);

            GeomUtil.transformPoint2D(helperMatrix, 0, 0, helperPointA);
            GeomUtil.transformPoint2D(helperMatrix, _w, _h, helperPointB);

            resultRect.setTo(
                helperPointA.x < helperPointB.x ? helperPointA.x : helperPointB.x,
                helperPointA.y < helperPointB.y ? helperPointA.y : helperPointB.y,
                Math.abs(helperPointA.x - helperPointB.x),
                Math.abs(helperPointA.y - helperPointB.y)
            );
        }

        return resultRect;
    }
}
}
