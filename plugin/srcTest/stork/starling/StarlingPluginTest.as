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
import starling.display.Sprite;
import starling.display.StorkRoot;
import starling.text.TextField;
import starling.utils.Color;

import stork.core.ContainerNode;
import stork.core.SceneNode;
import stork.event.SceneEvent;

import stork.test.SceneSetupCompleteEvent;

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

    [Test]
    public function complexReferenceTest():void {
        var container:Sprite = new Sprite(); container.name = "Container";
        var globalContainer:Sprite = new Sprite(); globalContainer.name = "GlobalContainer";
        var mySibling:Quad = new Quad(100, 100, Color.RED); mySibling.name = "mySibling";

        var complexContainer:ContainerNode = new ContainerNode();
        var complexNode:ComplexReferencingNode = new ComplexReferencingNode();

        var siblingContainer:Sprite = new Sprite(); siblingContainer.name = "SiblingContainer";
        var localContainer:Sprite = new Sprite(); localContainer.name = "LocalContainer";
        var publicRefNode:TextField = new TextField(100, 100, "aaa");

        root.addChild(container);
        container.addChild(globalContainer);
        globalContainer.addChild(mySibling);

        scene.addNode(complexContainer);
        complexContainer.addNode(complexNode);

        root.addChild(siblingContainer);
        siblingContainer.addChild(localContainer);
        siblingContainer.addChild(publicRefNode);

        assertEquals(complexNode.globCont, globalContainer);
        assertEquals(complexNode.locCont, localContainer);
        assertEquals(complexNode.ref, mySibling);
        assertEquals(complexNode.pubRef, publicRefNode);

        var anotherContainer:Sprite = new Sprite(); anotherContainer.name = "Container";
        var anotherGlobalContainer:Sprite = new Sprite(); anotherGlobalContainer.name = "GlobalContainer";
        var anotherMySibling:Quad = new Quad(100, 100, Color.GREEN); anotherMySibling.name = "mySibling";

        root.addChild(anotherContainer);
        anotherContainer.addChild(anotherGlobalContainer);
        anotherGlobalContainer.addChild(anotherMySibling);

        assertEquals(complexNode.globCont, globalContainer);
        assertEquals(complexNode.locCont, localContainer);
        assertEquals(complexNode.ref, mySibling);
        assertEquals(complexNode.pubRef, publicRefNode);

        container.removeFromParent();

        assertEquals(complexNode.globCont, anotherGlobalContainer);
        assertEquals(complexNode.locCont, localContainer);
        assertEquals(complexNode.ref, anotherMySibling);
        assertEquals(complexNode.pubRef, publicRefNode);

        root.addChild(container);

        assertEquals(complexNode.globCont, anotherGlobalContainer);
        assertEquals(complexNode.locCont, localContainer);
        assertEquals(complexNode.ref, anotherMySibling);
        assertEquals(complexNode.pubRef, publicRefNode);

        container.removeFromParent();

        assertEquals(complexNode.globCont, anotherGlobalContainer);
        assertEquals(complexNode.locCont, localContainer);
        assertEquals(complexNode.ref, anotherMySibling);
        assertEquals(complexNode.pubRef, publicRefNode);

        root.addChild(container);

        assertEquals(complexNode.globCont, anotherGlobalContainer);
        assertEquals(complexNode.locCont, localContainer);
        assertEquals(complexNode.ref, anotherMySibling);
        assertEquals(complexNode.pubRef, publicRefNode);

        root.addChild(container);

        assertEquals(complexNode.globCont, anotherGlobalContainer);
        assertEquals(complexNode.locCont, localContainer);
        assertEquals(complexNode.ref, anotherMySibling);
        assertEquals(complexNode.pubRef, publicRefNode);

        anotherContainer.removeFromParent();

        assertEquals(complexNode.globCont, globalContainer);
        assertEquals(complexNode.locCont, localContainer);
        assertEquals(complexNode.ref, mySibling);
        assertEquals(complexNode.pubRef, publicRefNode);

        root.addChild(anotherContainer);

        assertEquals(complexNode.globCont, globalContainer);
        assertEquals(complexNode.locCont, localContainer);
        assertEquals(complexNode.ref, mySibling);
        assertEquals(complexNode.pubRef, publicRefNode);

        root.addChild(container); // re-add test, nothing should change

        assertEquals(complexNode.globCont, globalContainer);
        assertEquals(complexNode.locCont, localContainer);
        assertEquals(complexNode.ref, mySibling);
        assertEquals(complexNode.pubRef, publicRefNode);

        var anotherSiblingContainer:Sprite = new Sprite(); anotherSiblingContainer.name = "SiblingContainer";
        var anotherLocalContainer:Sprite = new Sprite(); anotherLocalContainer.name = "LocalContainer";
        var anotherPublicRefNode:TextField = new TextField(100, 100, "aaa");

        root.addChild(anotherSiblingContainer);
        anotherSiblingContainer.addChild(anotherLocalContainer);
        anotherSiblingContainer.addChild(anotherPublicRefNode);

        assertEquals(complexNode.globCont, globalContainer);
        assertEquals(complexNode.locCont, localContainer);
        assertEquals(complexNode.ref, mySibling);
        assertEquals(complexNode.pubRef, publicRefNode);

        siblingContainer.removeFromParent();

        assertEquals(complexNode.globCont, globalContainer);
        assertEquals(complexNode.locCont, anotherLocalContainer);
        assertEquals(complexNode.ref, mySibling);
        assertEquals(complexNode.pubRef, anotherPublicRefNode);

        root.addChild(siblingContainer);

        assertEquals(complexNode.globCont, globalContainer);
        assertEquals(complexNode.locCont, anotherLocalContainer);
        assertEquals(complexNode.ref, mySibling);
        assertEquals(complexNode.pubRef, anotherPublicRefNode);

        anotherLocalContainer.removeFromParent();

        assertEquals(complexNode.globCont, globalContainer);
        assertEquals(complexNode.locCont, localContainer);
        assertEquals(complexNode.ref, mySibling);
        assertEquals(complexNode.pubRef, anotherPublicRefNode);

        root.addChild(anotherLocalContainer);

        assertEquals(complexNode.globCont, globalContainer);
        assertEquals(complexNode.locCont, localContainer);
        assertEquals(complexNode.ref, mySibling);
        assertEquals(complexNode.pubRef, anotherPublicRefNode);

        anotherPublicRefNode.removeFromParent();

        assertEquals(complexNode.globCont, globalContainer);
        assertEquals(complexNode.locCont, localContainer);
        assertEquals(complexNode.ref, mySibling);
        assertEquals(complexNode.pubRef, publicRefNode);

        anotherSiblingContainer.addChild(anotherPublicRefNode);

        assertEquals(complexNode.globCont, globalContainer);
        assertEquals(complexNode.locCont, localContainer);
        assertEquals(complexNode.ref, mySibling);
        assertEquals(complexNode.pubRef, publicRefNode);

        anotherSiblingContainer.removeFromParent();

        assertEquals(complexNode.globCont, globalContainer);
        assertEquals(complexNode.locCont, localContainer);
        assertEquals(complexNode.ref, mySibling);
        assertEquals(complexNode.pubRef, publicRefNode);

        localContainer.removeFromParent();

        assertEquals(complexNode.globCont, globalContainer);
        assertEquals(complexNode.locCont, null);
        assertEquals(complexNode.ref, mySibling);
        assertEquals(complexNode.pubRef, publicRefNode);

        siblingContainer.removeFromParent();

        assertEquals(complexNode.globCont, globalContainer);
        assertEquals(complexNode.locCont, null);
        assertEquals(complexNode.ref, mySibling);
        assertEquals(complexNode.pubRef, null);

        root.addChild(siblingContainer);

        assertEquals(complexNode.globCont, globalContainer);
        assertEquals(complexNode.locCont, null);
        assertEquals(complexNode.ref, mySibling);
        assertEquals(complexNode.pubRef, publicRefNode);

        siblingContainer.removeFromParent();

        assertEquals(complexNode.globCont, globalContainer);
        assertEquals(complexNode.locCont, null);
        assertEquals(complexNode.ref, mySibling);
        assertEquals(complexNode.pubRef, null);

        anotherContainer.removeFromParent();

        assertEquals(complexNode.globCont, globalContainer);
        assertEquals(complexNode.locCont, null);
        assertEquals(complexNode.ref, mySibling);
        assertEquals(complexNode.pubRef, null);

        container.removeFromParent();

        assertEquals(complexNode.globCont, null);
        assertEquals(complexNode.locCont, null);
        assertEquals(complexNode.ref, null);
        assertEquals(complexNode.pubRef, null);

        root.addChild(anotherContainer);

        assertEquals(complexNode.globCont, anotherGlobalContainer);
        assertEquals(complexNode.locCont, null);
        assertEquals(complexNode.ref, anotherMySibling);
        assertEquals(complexNode.pubRef, null);
    }
}
}

import starling.display.Quad;
import starling.display.Sprite;
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

class ComplexReferencingNode extends Node {
    [StarlingReference("Container/GlobalContainer")]
    public var globCont:Sprite;

    [StarlingReference("SiblingContainer/LocalContainer")]
    public var locCont:Sprite;

    [StarlingReference("Container/@starling.display::Sprite/mySibling")]
    public var ref:Quad;

    [StarlingReference("@starling.display::Sprite/@starling.text::TextField")]
    public var pubRef:TextField;
}
