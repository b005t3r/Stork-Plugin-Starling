/**
 * User: booster
 * Date: 29/01/14
 * Time: 16:45
 */
package stork.starling {
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.display3D.Context3DRenderMode;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.system.Capabilities;

import starling.core.Starling;
import starling.display.StorkRoot;
import starling.events.Event;
import starling.events.ResizeEvent;

import stork.core.plugin.ScenePlugin;
import stork.core.reference.ReferenceUtil;
import stork.core.stork_internal;
import stork.reference.StarlingReference;

use namespace stork_internal;

public class StarlingPlugin extends ScenePlugin {
    public static const PLUGIN_NAME:String = "Stork-Plugin-Starling";

    private var _starling:Starling;

    private var _rootClass:Class;
    private var _main:Sprite;
    private var _resizePolicy:IStageResizePolicy;

    /* static initializer */ {
        ReferenceUtil.registerReferenceClass(StarlingReference, StarlingReference.TAG_NAME);
    }

    public function StarlingPlugin(rootClass:Class, main:Sprite, resizePolicy:IStageResizePolicy = null) {
        super(PLUGIN_NAME);

        if(rootClass is StorkRoot)
            throw new ArgumentError("make sure your root class subclasses starling.display::StorkRootSprite");

        _rootClass      = rootClass;
        _main           = main;
        _resizePolicy   = resizePolicy;
    }

    override public function activate():void {
        if(_main == null)
            throw new UninitializedError("make sure your apps main class subclasses flash.display::StorkMain");

        if (_main.stage)
            init();
        else
            _main.addEventListener(flash.events.Event.ADDED_TO_STAGE, init);
    }

    // TODO: this is probably not the best implementation in the world, but it's currently only used by unit tests
    override public function deactivate():void {
        if(_starling != null) {
            _starling.dispose();
            _starling = null;
        }
    }

    private function init(event:flash.events.Event = null):void {
        _main.removeEventListener(flash.events.Event.ADDED_TO_STAGE, init);

        _main.stage.scaleMode  = StageScaleMode.NO_SCALE;
        _main.stage.align      = StageAlign.TOP_LEFT;

        _starling                       = new Starling(_rootClass, _main.stage, null, null, Context3DRenderMode.AUTO, ["baseline", "baselineExtended"]);
        _starling.simulateMultitouch    = false;
        _starling.enableErrorChecking   = Capabilities.isDebugger;
        _starling.antiAliasing          = 0;

        if(_resizePolicy != null) {
            var viewPort:Rectangle = new Rectangle();

            _resizePolicy.resize(_starling.stage, viewPort, _main.stage.stageWidth, _main.stage.stageHeight);

            _starling.viewPort = viewPort;
        }

        _starling.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
        _starling.stage.addEventListener(ResizeEvent.RESIZE, onResize);

        _starling.start();
    }

    private function onRootCreated(event:starling.events.Event):void {
        var root:StorkRoot = _starling.root as StorkRoot;

        root.stork_internal::setSceneNode(sceneNode);

        sceneNode.addObject(root, StorkRoot.OBJECT_NAME);

        fireActivatedEvent();
    }

    private function onResize(event:ResizeEvent):void {
        if(_resizePolicy == null) return;

        var viewPort:Rectangle = new Rectangle();

        _resizePolicy.resize(_starling.stage, viewPort, _main.stage.stageWidth, _main.stage.stageHeight);

        _starling.viewPort = viewPort;
    }
}
}
