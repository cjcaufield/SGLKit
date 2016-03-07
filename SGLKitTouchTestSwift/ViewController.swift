//
//  ViewController.swift
//  SGLKitTouchTestSwift
//
//  Created by Colin Caufield on 2016-02-03.
//  Copyright © 2016 Secret Geometry, Inc. All rights reserved.
//

import UIKit

enum Shape: Int
{
    case SPHERE = 0
    case TORUS = 1
    case CONE = 2
    case AXII = 3
    case TETRAHEDRON = 4
    case CUBE = 6
    case OCTAHEDRON = 8
    case DODECAHEDRON = 12
    case ICOSAHEDRON = 20
    case TEAPOT = 100
}

class ViewController: SGLIosViewController {
    
    var shape = Shape.CUBE
    var shader: SGLShader!
    var cubeMesh: SGLMesh!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func setupGL() {
        
        super.setupGL()
        
        let color = vec4(1.0, 0.0, 0.0, 1.0)
        
        self.shader = SGLShader(name: "Basic")
        self.shader.setVec4(color, forName: "color")
        self.shader.setFloat(32.0, forName: "shininess")
        
        let scene = (self.view as! View).scene
        scene.addSceneShader(self.shader)
        
        self.cubeMesh = SGLMeshes.cubeMesh()
    }

    override func render() {
        
        self.context.clear(OPAQUE_BLACK)
        
        self.shader.activate()
        
        switch self.shape {
        
            case .AXII:
                break
                
            case .CUBE:
                self.shader.activate()
                self.cubeMesh.render()
                
            default:
                break
        }
        
        // CJC: hack to still show axes with render method override.
        let scene = (self.view as! View).scene
        if scene.showAxes {
            scene.renderAxes()
        }
    }

    @IBAction func changeShape(sender: AnyObject?) {
        if let tag = sender?.tag {
            if let shape = Shape(rawValue: tag) {
                self.shape = shape
            }
        }
    }
}
