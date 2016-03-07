//
//  View.swift
//  SGLKitTest
//
//  Created by Colin Caufield on 2014-11-17.
//  Copyright (c) 2014 Secret Geometry. All rights reserved.
//

enum Shape: Int {
    
    case Sphere = 0
    case Torus = 1
    case Cone = 2
    case Axii = 3
    case Tetrahedron = 4
    case Cube = 6
    case Octahedron = 8
    case Dodecahedron = 12
    case Icosahedron = 20
    case Teapot = 100
}


class View: SGLMacSceneView {

    var shape = Shape.Cube
    var cubeMesh: SGLMesh?
    var cubeShader: SGLShader?
    
    override init(frame: NSRect) {
        super.init(frame: frame)
    }
    
    override init?(frame frameRect: NSRect, pixelFormat format: NSOpenGLPixelFormat?) {
        super.init(frame: frameRect, pixelFormat: format)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func openGLWasPrepared() {
        
        super.openGLWasPrepared()
        
        self.userControlsCamera = true
        self.scene.clearColor = OPAQUE_BLACK
        self.scene.showAxes = true
        self.scene.objectDistance = 4000.0
        
        let color = vec4(x: 0.5, y: 0.5, z: 0.5, w: 1.0)
        
        self.cubeShader = SGLShader(name: "Basic")
        self.cubeShader!.setVec4(color, forName: "color")
        self.cubeShader!.setFloat(32.0, forName: "shininess")
        self.scene.addSceneShader(self.cubeShader)
        
        self.cubeMesh = SGLMeshes.cubeMesh()!
    }
    
    override func render() {

        super.render()
        
        switch self.shape {
            
            case .Axii:
                break;
                
            case .Cube:
                self.cubeShader!.activate()
                self.cubeMesh!.render()
                
            default:
                assert(false)
        }
    }

    @IBAction func changeShape(sender: AnyObject?) {
        if let tag = sender?.tag() {
            if let shape = Shape(rawValue: tag) {
                self.shape = shape
                self.window?.windowController?.synchronizeWindowTitleWithDocumentName()
            }
        }
    }
}
