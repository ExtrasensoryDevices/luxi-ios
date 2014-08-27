//
//  ImageHelper.m
//  Luxi
//
//  Created by Alina Kholcheva on 2013-10-07.
//  Copyright (c) 2013 Alina Kholcheva. All rights reserved.
//

#import "LuxiDetector.h"

@implementation LuxiDetector



+(BOOL) isLuxiOn:(CMSampleBufferRef) sampleBuffer
{
  
    // get camera snapshot
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);        // Lock the image buffer
    
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0);   // Get information of the image
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    NSUInteger bytesPerPixel = 4;
    NSUInteger bitsPerComponent = 8;
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);


    CGImageRef cameraSnapshot = CGBitmapContextCreateImage(context);
    
    
    // scaled image to 200x200
    NSUInteger scaledWidth = 200;
    NSUInteger scaledHeight = 200;
    bytesPerRow = bytesPerPixel * scaledWidth;
    
    unsigned char *scaledRawData = (unsigned char*) calloc(scaledWidth * scaledHeight * 4, sizeof(unsigned char));
    CGContextRef scaledImgContext = CGBitmapContextCreate(scaledRawData, scaledWidth, scaledHeight,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(scaledImgContext, CGRectMake(0, 0, scaledWidth, scaledHeight), cameraSnapshot);
    CGImageRef scaledImage = CGBitmapContextCreateImage(scaledImgContext);
    
    CGContextRelease(context);
    CGContextRelease(scaledImgContext);
    
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    
    
    
    
    // count RGBs
    
    // First get the image into your data buffer
    NSInteger percentage = 100;
    
    
    NSUInteger totalPixelCount = scaledWidth * scaledHeight;
    NSUInteger samplePixelCount = totalPixelCount / 100 * percentage;
    NSUInteger stepSize = totalPixelCount / samplePixelCount;
    
    
    float *redValues = (float*) calloc(height * width * 4, sizeof(float));
    float *greenValues = (float*) calloc(height * width * 4, sizeof(float));
    float *blueValues = (float*) calloc(height * width * 4, sizeof(float));

    // Now your rawData contains the image data in the RGBA8888 pixel format.
    int byteIndex = 0;
    for (int ii = 0 ; ii < samplePixelCount ; ++ii)
    {
        NSInteger red   = (CGFloat)scaledRawData[byteIndex];
        NSInteger green = (CGFloat)scaledRawData[byteIndex + 1];
        NSInteger blue  = (CGFloat)scaledRawData[byteIndex + 2];
        //        NSInteger alpha = (CGFloat)rawData[byteIndex + 3];
        byteIndex += stepSize*bytesPerPixel;
        
        // brightness
        //long pixelValue = (red+red+blue+green+green+green)/6;
        
        redValues[ii] = (float)red/255.0;
        greenValues[ii] = (float)green/255.0;
        blueValues[ii] = (float)blue/255.0;
		
    }
    
    free(scaledRawData);
    
    CGImageRelease(cameraSnapshot);
    CGImageRelease(scaledImage);
    
    
    // count standard derivation
    float redDerivation =  [LuxiDetector standardDerivation:redValues valueCount:samplePixelCount];
    float greenDerivation = [LuxiDetector standardDerivation:greenValues valueCount:samplePixelCount];
    float blueDerivation = [LuxiDetector standardDerivation:blueValues valueCount:samplePixelCount];
    
    free(redValues);
    free(greenValues);
    free(blueValues);
    
    
    
    float threshold = 0.20;
//    NSLog(@"\n----------------------------------------------------\n");
//    NSLog(@"(%.2f,  %.2f,  %.2f)", redDerivation, greenDerivation, blueDerivation);
    
    if (redDerivation <= threshold && greenDerivation <= threshold && blueDerivation <= threshold){
        return YES;
    } else {
        return NO;
    }
	
    
    
}



+(float) standardDerivation:(float[])values valueCount:(float)valueCount
{
    float sum = 0;
    for (int i = 0 ; i < valueCount ; ++i)
    {
        sum += values[i];
    }
    float avg =  sum/valueCount;
    float sumOfSquaredDifferences = 0;
    for (int i = 0 ; i < valueCount; ++i)
    {
        float diff = (values[i] - avg);
        sumOfSquaredDifferences += diff*diff;
    }
    float derivation = sqrt(sumOfSquaredDifferences / valueCount);
    
    return derivation;
}


@end


