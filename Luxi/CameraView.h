//
//  CameraView.h
//  Luxi
//
//  Created by Alina Kholcheva on 11/21/2013.
//  Copyright (c) 2013 Alina Kholcheva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>




@protocol CameraViewDelegate <NSObject>
- (void) handleLuxiIsOn:(BOOL)isOn;
- (void) logBrightness:(NSNumber*) brightnessValue;
@end





@interface CameraView : UIView <AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic) BOOL pauseCameraProcessing;

@property (nonatomic, weak) id<CameraViewDelegate> delegate;


- (void) setupCaptureSession:(AVCaptureDevicePosition) position;
- (void) useCamera:(AVCaptureDevicePosition) position;

- (void) startRunning;
- (void) stopRunning;



@end
