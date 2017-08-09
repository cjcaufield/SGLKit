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
    
    override func windowTitle(forDocumentDisplayName name: String) -> String {
        
        if let customView = self.view as? View {
            
            switch customView.shape {
                case .sphere:       return "Sphere"
                case .torus:        return "Torus"
                case .cone:         return "Cone"
                case .tetrahedron:  return "Tetrahedron"
                case .cube:         return "Cube"
                case .octahedron:   return "Octahedron"
                case .dodecahedron: return "Dodecahedron"
                case .icosahedron:  return "Icosahedron"
                case .teapot:       return "Teapot"
                default:            break
            }
        }
        
        return "Unknown"
    }
}
