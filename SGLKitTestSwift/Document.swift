//
//  Document.swift
//  SGLKitTestSwift
//
//  Created by Colin Caufield on 2016-01-31.
//  Copyright © 2016 Secret Geometry, Inc. All rights reserved.
//

import Cocoa

class Document: NSDocument {
    
    var windowController: WindowController!
    
    override func makeWindowControllers() {
        self.windowController = WindowController()
        self.addWindowController(self.windowController)
    }
}
