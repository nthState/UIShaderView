# UIShaderView

> by Chris Davis of nthState

**Overview**

This is a UIView subclass that allows you to apply shaders to your UIView components.

**What it looks like**

![My image](blah.jpg)

**How to use**



    import UIKit
    
    class ViewController: UIViewController {
    
    	// Have an outlet, or create a view programmatically
    	@IBOutlet var shaderView:UIShaderView!
    
    	override func viewDidLoad()
    	{
            super.viewDidLoad()
    		//Debug always helps
    		shaderView.debugCameraControl = true
    
    		//Load in shaders to use
    		shaderView.addShaderFromFile(.LightingModel, shader: "sm_light")
    		shaderView.addShaderFromFile(.Geometry, shader: "sm_wobble")
    	
    		//Optionally screenshot the view and pass that to the shader as a texture  
    		shaderView.screenshotAndApplyToShader()
    	
    		//Animate some shader uniform values
    		shaderView.setShaderValueForKey(30.0, forKey: "Amplitude")
    	}
    
    }


**Thoughts**

This is just a proof-of-concept, I wanted to deform a view using geometry shaders.
No-doubt this feature will come directly from Apple at some point...

Use it wisely, I'm guestimating that more than 2 views will slow down your system.

**Technical**

It uses SceneKit internally, written in Swift 1.2


