//
//  ViewController.m
//  HelloOCR_iOS
//
//  Created by Pablo GM on 09/09/15.
//  Copyright (c) 2015 Aumentia Technologies SL. All rights reserved.
//

#import "ViewController.h"

#import <OCRAumentia/OCRAumentia.h>

@interface ViewController ()

@property (strong, nonatomic) ocrAPI *ocr;
@property (strong, nonatomic) CaptureSessionManager *captureManager;
@property (strong, nonatomic) UIView *cameraView;
@property (strong, nonatomic) UIAlertController *myLoading;

@end

@implementation ViewController


#pragma mark - View Life Cycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    UIImage *myLogo         = [UIImage imageNamed:@"aumentia®.png"];
    UIImageView *myLogoView = [[UIImageView alloc] initWithImage:myLogo];
    [myLogoView setFrame:CGRectMake(0, 0, 150, 61)];
    [self.view addSubview:myLogoView];
    [self.view bringSubviewToFront:myLogoView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addOCR];
    
    [self initCapture];
    
    //[self processImage];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeCapture];
    
    [self removeOCR];
}


#pragma mark - OCR

- (void)addOCR
{
    if ( !self.ocr )
    {
        NSString *resourcePath      = [[NSBundle mainBundle] resourcePath];
        NSString *pathToTessData    = [NSString stringWithFormat:@"%@/%@", resourcePath, @"OCRAumentiaBundle.bundle"];
        
        self.ocr = [[ocrAPI alloc] init:@"6de17574a4b578048a9dca61ad5096f8c6a21cd2" path:pathToTessData lang:@"eng" chars:@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    }
}

- (void)removeOCR
{
    if ( self.ocr )
    {
        self.ocr = nil;
    }
}


#pragma mark - Analyze image

- (void)processImage
{
    [self addLoading];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        UIImage *image = [UIImage imageNamed:@"pic1.jpg"];
        
        [self.ocr processUIImage:image result:^(UIImage *resImage)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 UIImageView *resView    = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180, 240)];
                 resView.image           = resImage;
                 [self.view addSubview: resView];
                 
                 [self removeLoading];
                 
                 [self removeOCR];
             });
         }
         wordsBlock:^(NSMutableDictionary *wordsDistDict)
         {
             for(NSString *key in [wordsDistDict allKeys])
             {
                 NSLog(@"Matched word %@ with confidence %@", key, [wordsDistDict objectForKey:key]);
             }
         }];
        
    });
}


#pragma mark - Loading

- (void)addLoading
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.myLoading  =   [UIAlertController
                                      alertControllerWithTitle:@"Analysing ..."
                                      message:nil
                                      preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:self.myLoading animated:YES completion:nil];
        
    });
}

- (void)removeLoading
{
    [self.myLoading dismissViewControllerAnimated:YES completion:nil];
    self.myLoading  = nil;
}


#pragma mark - Add external camera

- (void)initCapture {
    
    // init capture manager
    self.captureManager = [[CaptureSessionManager alloc] init];
    
    self.captureManager.delegate = self;
    
    // set video streaming quality
    self.captureManager.captureSession.sessionPreset = AVCaptureSessionPresetMedium;
    
    [self.captureManager setOutPutSetting:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA]]; //kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange, kCVPixelFormatType_420YpCbCr8BiPlanarFullRange or kCVPixelFormatType_32BGRA
    
    [self.captureManager addVideoInput:AVCaptureDevicePositionBack]; //AVCaptureDevicePositionFront / AVCaptureDevicePositionBack
    [self.captureManager addVideoOutput];
    [self.captureManager addVideoPreviewLayer];
    
    CGRect layerRect = self.view.bounds;
    
    [[self.captureManager previewLayer] setOpaque: 0];
    [[self.captureManager previewLayer] setBounds:layerRect ];
    [[self.captureManager previewLayer] setPosition:CGPointMake( CGRectGetMidX(layerRect), CGRectGetMidY(layerRect) ) ];
    
    // create a view, on which we attach the AV Preview layer
    self.cameraView = [[UIView alloc] initWithFrame:self.view.bounds];
    [[self.cameraView layer] addSublayer:[self.captureManager previewLayer]];
    
    // add the view we just created as a subview to the View Controller's view
    [self.view addSubview: self.cameraView];
    
    // start !
    dispatch_async(dispatch_get_main_queue(), ^{
        [self start_captureManager];
    });
}

- (void)removeCapture
{
    [self.captureManager.captureSession stopRunning];
    [self.cameraView removeFromSuperview];
    self.captureManager     = nil;
    self.cameraView         = nil;
}

- (void)start_captureManager
{
    @autoreleasepool
    {
        [[self.captureManager captureSession] startRunning];
    }
}


#pragma mark - External Camera Delegates

- (void)processNewCameraFrameRGB:(CVImageBufferRef)cameraFrame
{
    //NSLog(@"Analysing...");
    
    [self.ocr processRGBFrame:cameraFrame result:^(UIImage *resImage)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             UIImageView *resView    = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180, 240)];
             resView.image           = resImage;
             [self.view addSubview: resView];
             
             //NSLog(@"Finished...");
         });
     }
                   wordsBlock:^(NSMutableDictionary *wordsDistDict)
     {
         for(NSString *key in [wordsDistDict allKeys])
         {
             NSLog(@"Matched word %@ with confidence %@", key, [wordsDistDict objectForKey:key]);
         }
     }];
}

- (void)processNewCameraFrameYUV:(CVImageBufferRef)cameraFrame
{
    
}


#pragma mark - Memory Management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
