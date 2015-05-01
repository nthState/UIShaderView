// The MIT License (MIT)
//
// Copyright (c) 2015 Chris Davis, nthState Ltd, contact@nthstate.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
//  UIShaderView.swift
//  UIShaderView
//
//  Created by Chris Davis on 30/04/2015.
//  Copyright (c) 2015 nthState. All rights reserved.
//

import UIKit
import SceneKit

class UIShaderView : UIView
{
    var scene:SCNScene!
    var sceneView:SCNView!
    var plane:SCNPlane!
    var childNode:SCNNode!
    var lightNode:SCNNode!
    var ambientLightNode:SCNNode!
    
    /**
    An enum to quickly use the shader types, the keys are too
    long to remember.
    
    */
    enum ShaderType : String
    {
        case Geometry = "SCNShaderModifierEntryPointGeometry"
        case LightingModel = "SCNShaderModifierEntryPointLightingModel"
    }
    
    // MARK: Initalization
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    init()
    {
        super.init(frame: CGRectZero)
        setup()
    }
    
    // MARK: Setup
    
    func setup()
    {
        createSceneView()
    }
    
    // MARK: Enable/Disable Shader
    
    /// Enable the shader.
    func enableShader()
    {
        sceneView.hidden = false
    }
    
    /// Disable the shader
    func disableShader()
    {
        sceneView.hidden = true
    }
    
    // MARK: Play/Stop sceneView
    
    /// Enable the shader.
    func play()
    {
        sceneView.play(nil)
    }
    
    /// Disable the shader
    func stop()
    {
        sceneView.stop(nil)
    }
    
    // MARK: Set verticies count on mesh
    
    /// Horizontal vertices count
    var horizontalVertices:Int = 100
    
    /// Vertical vertices count
    var verticalVertices:Int = 100
    
    // MARK: Debug
    
    /**
    Enable debug camera control
    
    :param: true/false
    */
    var debugEnabledCameraControl:Bool = false {
        didSet {
            sceneView.allowsCameraControl = debugEnabledCameraControl
        }
    }
    
    /**
    Enable debug lights
    
    :param: true/false
    */
    var debugEnableDefaultLights:Bool = false {
        didSet {
            lightNode.hidden = !debugEnableDefaultLights
            ambientLightNode.hidden = !debugEnableDefaultLights
        }
    }
    
    // MARK: Set the Shader for the view
    
    /**
    Add shader from code
    
    :param: shaderType ie SCNShaderModifierEntryPointGeometry.
    :param: shader the actual code.
    */
    func addShaderFromString(shaderType:ShaderType, shader:String)
    {
        if childNode.geometry!.shaderModifiers == nil
        {
            childNode.geometry!.shaderModifiers = [NSObject : AnyObject]()
        }
        
        childNode.geometry!.shaderModifiers![shaderType.rawValue] = shader
    }
    
    /**
    Add shader from file
    
    :param: shaderType ie SCNShaderModifierEntryPointGeometry.
    :param: shader the actual code.
    */
    func addShaderFromFile(shaderType:ShaderType, shader:String)
    {
        let code = String(contentsOfFile: NSBundle.mainBundle().pathForResource(shader, ofType: "shader")!, encoding: NSUTF8StringEncoding, error: nil)!
        addShaderFromString(shaderType, shader: code)
    }
    
    // MARK: Set key-value for uniforms in shader
    
    func setShaderValueForKey(value:AnyObject, forKey key:String)
    {
        childNode.geometry?.setValue(value, forKey: key)
    }
    
    // MARK: Texture
    
    /**
    Add texture
    
    :param: image to set on plane
    */
    func addTexture(image:UIImage)
    {
        plane.firstMaterial!.ambient.contents = image
        plane.firstMaterial!.diffuse.contents = image
    }
    
    // MARK: Create SceneView
    
    func createSceneView()
    {
        sceneView = SCNView(frame: self.bounds)
        sceneView.backgroundColor = UIColor.clearColor()
        scene = SCNScene()
        
        addDefaultLights()
        
        addNodeForShader()
        
        play()
        
        sceneView.scene = scene
        
        // Add sceneView as a child of this view
        self.addSubview(sceneView)
    }
    
    /**
    Build node onto which we apply the shader, add it to the scene
    
    */
    func addNodeForShader()
    {
        
        let tag = self.tag
        
        plane = SCNPlane(width: self.frame.size.width, height: self.frame.size.height)
        plane.firstMaterial!.ambient.contents = self.backgroundColor
        plane.firstMaterial!.diffuse.contents = self.backgroundColor
        
        plane.widthSegmentCount = horizontalVertices
        plane.heightSegmentCount = verticalVertices
        childNode = SCNNode(geometry: plane)
        
        scene.rootNode.addChildNode(childNode)
    }
    
    /**
    Add the default lights to the scene

    */
    func addDefaultLights()
    {
        lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor.redColor()
        scene.rootNode.addChildNode(ambientLightNode)
    }
    
}
