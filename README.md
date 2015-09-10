OCR Framework
=======================

<p align="left" >
  <img src="http://www.aumentia.com/images/sdks/ocrsdk@2x.png" width="415" alt="Aumentia" title="Aumentia">
</p>

* Real time OCR
* **arm64 support**
* **BITCODE enabled**

Check the "bitcode" branch to get the project updated for **XCode 7** and **iOS 9.1**

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
}];

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
    }];

```

<br>
**********************
HOW TO Swift
**********************
TODO

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
6.0+

<br>
*************************
OCR Framework version
*************************
0.5

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
