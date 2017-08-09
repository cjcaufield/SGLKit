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
    case sphere = 0
    case torus = 1
    case cone = 2
    case axii = 3
    case tetrahedron = 4
    case cube = 6
    case octahedron = 8
    case dodecahedron = 12
    case icosahedron = 20
    case teapot = 100
}

class ViewController: SGLIosViewController {
    
    var shape = Shape.cube
    var shader: SGLShader!
    var cubeMesh: SGLMesh!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func setupGL() {
        
        super.setupGL()
        
        let color = vec4(1.0, 1.0, 1.0, 1.0)
        
        self.shader = SGLShader(name: "Basic")
        self.shader.setVec4(color, forName: "color")
        self.shader.setFloat(32.0, forName: "shininess")
        
        let scene = (self.view as! View).scene
        scene?.addLitShader(self.shader)
        
        self.cubeMesh = SGLMeshes.cubeMesh()
    }

    override func render() {
        
        self.context.clear(OPAQUE_BLACK)
        
        self.shader.activate()
        
        switch self.shape {
        
            case .axii:
                break
                
            case .cube:
                self.shader.activate()
                self.cubeMesh.render()
                
            default:
                break
        }
        
        // CJC: hack to still show axes with render method override.
        let scene = (self.view as! View).scene
        if (scene?.showAxes)! {
            scene?.renderAxes()
        }
    }

    @IBAction func changeShape(_ sender: AnyObject?) {
        if let tag = sender?.tag {
            if let shape = Shape(rawValue: tag) {
                self.shape = shape
            }
        }
    }
}
