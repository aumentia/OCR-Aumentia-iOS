//
//  CaptureSessionManager.m
//  HelloVisualSearch
//
//  Copyright (c) 2015 Aumentia. All rights reserved.
//
//  Written by Pablo GM <info@aumentia.com>, January 2015
//


#import "CaptureSessionManager.h"

@implementation CaptureSessionManager

@synthesize captureSession;
@synthesize previewLayer;
@synthesize stillImageOutput;
@synthesize stillImage;
@synthesize outPutSetting;
@synthesize delegate;

#pragma mark - Init

- (id)init
{
	if ((self = [super init]))
    {
		[self setCaptureSession:[[AVCaptureSession alloc] init]];
        
        // Init default values
        
        self.captureSession.sessionPreset = AVCaptureSessionPresetMedium;
        
        self.outPutSetting = [NSNumber numberWithInt:kCVPixelFormatType_32BGRA];
	}
    
	return self;
}

#pragma mark - Public Functions

- (void)addVideoPreviewLayer
{
	[self setPreviewLayer:[[AVCaptureVideoPreviewLayer alloc] initWithSession:[self captureSession]]];
	[[self previewLayer] setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
}

- (void)addVideoInput:(AVCaptureDevicePosition)_campos
{
	AVCaptureDevice *videoDevice=nil;
	
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    if (_campos == AVCaptureDevicePositionBack)
    {
        for (AVCaptureDevice *device in devices)
        {
            if ([device position] == AVCaptureDevicePositionBack) {
                videoDevice = device;
            }
        }
    }
    else if (_campos == AVCaptureDevicePositionFront)
    {
        for (AVCaptureDevice *device in devices)
        {
            if ([device position] == AVCaptureDevicePositionFront)
            {
                videoDevice = device;
            }
        }
    }
    else
        NSLog(@"Error setting camera device position.");
    
	
    if (videoDevice)
    {
        NSError *error;
		
        AVCaptureDeviceInput *videoIn = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
		
        if (!error)
        {
			if ([[self captureSession] canAddInput:videoIn])
            {
				[[self captureSession] addInput:videoIn];
            }
			else
				NSLog(@"Couldn't add video input");
		}
		else
			NSLog(@"Couldn't create video input");
	}
	else
		NSLog(@"Couldn't create video capture device");
}

- (void)addVideoOutput
{    
    // Create a VideoDataOutput and add it to the session
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
	
    [[self captureSession] addOutput:output];
	
    // Specify the pixel format
    output.videoSettings = [NSDictionary dictionaryWithObject:outPutSetting forKey:(id)kCVPixelBufferPixelFormatTypeKey];
	
    output.alwaysDiscardsLateVideoFrames = YES;
    
    // Configure your output.
    dispatch_queue_t queue = dispatch_queue_create("myQueue", NULL);
    
    [output setSampleBufferDelegate:self queue:queue];
        
}


#pragma mark - Private Functions

//- (void)addStillImageOutput
//{
//    [self setStillImageOutput:[[AVCaptureStillImageOutput alloc] init]];
//    
//    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
//    
//    [[self stillImageOutput] setOutputSettings:outputSettings];
//    
//    AVCaptureConnection *videoConnection = nil;
//    
//    for (AVCaptureConnection *connection in [[self stillImageOutput] connections])
//    {
//        for (AVCaptureInputPort *port in [connection inputPorts])
//        {
//            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
//            {
//                videoConnection = connection;
//                break;
//            }
//        }
//        if (videoConnection) {
//            [videoConnection setVideoMinFrameDuration:CMTimeMake(1, 15)];
//            break;
//        }
//    }
//    
//    [[self captureSession] addOutput:[self stillImageOutput]];
//}

- (void)captureStillImage
{
	AVCaptureConnection *videoConnection = nil;
	
    for (AVCaptureConnection *connection in [[self stillImageOutput] connections])
    {
		for (AVCaptureInputPort *port in [connection inputPorts])
        {
			if ([[port mediaType] isEqual:AVMediaTypeVideo])
            {
				videoConnection = connection;
				break;
			}
		}
		if (videoConnection) {
            break;
        }
	}
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{    
    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    if ([outPutSetting isEqualToNumber:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA]])
    {
        if([delegate respondsToSelector:@selector(processNewCameraFrameRGB:)])
            [self.delegate processNewCameraFrameRGB:pixelBuffer];
    }
    else if ([outPutSetting isEqualToNumber:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange]] ||
             [outPutSetting isEqualToNumber:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]]  )
    {
        if([delegate respondsToSelector:@selector(processNewCameraFrameYUV:)])
            [self.delegate processNewCameraFrameYUV:pixelBuffer];
    }
    else
    {
        NSLog(@"Error output video settings admited: kCVPixelFormatType_32BGRA, kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange, kCVPixelFormatType_420YpCbCr8BiPlanarFullRange");
    }
}

#pragma mark - Dealloc

- (void)dealloc
{    
	[[self captureSession] stopRunning];
    
	previewLayer        = nil;
	captureSession      = nil;
    stillImageOutput    = nil;
    stillImage          = nil;
    outPutSetting       = nil;
    delegate            = nil;
}

@end