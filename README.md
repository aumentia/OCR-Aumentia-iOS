OCR Framework
=======================

<p align="left" >
  <img src="http://www.aumentia.com/images/sdks/ocrsdk@2x.png" width="415" alt="Aumentia" title="Aumentia">
</p>

* Real time OCR
* **arm64 support**
* **BITCODE enabled**
* Compabitle with **XCode7.3**, **Swift 2.2** and **iOS 9**

<br>
**********************
HOW TO Objective C
**********************

## Add OCR SDK framework and bundle:
* OCRAumentia.framework
* OCRAumentiaBundle.bundle

## Add the following system frameworks and libraries:

* AssetsLibrary.framework
* AVFoundation.framework
* Accelerate.framework
* CoreMedia.framework
* CoreVideo.framework
* QuartzCore.framework
* CoreGraphics.framework
* Foundation.framework
* UIKit.framework
* libiconv.dylib
* libstdc++.6.0.9.dylib

## Import the library

```objective-c
#import <OCRAumentia/OCRAumentia.h>
```
## Objective C++
The .m file where you include the framework must be compiled supporting cpp, so change the “File Type” to “Objective-C++ Source“ or just rename it to **.mm extension**.

## Init the framework.

```objective-c
// Tesseract path
NSString *resourcePath      = [[NSBundle mainBundle] resourcePath];
NSString *pathToTessData    = [NSString stringWithFormat:@"%@/%@", resourcePath, @"OCRAumentiaBundle.bundle"];

// Set your API Key
// Set language to English ("eng")
// Set chars whitelist
self.ocr = [[ocrAPI alloc] init:@"8a83bebc51535accf9c31abdb66efc5d60e7b2ad" path:pathToTessData lang:@"eng" chars:@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
```

You can add more languages. Just add the one you like from <a target="_blank" href="https://github.com/tesseract-ocr/tessdata">https://github.com/tesseract-ocr/tessdata</a> to OCRAumentiaBundle.bundle/tessdata

## Send frames (for real time) or a single UIImage to analyze

Frame:
```objective-c

// Start the process

// image is a CVImageBufferRef
[self.ocr processRGBFrame:image result:^(UIImage *resImage)
{
    dispatch_async(dispatch_get_main_queue(), ^{

        // Display the analysed frame with bounding boxes around the matched chars
        UIImageView *resView    = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180, 240)];
        resView.image           = resImage;
        [self.view addSubview: resView];

        NSLog(@"Finished!");
    });
    }
    wordsBlock:^(NSMutableDictionary *wordsDistDict)
    {
        // Get matched words and the confidence. A value between 0 to 100.
        for(NSString *key in [wordsDistDict allKeys])
        {
        NSLog(@"Matched word %@ with confidence %@", key, [wordsDistDict objectForKey:key]);
    }
} resSize:0];

```

UIImage:
```objective-c
    // Image to analyse
    UIImage *image = [UIImage imageNamed:@"pic1.jpg"];

    NSLog(@"Analysing...");

    // Start the process
    [self.ocr processUIImage:image result:^(UIImage *resImage)
    {
        dispatch_async(dispatch_get_main_queue(), ^{

            // Display the analysed frame with bounding boxes around the matched chars
            UIImageView *resView    = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180, 240)];
            resView.image           = resImage;
            [self.view addSubview: resView];

            NSLog(@"Finished!");
        });
    }
    wordsBlock:^(NSMutableDictionary *wordsDistDict)
    {
        // Get matched words and the confidence. A value between 0 to 100.
        for(NSString *key in [wordsDistDict allKeys])
        {
            NSLog(@"Matched word %@ with confidence %@", key, [wordsDistDict objectForKey:key]);
        }
    } resSize:0];

```

<br>
**********************
HOW TO Swift
**********************

## Add the following system frameworks and libraries:

* AssetsLibrary.framework
* AVFoundation.framework
* Accelerate.framework
* CoreMedia.framework
* CoreVideo.framework
* QuartzCore.framework
* CoreGraphics.framework
* Foundation.framework
* UIKit.framework
* libiconv.dylib
* libstdc++.6.0.9.dylib


## Create a **bridging header**

Import the **OCRAumentia framework** and its **dependencies**:

```objective-c
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>
#import <CoreMotion/CoreMotion.h>
#import <AVFoundation/AVFoundation.h>

#import <OCRAumentia/OCRAumentia.h>
```

## Set **Defines Module** to **Yes**


## Init the framework.

```swift

// Set your API Key
// Set language to English ("eng")
// Set chars whitelist
// Set the path to tessdata, i.e. to the root of the OCRAumentiaBundle
let resourcePath = NSBundle.mainBundle().resourcePath;
            
let pathToTessData = resourcePath! + "/OCRAumentiaBundle.bundle";

_ocr = ocrAPI("80e899706458463676eb3b82decb95777ec698d0",
            path: pathToTessData as String,
            lang: "eng",
            chars: "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ");
```

## Send frames (for real time) or a single UIImage to analyze

Frame:
```swift

self._ocr.processRGBFrame(cameraFrame, result:{ resImage in
                    
  dispatch_async(dispatch_get_main_queue(),{
        // Display processed image: Update in main thread
        let resView:UIImageView = UIImageView(frame: CGRectMake(0, 0, 180, 240));
        resView.image = resImage;
        self.view.addSubview(resView);
    });
    
    }, wordsBlock:{ wordsDistDict in
        
        for (key, value) in wordsDistDict
        {
            print("Matched word \(key as! String) with confidence \(value)");
        }
}, resSize:0);

```

UIImage:
```swift

// Image to analyse
let image:UIImage = UIImage(named: "pic1.jpg")!;
            
self._ocr.processUIImage(image, result:{ resImage in
    // Display processed image: Update in main thread
    dispatch_async(dispatch_get_main_queue(),{
        let resView:UIImageView = UIImageView(frame: CGRectMake(0, 0, 180, 240));
        resView.image = resImage;
        self.view.addSubview(resView);
    });
    
    }, wordsBlock:{ wordsDistDict in
        
        for (key, value) in wordsDistDict
        {
            print("Matched word \(key as! String) with confidence \(value)");
        }
}, resSize:0);
            
```

<br>
**********************
Request an API Key
**********************
To use the framework you will need an API Key. To request it, just send an email to info@aumentia.com with the following details:
* Bundle Id of the application where you want to use the framework.
* Name and description of the app where you want to use the framework.
* Your ( or your company ) name.

<br>
******************
API
******************
[api.aumentia.com](http://api.aumentia.com/ocr_ios/)

<br>
******************
iOS Version
******************
7.0+

<br>
*************************
OCR Framework version
*************************
0.65

<br>
******************
Devices tested
******************
iPhone 4<br>
iPhone 4s<br>
iPhone 5<br>
iPhone 5s<br>
iPhone 6<br>
iPhone 6+<br>
iPad 2,3,4<br>
iPad Air<br>
iPad mini 1, 2, 3<br>

<br>
******************
License
******************
[LICENSE](https://github.com/aumentia/OCR-Aumentia-iOS/blob/master/LICENSE)

<br>
******************
Bugs
******************
[Issues & Requests](https://github.com/aumentia/OCR-Aumentia-iOS/issues)
