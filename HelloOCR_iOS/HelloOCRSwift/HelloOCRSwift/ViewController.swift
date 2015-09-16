//
//  ViewController.swift
//  HelloOCRSwift
//
//  Created by Pablo GM on 11/09/15.
//  Copyright © 2015 Aumentia Technologies SL. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CameraCaptureDelegate
{
    var _ocr:ocrAPI!
    var _captureManager:CaptureSessionManager!
    var _myLoading:UIAlertController!
    var _cameraView:UIView!
    var _resView:UIImageView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let myLogo:UIImage          = UIImage(named: "aumentia®.png")!
        let myLogoView:UIImageView  = UIImageView(image: myLogo)
        myLogoView.frame            = CGRectMake(0, 0, 150, 61)
        self.view.addSubview(myLogoView)
        self.view.bringSubviewToFront(myLogoView)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        addOCR()
        
        //initCapture()
        
        processImage()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        removeCapture()
        
        removeOCR()
        
        _resView.removeFromSuperview()
        _resView = nil
    }

    
    // MARK: - Memory Management
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - OCR
    
    func addOCR()
    {
        if _ocr == nil
        {
            let resourcePath = NSBundle.mainBundle().resourcePath
            
            let pathToTessData = resourcePath! + "/OCRAumentiaBundle.bundle"
            
            _ocr = ocrAPI("80e899706458463676eb3b82decb95777ec698d0",
                path: pathToTessData as String,
                lang: "eng",
                chars: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        }
        
    }
    
    func removeOCR()
    {
        if _ocr != nil
        {
            _ocr = nil
        }
    }
    
    
    // MARK: - Analyze image
    
    func processImage()
    {
        addLoading()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
        {
            let image:UIImage = UIImage(named: "pic1.jpg")!
            
            self._ocr.processUIImage(image, result:{ resImage in
                
                dispatch_async(dispatch_get_main_queue(),{
                    let resView:UIImageView = UIImageView(frame: CGRectMake(0, 0, 180, 240))
                    resView.image = resImage
                    self.view.addSubview(resView)
                })
                
                self.removeLoading()
                
                self.removeOCR()
                
                }, wordsBlock:{ wordsDistDict in
                    
                    for (key, value) in wordsDistDict
                    {
                        print("Matched word \(key as! String) with confidence \(value)")
                    }
            })
        }
    }

    
    // MARK: - Loading
    
    func addLoading()
    {
        dispatch_async(dispatch_get_main_queue(),{
            
            self._myLoading = UIAlertController(title: "Analysing ...", message: nil, preferredStyle: .Alert)
            self.presentViewController(self._myLoading, animated: true, completion: nil)
        
        })
    }
    
    func removeLoading()
    {
        _myLoading.dismissViewControllerAnimated(true, completion: nil)
        _myLoading = nil
    }
    
    
    // MARK: - Camera management
    
    func initCapture()
    {
        // Init capture manager
        _captureManager = CaptureSessionManager()
        
        // Set delegate
        _captureManager.delegate = self
        
        // Set video streaming quality
        _captureManager.captureSession.sessionPreset = AVCaptureSessionPresetMedium
        
        _captureManager.outPutSetting = NSNumber(unsignedInt: kCVPixelFormatType_32BGRA)
        
        _captureManager.addVideoInput(AVCaptureDevicePosition.Back)
        _captureManager.addVideoOutput()
        _captureManager.addVideoPreviewLayer()
        
        let layerRect:CGRect = self.view.bounds
        
        _captureManager.previewLayer.opaque = false
        _captureManager.previewLayer.bounds = layerRect
        _captureManager.previewLayer.position = CGPointMake(CGRectGetMidX(layerRect), CGRectGetMidY(layerRect))
        
        // Create a view where we attach the AV Preview Layer
        _cameraView = UIView(frame: self.view.bounds)
        _cameraView.layer .addSublayer(_captureManager.previewLayer)
        
        // Add the view we just created as a subview to the View Controller's view
        self.view.addSubview(_cameraView)
        
        // Start
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            {
                self.startCaptureManager()
        }
    }
    
    func removeCapture()
    {
        _captureManager.captureSession.stopRunning()
        _cameraView.removeFromSuperview()
        _captureManager = nil
        _cameraView     = nil
    }
    
    func startCaptureManager()
    {
        autoreleasepool
        {
            _captureManager.captureSession.startRunning()
        }
    }
    
    func processNewCameraFrameRGB(cameraFrame: CVImageBuffer!)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            {
                self._ocr.processRGBFrame(cameraFrame, result:{ resImage in
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        
                        if self._resView == nil
                        {
                            self._resView = UIImageView(frame: CGRectMake(0, 0, 180, 240))
                            
                            self._resView.image = resImage
                            
                            self.view.addSubview(self._resView)
                        }
                        else
                        {
                            self._resView.image = resImage
                        }
                    })
                    
                    }, wordsBlock:{ wordsDistDict in
                        
                        for (key, value) in wordsDistDict
                        {
                            print("Matched word \(key as! String) with confidence \(value)")
                        }
                })
        }
    }
    
    func processNewCameraFrameYUV(cameraFrame: CVImageBuffer!)
    {

    }
}

