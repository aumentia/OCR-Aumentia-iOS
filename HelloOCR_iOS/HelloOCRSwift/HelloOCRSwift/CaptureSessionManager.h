//
//  CaptureSessionManager.h
//  HelloVisualSearch
//
//  Copyright (c) 2015 Aumentia. All rights reserved.
//
//  Written by Pablo GM <info@aumentia.com>, January 2015
//


#import <CoreMedia/CoreMedia.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@protocol CameraCaptureDelegate<NSObject>

@optional

/**
 *  @brief Callback called each camera frame.
 *  @param Camare buffer frame in YUV
 */
- (void)processNewCameraFrameYUV:(CVImageBufferRef)cameraFrame;

/**
 *  @brief Callback called each camera frame.
 *  @param Camare buffer frame in RGB
 */
- (void)processNewCameraFrameRGB:(CVImageBufferRef)cameraFrame;

@end

@interface CaptureSessionManager : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>
{
    
}

@property (strong,nonatomic) AVCaptureVideoPreviewLayer     *previewLayer;
@property (strong,nonatomic) AVCaptureSession               *captureSession;
@property (strong,nonatomic) AVCaptureStillImageOutput      *stillImageOutput;
@property (strong,nonatomic) UIImage                        *stillImage;
@property (strong,nonatomic) NSNumber                       *outPutSetting;
@property (weak, nonatomic) id<CameraCaptureDelegate>       delegate;

/**
 *  @brief Add video input: front or back camera:
 *  AVCaptureDevicePositionBack
 *  AVCaptureDevicePositionFront
 */
- (void)addVideoInput:(AVCaptureDevicePosition)_campos;

/**
 *  @brief Add video output
 */
- (void)addVideoOutput;

/**
 *  @brief Add preview layer
 */
- (void)addVideoPreviewLayer;

@end