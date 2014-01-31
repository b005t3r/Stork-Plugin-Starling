/**
 * User: booster
 * Date: 31/01/14
 * Time: 9:48
 */
package stork.starling {
import flash.desktop.NativeApplication;

import org.flexunit.asserts.assertEquals;

import org.flexunit.async.Async;
import org.fluint.uiImpersonation.UIImpersonator;

import starling.display.Quad;

import starling.display.StorkRoot;
import starling.text.TextField;

import stork.core.SceneNode;
import stork.event.SceneEvent;

import strok.test.SceneSetupCompleteEvent;

public class StarlingPluginTest {
    private var scene:SceneNode;
    private var plugin:StarlingPlugin;
    private var root:StorkRoot;

    [Before(async, ui)]
    public function setUp():void {
        Async.proceedOnEvent(this, UIImpersonator.testDisplay, SceneSetupCompleteEvent.SETUP_COMPLETE, 500);

        NativeApplication.nativeApplication.activeWindow.stage.addChild(UIImpersonator.testDisplay);

        scene = new SceneNode();
        plugin = new StarlingPlugin(StorkRoot, UIImpersonator.testDisplay);

        scene.registerPlugin(plugin);
        scene.start();

        scene.addEventListener(SceneEvent.SCENE_STARTED, onSceneStarted);

        function onSceneStarted(event:SceneEvent):void {
            scene.removeEventListener(SceneEvent.SCENE_STARTED, onSceneStarted);

            root = scene.getObjectByName(StorkRoot.OBJECT_NAME) as StorkRoot;

            UIImpersonator.testDisplay.dispatchEvent(new SceneSetupCompleteEvent(SceneSetupCompleteEvent.SETUP_COMPLETE));
        }
    }

    [After]
    public function tearDown():void {
        scene = null;
        plugin.deactivate();
        plugin = null;
        root = null;
    }

    [Test]
    public function simpleReferenceTest():void {
        var referencing:SimpleReferencingNode = new SimpleReferencingNode();
        var referenced:Quad = new Quad(100, 100, 0xffffff);
        var publicReferenced:TextField = new TextField(100, 100, "aaaa");

        referenced.name = "myQuad";

        assertEquals(referencing.refName, null);
        assertEquals(referencing.refClass, null);

        scene.addNode(referencing);

        assertEquals(referencing.refName, null);
        assertEquals(referencing.refClass, null);

        root.addChild(referenced);

        assertEquals(referencing.refName, referenced);
        assertEquals(referencing.refClass, null);

        referenced.removeFromParent();

        assertEquals(referencing.refName, null);
        assertEquals(referencing.refClass, null);

        root.addChild(referenced);

        assertEquals(referencing.refName, referenced);
        assertEquals(referencing.refClass, null);

        referencing.removeFromParent();

        assertEquals(referencing.refName, null);
        assertEquals(referencing.refClass, null);

        root.addChild(publicReferenced);
        scene.addNode(referencing);

        assertEquals(referencing.refName, referenced);
        assertEquals(referencing.refClass, publicReferenced);

        publicReferenced.removeFromParent();

        assertEquals(referencing.refName, referenced);
        assertEquals(referencing.refClass, null);

        root.addChild(publicReferenced);
        referenced.removeFromParent();

        assertEquals(referencing.refName, null);
        assertEquals(referencing.refClass, publicReferenced);
    }
}
}

import starling.display.Quad;
import starling.text.TextField;

import stork.core.Node;

class SimpleReferencingNode extends Node {
    private var _refName:Quad;

    [StarlingReference("@starling.text::TextField")]
    public var refClass:TextField;

    [StarlingReference("myQuad")]
    public function get refName():Quad { return _refName; }
    public function set refName(value:Quad):void { _refName = value; }
}
