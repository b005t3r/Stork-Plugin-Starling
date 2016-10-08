package {

import flash.display.Sprite;
import flash.system.Capabilities;
import flash.ui.Keyboard;

import navigation.DemoScreenNavigatorNode;
import navigation.screens.BlueScreenNode;
import navigation.screens.GreenScreenNode;

import starling.display.StorkRoot;

import flash.events.Event;

import starling.events.KeyboardEvent;

import stork.core.Node;

import stork.core.SceneNode;

import stork.event.SceneEvent;
import stork.starling.ArbitraryScalePolicy;
import stork.starling.StarlingPlugin;

[SWF(width="1024", height="768", backgroundColor="#cccccc", frameRate="60")]
public class Main extends Sprite {
    public function Main() {
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(event:Event):void {
        var starlingPlugin:StarlingPlugin = new StarlingPlugin(
            StorkRoot,
            this,
            new ArbitraryScalePolicy(1),
            false,
            Capabilities.isDebugger
        );

        starlingPlugin.suspendOnDeactivate = false;

        var scene:SceneNode = new SceneNode();
        scene.registerPlugin(starlingPlugin);

        scene.addEventListener(SceneEvent.SCENE_STARTED, onSceneStarted);

        scene.start();
    }

    private function onSceneStarted(event:SceneEvent):void {
        var scene:SceneNode = event.sceneNode;

        var root:StorkRoot = StorkRoot(scene.getObjectByClass(StorkRoot));
        root.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

        var nav:DemoScreenNavigatorNode = new DemoScreenNavigatorNode();
        scene.addNode(nav);

        var greenScreen:GreenScreenNode = new GreenScreenNode();
        var blueScreen:BlueScreenNode   = new BlueScreenNode();

        var nodeA:Node = new Node("NodeA");
        var nodeB:Node = new Node("NodeB");
        var nodeC:Node = new Node("NodeC");
        var nodeD:Node = new Node("NodeD");
        var nodeE:Node = new Node("NodeE");

        nav.pushScreen(greenScreen, true);

        function onKeyUp(event:KeyboardEvent):void {
            switch(event.keyCode) {
                case Keyboard.A:
                    if(scene.getNodeByName("NodeA") == null)
                        scene.addNode(nodeA);
                    else
                        scene.removeNode(nodeA);
                        break;

                case Keyboard.B:
                    if(scene.getNodeByName("NodeB") == null)
                        scene.addNode(nodeB);
                    else
                        scene.removeNode(nodeB);
                    break;

                case Keyboard.C:
                    if(scene.getNodeByName("NodeC") == null)
                        scene.addNode(nodeC);
                    else
                        scene.removeNode(nodeC);
                    break;

                case Keyboard.D:
                    if(scene.getNodeByName("NodeD") == null)
                        scene.addNode(nodeD);
                    else
                        scene.removeNode(nodeD);
                    break;

                case Keyboard.E:
                    if(scene.getNodeByName("NodeE") == null)
                        scene.addNode(nodeE);
                    else
                        scene.removeNode(nodeE);
                    break;

                case Keyboard.P:
                    if(nav.currentScreen == blueScreen)
                        nav.popScreen(true);
                    else
                        nav.pushScreen(blueScreen, true);
            }
        }
    }
}
}
