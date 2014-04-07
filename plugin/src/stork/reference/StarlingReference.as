/**
 * User: booster
 * Date: 30/01/14
 * Time: 14:11
 */
package stork.reference {
import flash.utils.getDefinitionByName;

import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.StorkRoot;
import starling.events.Event;

import stork.core.Node;
import stork.core.SceneNode;
import stork.core.reference.Reference;
import stork.event.Event;
import stork.event.SceneObjectEvent;

public class StarlingReference extends Reference {
    public static const TAG_NAME:String = "StarlingReference";

    private var _referenced:DisplayObject;

    private var _compiledSegments:Vector.<CompiledReferenceSegment> = new <CompiledReferenceSegment>[];

    public function StarlingReference(referencing:Node, propertyName:String, path:String) {
        super(referencing, propertyName, path);

        compile();

        var sceneNode:SceneNode = _referencing.sceneNode;

        if(sceneNode == null) {
            _referencing.addEventListener(stork.event.Event.ADDED_TO_SCENE, onReferencingAddedToScene);
        }
        else {
            _referencing.addEventListener(stork.event.Event.REMOVED_FROM_SCENE, onReferencingRemovedFromScene);

            var root:StorkRoot = sceneNode.getObjectByClass(StorkRoot) as StorkRoot;

            if(root == null) {
                sceneNode.addEventListener(SceneObjectEvent.OBJECT_ADDED_TO_SCENE, onRootAddedToScene);
            }
            else {
                sceneNode.addEventListener(SceneObjectEvent.OBJECT_REMOVED_FROM_SCENE, onRootRemovedFromScene);

                var child:DisplayObject = findReferenced(root);

                if(child == null) {
                    root.addEventListener(starling.events.Event.ADDED, onSomethingAddedToRoot);
                }
                else {
                    setReferenced(child);

                    child.addEventListener(starling.events.Event.REMOVED_FROM_STAGE, onReferencedRemovedFromStarlingStage);
                }
            }
        }
    }

    override public function dispose():void {
        _referencing.removeEventListener(stork.event.Event.ADDED_TO_SCENE, onReferencingAddedToScene);
        _referencing.removeEventListener(stork.event.Event.REMOVED_FROM_SCENE, onReferencingRemovedFromScene);

        var sceneNode:SceneNode = _referencing.sceneNode;

        if(sceneNode != null) {
            sceneNode.removeEventListener(SceneObjectEvent.OBJECT_ADDED_TO_SCENE, onRootAddedToScene);
            sceneNode.removeEventListener(SceneObjectEvent.OBJECT_REMOVED_FROM_SCENE, onRootRemovedFromScene);

            var root:StorkRoot = sceneNode.getObjectByClass(StorkRoot) as StorkRoot;

            if(root != null)
                root.removeEventListener(starling.events.Event.ADDED, onSomethingAddedToRoot);
        }

        if(_referenced != null)
            _referenced.removeEventListener(starling.events.Event.REMOVED_FROM_STAGE, onReferencedRemovedFromStarlingStage);

        super.dispose();
    }

    private function compile():void {
        var pathParts:Array = _path.split('/');

        _compiledSegments = new <CompiledReferenceSegment>[];

        var count:int = pathParts.length;
        for(var i:int = 0; i < count; i++) {
            var pathPart:String = pathParts[i];

            var segment:CompiledReferenceSegment;

            // class name
            if(pathPart.charCodeAt(0) == "@".charCodeAt(0)) {
                pathPart = pathPart.substr(1, pathPart.length - 1);
                pathPart = getFullClassName(pathPart);
                var clazz:Class = getDefinitionByName(pathPart) as Class;

                segment = new CompiledReferenceSegment(CompiledReferenceSegment.CLASS, clazz);
            }
            // component name
            else {
                segment = new CompiledReferenceSegment(CompiledReferenceSegment.NODE_NAME, pathPart);
            }

            _compiledSegments[_compiledSegments.length] = segment;
        }
    }

    private function findReferenced(container:DisplayObjectContainer, ignoredChild:DisplayObject = null):DisplayObject {
        var child:DisplayObject = findReferencedImpl(container, 0, ignoredChild);

        return child;
    }

    private function findReferencedImpl(container:DisplayObjectContainer, segmentIndex:int, ignoredChild:DisplayObject):DisplayObject {
        var segment:CompiledReferenceSegment = _compiledSegments[segmentIndex];

        var count:int = container.numChildren;
        for(var i:int = 0; i < count; i++) {
            var child:DisplayObject = container.getChildAt(i);

            if(/* child.beingRemoved || */ ignoredChild == child || ! segment.matches(child))
                continue;

            // last segment
            if(segmentIndex == _compiledSegments.length - 1) {
                return child;
            }
            // middle segment, has to be a ContainerNode
            else {
                var nextChild:DisplayObject = findReferencedImpl(child as DisplayObjectContainer, segmentIndex + 1, ignoredChild);

                if(nextChild != null)
                    return nextChild;
            }
        }

        return null;
    }

    private function setReferenced(value:DisplayObject):void {
        if(value != null) {
            if(value.parent == null)
                throw new UninitializedError("referenced object is not added to parent");

            if(_referenced != null)
                throw new ArgumentError("unset previously referenced property before setting a new one");

            _referenced                 = value;
            _referencing[_propertyName] = value;
        }
        else {
            if(_referenced == null)
                throw new ArgumentError("referenced property already unset");

            _referenced                 = null;
            _referencing[_propertyName] = null;
        }
    }

    private function onReferencingAddedToScene(event:stork.event.Event):void {
        _referencing.removeEventListener(stork.event.Event.ADDED_TO_SCENE, onReferencingAddedToScene);
        _referencing.addEventListener(stork.event.Event.REMOVED_FROM_SCENE, onReferencingRemovedFromScene);

        var sceneNode:SceneNode = _referencing.sceneNode;
        var root:StorkRoot      = sceneNode.getObjectByClass(StorkRoot) as StorkRoot;

        if(root == null) {
            sceneNode.addEventListener(SceneObjectEvent.OBJECT_ADDED_TO_SCENE, onRootAddedToScene);
        }
        else {
            sceneNode.addEventListener(SceneObjectEvent.OBJECT_REMOVED_FROM_SCENE, onRootRemovedFromScene);

            var child:DisplayObject = findReferenced(root);

            if(child == null) {
                root.addEventListener(starling.events.Event.ADDED, onSomethingAddedToRoot);
            }
            else {
                setReferenced(child);

                child.addEventListener(starling.events.Event.REMOVED_FROM_STAGE, onReferencedRemovedFromStarlingStage);
            }
        }
    }

    private function onReferencingRemovedFromScene(event:stork.event.Event):void {
        _referencing.removeEventListener(stork.event.Event.REMOVED_FROM_SCENE, onReferencingRemovedFromScene);

        var sceneNode:SceneNode = _referencing.sceneNode;
        var root:StorkRoot      = sceneNode.getObjectByClass(StorkRoot) as StorkRoot;

        if(root == null) {
            sceneNode.removeEventListener(SceneObjectEvent.OBJECT_ADDED_TO_SCENE, onRootAddedToScene);
        }
        else {
            sceneNode.removeEventListener(SceneObjectEvent.OBJECT_REMOVED_FROM_SCENE, onRootRemovedFromScene);

            if(_referenced == null) {
                root.removeEventListener(starling.events.Event.ADDED, onSomethingAddedToRoot);
            }
            else {
                _referenced.removeEventListener(starling.events.Event.REMOVED_FROM_STAGE, onReferencedRemovedFromStarlingStage);
                setReferenced(null);
            }
        }

        _referencing.addEventListener(stork.event.Event.ADDED_TO_SCENE, onReferencingAddedToScene);
    }

    private function onRootAddedToScene(event:SceneObjectEvent):void {
        var sceneNode:SceneNode = event.sceneNode;
        var root:StorkRoot      = sceneNode.getObjectByClass(StorkRoot) as StorkRoot;

        sceneNode.removeEventListener(SceneObjectEvent.OBJECT_ADDED_TO_SCENE, onRootAddedToScene);
        sceneNode.addEventListener(SceneObjectEvent.OBJECT_REMOVED_FROM_SCENE, onRootRemovedFromScene);

        var child:DisplayObject = findReferenced(root);

        if(child == null) {
            root.addEventListener(starling.events.Event.ADDED, onSomethingAddedToRoot);
        }
        else {
            setReferenced(child);

            child.addEventListener(starling.events.Event.REMOVED_FROM_STAGE, onReferencedRemovedFromStarlingStage);
        }
    }

    private function onRootRemovedFromScene(event:SceneObjectEvent):void {
        var sceneNode:SceneNode = event.sceneNode;
        var root:StorkRoot      = sceneNode.getObjectByClass(StorkRoot) as StorkRoot;

        sceneNode.removeEventListener(SceneObjectEvent.OBJECT_REMOVED_FROM_SCENE, onRootRemovedFromScene);

        if(_referenced == null) {
            root.removeEventListener(starling.events.Event.ADDED, onSomethingAddedToRoot);
        }
        else {
            _referenced.removeEventListener(starling.events.Event.REMOVED_FROM_STAGE, onReferencedRemovedFromStarlingStage);
            setReferenced(null);
        }

        sceneNode.addEventListener(SceneObjectEvent.OBJECT_ADDED_TO_SCENE, onRootAddedToScene);
    }

    private function onSomethingAddedToRoot(event:starling.events.Event):void {
        var root:StorkRoot = event.currentTarget as StorkRoot; // this listener is added to StorkRoot
        var child:DisplayObject = findReferenced(root);

        if(child == null)
            return;

        root.removeEventListener(starling.events.Event.ADDED, onSomethingAddedToRoot);

        setReferenced(child);

        child.addEventListener(starling.events.Event.REMOVED_FROM_STAGE, onReferencedRemovedFromStarlingStage);
    }

    private function onReferencedRemovedFromStarlingStage(event:starling.events.Event):void {
        _referenced.removeEventListener(starling.events.Event.REMOVED_FROM_STAGE, onReferencedRemovedFromStarlingStage);

        var root:StorkRoot      = _referenced.root as StorkRoot;
        var child:DisplayObject = findReferenced(root, _referenced);

        setReferenced(null);

        if(child == null) {
            root.addEventListener(starling.events.Event.ADDED, onSomethingAddedToRoot);
        }
        else {
            setReferenced(child);

            child.addEventListener(starling.events.Event.REMOVED_FROM_STAGE, onReferencedRemovedFromStarlingStage);
        }
    }
}
}

import starling.display.DisplayObject;

internal class CompiledReferenceSegment {
    public static const CLASS:int       = 1;
    public static const NODE_NAME:int   = 2;

    public var type:int;
    public var value:*;

    public function CompiledReferenceSegment(type:int, value:*) {
        this.type = type;
        this.value = value;
    }

    public function matches(node:DisplayObject):Boolean {
        switch(type) {
            case CompiledReferenceSegment.CLASS:
                return (node is (value as Class));

            case CompiledReferenceSegment.NODE_NAME:
                return node.name == (value as String);

            default:
                throw new Error("invalid segment type: " + type);
        }
    }
}
