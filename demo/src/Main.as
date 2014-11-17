package {

import flash.display.Sprite;

import stork.core.SceneNode;
import stork.starling.StarlingPlugin;

[SWF(width="800", height="600", backgroundColor="#000000", frameRate="60")]
public class Main extends Sprite {
    private var scene:SceneNode;

    public function Main() {
        scene = new SceneNode("Demo Scene");

        var starlingPlugin:StarlingPlugin = new StarlingPlugin(PongDemoRoot, this);
        scene.registerPlugin(starlingPlugin);

        scene.addNode(new BallController());
        scene.addNode(new LeftPaddleController());
        scene.addNode(new RightPaddleController());

        scene.start();
    }
}
}
