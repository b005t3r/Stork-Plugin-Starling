/**
 * User: booster
 * Date: 29/01/14
 * Time: 16:45
 */
package stork.starling {
import flash.display.StorkMain;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.display3D.Context3DRenderMode;
import flash.events.Event;
import flash.system.Capabilities;

import starling.core.Starling;
import starling.display.StorkRoot;
import starling.events.Event;

import stork.core.plugin.ScenePlugin;
import stork.core.reference.ReferenceUtil;
import stork.core.stork_internal;
import stork.reference.StarlingReference;

use namespace stork_internal;

public class StarlingPlugin extends ScenePlugin {
    public static const PLUGIN_NAME:String = "Stork-Plugin-Starling";

    private var _starling:Starling;
    private var _rootClass:Class;

    /* static initializer */ {
        ReferenceUtil.registerReferenceClass(StarlingReference, StarlingReference.TAG_NAME);
    }

    public function StarlingPlugin(rootClass:Class) {
        super(PLUGIN_NAME);

        if(rootClass is StorkRoot)
            throw new ArgumentError("make sure your root class subclasses starling.display::StorkRootSprite");

        _rootClass = rootClass;
    }

    override public function activate():void {
        if(StorkMain.instance == null)
            throw new UninitializedError("make sure your apps main class subclasses flash.display::StorkMain");

        if (StorkMain.instance.stage)
            init();
        else
            StorkMain.instance.addEventListener(flash.events.Event.ADDED_TO_STAGE, init);
    }

    private function init(event:flash.events.Event = null):void {
        StorkMain.instance.removeEventListener(flash.events.Event.ADDED_TO_STAGE, init);

        StorkMain.instance.stage.scaleMode  = StageScaleMode.NO_SCALE;
        StorkMain.instance.stage.align      = StageAlign.TOP_LEFT;

        _starling                       = new Starling(_rootClass, StorkMain.instance.stage, null, null, Context3DRenderMode.AUTO, ["baseline", "baselineExtended"]);
        _starling.simulateMultitouch    = false;
        _starling.enableErrorChecking   = Capabilities.isDebugger;
        _starling.antiAliasing          = 0;

        _starling.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);

        _starling.start();
    }

    private function onRootCreated(event:starling.events.Event):void {
        var root:StorkRoot = _starling.root as StorkRoot;

        root.stork_internal::setSceneNode(sceneNode);

        sceneNode.addObject(root, StorkRoot.OBJECT_NAME);

        fireActivatedEvent();
    }
}
}
