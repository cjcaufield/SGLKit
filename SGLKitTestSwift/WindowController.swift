//
//  WindowController.swift
//  SGLKitTest
//
//  Created by Colin Caufield on 2014-11-17.
//  Copyright (c) 2014 Secret Geometry. All rights reserved.
//

import Cocoa

class WindowController: SGLMacWindowController {

    init() {
        super.init(windowNibName: "Window")
    }
    
    override init!(windowNibName name: String!) {
        super.init(windowNibName: name)
    }
    
    override init(window: NSWindow?) {
        super.init(window: window)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func windowTitleForDocumentDisplayName(name: String) -> String {
        
        if let customView = self.view as? View {
            
            switch customView.shape {
                case .Sphere:       return "Sphere"
                case .Torus:        return "Torus"
                case .Cone:         return "Cone"
                case .Tetrahedron:  return "Tetrahedron"
                case .Cube:         return "Cube"
                case .Octahedron:   return "Octahedron"
                case .Dodecahedron: return "Dodecahedron"
                case .Icosahedron:  return "Icosahedron"
                case .Teapot:       return "Teapot"
                default:            break
            }
        }
        
        return "Unknown"
    }
}
