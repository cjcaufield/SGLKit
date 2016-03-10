//
//  View.swift
//  SGLKit
//
//  Created by Colin Caufield on 2016-02-03.
//  Copyright © 2016 Secret Geometry Inc. All rights reserved.
//

import UIKit

class View: SGLIosSceneView {
    
    override func openGLWasPrepared() {
        
        super.openGLWasPrepared()
        
        self.userControlsCamera = true
        self.scene.showAxes = true
        self.scene.floatingOrientation = true
        self.scene.objectDistance = 4000.0
    }
}
