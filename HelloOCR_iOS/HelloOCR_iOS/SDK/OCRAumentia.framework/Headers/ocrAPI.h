/*************************************************************************
 *
 * AUMENTIA TECHNOLOGIES
 * __________________
 *
 *  Copyright Aumentia Technologies. All rights reserved 2015.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of Aumentia Technologies and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to Aumentia Technologies
 * and its suppliers and may be covered by Spain and Foreign Patents,
 * patents in process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Aumentia Technologies.
 *
 * File: ocrAPI.h
 * Description:
 * Author: Pablo GM (info@aumentia.com)
 * Created: 08/09/15.
 * Verion 0.63
 *
 *
 **************************************************************************/

#import "OCRAumentia.h"

__attribute__((__visibility__("default"))) @interface ocrAPI : NSObject

/**
 * lock to retrieve the matched words and their confidence (from 0 to 100).
 */
typedef void (^matchedWords)(NSMutableDictionary *wordsDistDict);
/**
 * Block to retrieve the analyzed frame with a bounding box around the detected words.
 */
typedef void (^imageResult)(UIImage *imageRes);

/**
 * @brief   Init OCR instance.
 *
 * @param   key License Key
 * @param   path Father path where the tessdata is stored
 * @param   lang Tesseract language used for the recognition
 * @param   chars Tesseract chars whitelist
 *
 * @return  OCR instance
 */
- (id)init:(NSString *)key path:(NSString*)path lang:(NSString*)lang chars:(NSString*)chars OCR_AVAILABLE(OCR_SDK_V_0_5_0);

/**
 *  @brief Process an image buffer and detect motion.
 *  Camera output settings should be <b>kCVPixelFormatType_32BGRA</b>
 *
 *  @param cameraFrame Image buffer input to be analysed.
 *
 *  @param result Block to retrieve the analyzed frame with a bounding box around the detected words.
 *
 *  @param wordsBlock Block to retrieve the matched words and their confidence (from 0 to 100).
 */
- (void)processRGBFrame:(CVImageBufferRef)cameraFrame result:(imageResult)result wordsBlock:(matchedWords)wordsBlock OCR_AVAILABLE(OCR_SDK_V_0_5_0);

/**
 *  @brief Process a UIImage
 *
 *  @param image UIImage to analyze.
 *
 *  @param result Block to retrieve the analyzed frame with a bounding box around the detected words.
 *
 *  @param wordsBlock Block to retrieve the matched words and their confidence (from 0 to 100).
 */
- (void)processUIImage:(UIImage*)image result:(imageResult)result wordsBlock:(matchedWords)wordsBlock OCR_AVAILABLE(OCR_SDK_V_0_5_0);

@end