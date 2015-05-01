//
//  ViewController.swift
//  UIShaderView
//
//  Created by Chris Davis on 30/04/2015.
//  Copyright (c) 2015 nthState. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var shaderView:UIShaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shaderView.debugEnabledCameraControl = true
        shaderView.debugEnableDefaultLights = true

        shaderView.addShaderFromFile(.LightingModel, shader: "sm_light")
        shaderView.addShaderFromFile(.Geometry, shader: "sm_geom")
        
        let texture:UIImage = UIImage(named: "texture")!
        shaderView.addTexture(texture)
        
        shaderView.setShaderValueForKey(30.0, forKey: "Amplitude")
        
    }

}
