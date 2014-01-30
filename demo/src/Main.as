package {

import flash.display.StorkMain;

import stork.core.SceneNode;
import stork.starling.StarlingPlugin;

[SWF(width="800", height="600", backgroundColor="#aaaaaa", frameRate="60")]
public class Main extends StorkMain {
    var scene:SceneNode;

    public function Main() {
        scene = new SceneNode("Demo Scene");

        var starlingPlugin:StarlingPlugin = new StarlingPlugin(SimpleDemoRoot);

        scene.registerPlugin(starlingPlugin);

        scene.start();

        scene.addNode(new Stepper());
    }
}
}

import stork.core.Node;
import stork.event.Event;
import stork.event.SceneStepEvent;

class Stepper extends Node {
    public function Stepper() {
        addEventListener(Event.ADDED_TO_SCENE, onAddedToScene);
    }

    private function onAddedToScene(event:Event):void {
        sceneNode.addEventListener(SceneStepEvent.STEP, onStep);
    }

    private function onStep(event:SceneStepEvent):void {
        trace(event.dt);
    }
}
