import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!

        // Set the scene to the view
//        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionObjects = ARReferenceObject.referenceObjects(inGroupNamed: "AR Resources", bundle: nil)!

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let objectAnchor = anchor as? ARObjectAnchor else { return nil }
        let node = SCNNode()
        node.addChildNode({
            let n = SCNNode()
            let box = SCNBox(width: CGFloat(objectAnchor.referenceObject.extent[0]),
                             height: CGFloat(objectAnchor.referenceObject.extent[1]),
                             length: CGFloat(objectAnchor.referenceObject.extent[2]),
                             chamferRadius: 0.01)
            box.firstMaterial!.diffuse.contents = UIColor.green.withAlphaComponent(0.4)
            n.geometry = box
            n.transform = SCNMatrix4MakeTranslation(0,
                                                    Float(box.height / 2),
                                                    0)
            return n
        }())
//        node.addChildNode({
//            let pn = SCNNode()
//            let n = SCNNode()
//            let text = SCNText(string: "strawberry", extrusionDepth: 0.01)
//            text.font = .systemFont(ofSize: 0.1)
//            text.firstMaterial!.diffuse.contents = UIColor.white.withAlphaComponent(0.4)
//            let (min, max) = text.boundingBox
//            n.geometry = text
//            n.pivot = SCNMatrix4MakeTranslation((max.x - min.x) / 2,
//                                                (max.y - min.y) / 2,
//                                                (max.z - min.z) / 2)
//            n.position = SCNVector3(0,
//                                    -1 + objectAnchor.referenceObject.center[1] + objectAnchor.referenceObject.extent[1],
//                                    0)
////            n.transform = SCNMatrix4MakeTranslation(
////                objectAnchor.referenceObject.center[0],
////                objectAnchor.referenceObject.center[1] + objectAnchor.referenceObject.extent[1],
////                objectAnchor.referenceObject.center[2])
//            pn.constraints = [{
//                let c = SCNBillboardConstraint()
//                c.freeAxes = .Y
//                return c
//                }()]
//            pn.addChildNode(n)
//            return pn
//            }())
        node.addChildNode({
            let n = SCNNode()
            let scene = SCNScene(named: "art.scnassets/strawberry.scn")!
            let strawberry = scene.rootNode.childNode(withName: "strawberry", recursively: true)!
            let plane = strawberry.geometry as! SCNPlane
            n.addChildNode(strawberry)
            n.transform = SCNMatrix4MakeTranslation(
                0,
                objectAnchor.referenceObject.extent[1] + Float(plane.height / 2),
                0)
            return n
            }())
        node.simdTransform = objectAnchor.transform
        return node
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
