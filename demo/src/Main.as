package {

import flash.display.Sprite;

import stork.core.SceneNode;
import stork.starling.StarlingPlugin;

[SWF(width="800", height="600", backgroundColor="#aaaaaa", frameRate="60")]
public class Main extends Sprite {
    var scene:SceneNode;

    public function Main() {
        scene = new SceneNode("Demo Scene");

        var starlingPlugin:StarlingPlugin = new StarlingPlugin(SimpleDemoRoot, this);

        scene.registerPlugin(starlingPlugin);

        scene.start();

        //scene.addNode(new Stepper());
        scene.addNode(new QuadHolder());
    }
}
}

import starling.display.Quad;

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
        //trace(event.dt);
    }
}

class QuadHolder extends Node {
    [StarlingReference("@starling.display::Quad")]
    public var quad:Quad;

    public function QuadHolder() {
        super("Quad Holder");

        addEventListener(Event.ADDED_TO_SCENE, onAddedToScene);
    }

    private function onAddedToScene(event:Event):void {
        sceneNode.addEventListener(SceneStepEvent.STEP, step);
    }

    private function step(event:SceneStepEvent):void {
        if(quad == null) return;

        quad.x += 100 * event.dt;
    }
}
