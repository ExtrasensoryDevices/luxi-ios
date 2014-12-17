//
//  CameraView.m
//  Luxi
//
//  Created by Alina Kholcheva on 11/21/2013.
//  Copyright (c) 2013 Alina Kholcheva. All rights reserved.
//

#import "CameraView.h"
#import <ImageIO/CGImageProperties.h>

#import "LuxiDetector.h"




@interface CameraView()

// -------------  UI  ---------------- //
@property (weak, nonatomic) IBOutlet UIImageView *sightView;
@property (strong, nonatomic) UITapGestureRecognizer *cameraViewTapGestureRecognizer;

// -----------  CAMERA  -------------- //

@property (nonatomic) AVCaptureDevicePosition currentCameraPosition;

@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVCaptureDevice *camera;
@property (strong, nonatomic) AVCaptureDeviceInput *videoInput;
@property (nonatomic,retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;


@property (strong, nonatomic) NSString *brightnessValue;
@property (strong, nonatomic) NSString *exposureTime;
@property (strong, nonatomic) NSString *isoSpeed;
@property (strong, nonatomic) NSString *shutterSpeed;
@end



@implementation CameraView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



-(void) setSightViewHidden:(BOOL)hidden
{
    [_sightView setHidden:hidden];
}





- (void)setupCaptureSession:(AVCaptureDevicePosition) position
{
    
    [self initCamera:position];
    [self updateUIUseFrontCamera:(position ==AVCaptureDevicePositionFront)];
    
    if (!self.camera || !self.videoInput){
        // error - no cameras available
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Camera Unavailable" message:@"Unable to use camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    
    //  the capture session is where all of the inputs and outputs tie together.
    self.captureSession = [[AVCaptureSession alloc] init];
    
    [self.captureSession addInput:self.videoInput];
    
    
    //  create the thing which captures the output
    AVCaptureVideoDataOutput *videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    //  pixel buffer format
    NSDictionary *settings = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA],
                              kCVPixelBufferPixelFormatTypeKey, nil];
    videoDataOutput.videoSettings = settings;
    
    
    dispatch_queue_t queue = dispatch_queue_create("luxi", NULL);
    [videoDataOutput setSampleBufferDelegate:self queue:queue];
    [_captureSession addOutput:videoDataOutput];
    //[_captureSession startRunning];
    
    [self attachPreviewLayer];
    
}

- (void) useCamera:(AVCaptureDevicePosition) position
{
    if (!_captureSession){
        return;
    }
    [_captureSession removeInput:_videoInput];
    [self setVideoInput:nil];
    [self initCamera:position];
    [self updateUIUseFrontCamera:(position ==AVCaptureDevicePositionFront)];
    [_captureSession addInput:_videoInput];
}




- (void) initCamera:(AVCaptureDevicePosition) position {
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            self.camera = device;
        }
    }
    self.currentCameraPosition = position;
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.camera error:nil];
    
}

-(void) updateUIUseFrontCamera:(BOOL)useFrontCamera
{
    // update UI
    [self setSightViewHidden: useFrontCamera];
    [self setCameraTapGestureRecognizerEnabled: (!useFrontCamera)];
    if (!useFrontCamera) {
        
        NSLog(@"-----------b/f----------");
        NSLog(@"frame: (%f,%f), (%f,%f)", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        NSLog(@"sight origin: (%f,%f)", self.sightView.frame.origin.x, self.sightView.frame.origin.y);
        NSLog(@"sight centre: (%f,%f)", self.sightView.center.x, self.sightView.center.y);
        NSLog(@"sight frame: (%f,%f)", self.sightView.frame.size.width, self.sightView.frame.size.width);
        
        
        self.sightView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.sightView removeConstraints:self.sightView.constraints];
        self.sightView.center = self.center; //  CGPointMake(0, 0);

        
        NSLog(@"-----------after----------");
        NSLog(@"frame: (%f,%f), (%f,%f)", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
        NSLog(@"sight origin: (%f,%f)", self.sightView.frame.origin.x, self.sightView.frame.origin.y);
        NSLog(@"sight centre: (%f,%f)", self.sightView.center.x, self.sightView.center.y);
        NSLog(@"sight frame: (%f,%f)", self.sightView.frame.size.width, self.sightView.frame.size.width);

        
        
        
    }
}



- (void)attachPreviewLayer {
    AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    CALayer *viewLayer = [self layer];
    
    newCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    newCaptureVideoPreviewLayer.frame = self.layer.bounds;
    
    self.captureVideoPreviewLayer = newCaptureVideoPreviewLayer;
    
    [viewLayer insertSublayer:newCaptureVideoPreviewLayer atIndex:0];
    
}




-(void)startRunning
{
    [_captureSession startRunning];
}


-(void)stopRunning
{
    [_captureSession stopRunning];
}



#pragma mark - Camera data Processing




// Delegate routine that is called when a sample buffer was written
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CFDictionaryRef exifAttachments = CMGetAttachment( sampleBuffer, kCGImagePropertyExifDictionary, NULL);
    
    if (!exifAttachments){
        return;
    }
    
    self.brightnessValue = [NSString stringWithFormat:@"%@", CFDictionaryGetValue(exifAttachments, @"BrightnessValue")];
    float brightnessValue = [self.brightnessValue floatValue];
    
    self.exposureTime = [NSString stringWithFormat:@"%@", CFDictionaryGetValue(exifAttachments, @"ExposureTime")];
    self.isoSpeed = [NSString stringWithFormat:@"%@", CFDictionaryGetValue(exifAttachments, @"ISOSpeedRatings")];
    self.shutterSpeed = [NSString stringWithFormat:@"%@", CFDictionaryGetValue(exifAttachments, @"ShutterSpeedValue")];
    
    
    if (self.currentCameraPosition == AVCaptureDevicePositionFront){
        
        //      NSDate *d4 = [NSDate date];
        BOOL isOn = [LuxiDetector isLuxiOn:sampleBuffer];
        //      NSTimeInterval i4 = [d4 timeIntervalSinceNow];
        //      NSLog(@"i4 : %@ : total: %.2f", isOn?@"ON":@"OFF", fabsf(i4));
        
        if (self.delegate){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate handleLuxiIsOn:isOn];
            });
        }
    }
    if (self.delegate){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate logBrightness:[NSNumber numberWithFloat:brightnessValue]];
        });
    }
    
}



#pragma mark - TapGestureRecognizer

-(void) setCameraTapGestureRecognizerEnabled: (BOOL) enabled
{
    if (enabled){
    
        if (!self.cameraViewTapGestureRecognizer){
            self.cameraViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCameraViewTap:)];
            _cameraViewTapGestureRecognizer.numberOfTouchesRequired = 1;
        }
        [self addGestureRecognizer:_cameraViewTapGestureRecognizer];
        
    } else {
        
        [self removeGestureRecognizer:self.cameraViewTapGestureRecognizer];
        
    }
}





// Convert from view coordinates to camera coordinates, where {0,0} represents the top left of the picture area, and {1,1} represents
// the bottom right in landscape mode with the home button on the right.
- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates
{
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    CGSize frameSize = [self frame].size;
    
    
    if (self.captureVideoPreviewLayer.connection.videoMirrored) {
        viewCoordinates.x = frameSize.width - viewCoordinates.x;
    }
    
    if ( [[self.captureVideoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResize] ) {
		// Scale, switch x and y, and reverse x
        pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height, 1.f - (viewCoordinates.x / frameSize.width));
    } else {
        CGRect cleanAperture;
        
        
        for (AVCaptureInputPort *port in [self.videoInput ports]) {
            if ([port mediaType] == AVMediaTypeVideo) {
                cleanAperture = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);
                CGSize apertureSize = cleanAperture.size;
                CGPoint point = viewCoordinates;
                
                CGFloat apertureRatio = apertureSize.height / apertureSize.width;
                CGFloat viewRatio = frameSize.width / frameSize.height;
                CGFloat xc = .5f;
                CGFloat yc = .5f;
                
                if ( [[self.captureVideoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspect] ) {
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = frameSize.height;
                        CGFloat x2 = frameSize.height * apertureRatio;
                        CGFloat x1 = frameSize.width;
                        CGFloat blackBar = (x1 - x2) / 2;
						// If point is inside letterboxed area, do coordinate conversion; otherwise, don't change the default value returned (.5,.5)
                        if (point.x >= blackBar && point.x <= blackBar + x2) {
							// Scale (accounting for the letterboxing on the left and right of the video preview), switch x and y, and reverse x
                            xc = point.y / y2;
                            yc = 1.f - ((point.x - blackBar) / x2);
                        }
                    } else {
                        CGFloat y2 = frameSize.width / apertureRatio;
                        CGFloat y1 = frameSize.height;
                        CGFloat x2 = frameSize.width;
                        CGFloat blackBar = (y1 - y2) / 2;
						// If point is inside letterboxed area, do coordinate conversion. Otherwise, don't change the default value returned (.5,.5)
                        if (point.y >= blackBar && point.y <= blackBar + y2) {
							// Scale (accounting for the letterboxing on the top and bottom of the video preview), switch x and y, and reverse x
                            xc = ((point.y - blackBar) / y2);
                            yc = 1.f - (point.x / x2);
                        }
                    }
                } else if ([[self.captureVideoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
					// Scale, switch x and y, and reverse x
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = apertureSize.width * (frameSize.width / apertureSize.height);
                        xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2; // Account for cropped height
                        yc = (frameSize.width - point.x) / frameSize.width;
                    } else {
                        CGFloat x2 = apertureSize.height * (frameSize.height / apertureSize.width);
                        yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2); // Account for cropped width
                        xc = point.y / frameSize.height;
                    }
                }
                
                pointOfInterest = CGPointMake(xc, yc);
                break;
            }
        }
    }
    
    return pointOfInterest;
}




- (void)handleCameraViewTap:(UITapGestureRecognizer *)sender {
    
    
    if (self.pauseCameraProcessing){
        return;
    }
    
    if ([self.camera isFocusPointOfInterestSupported]) {
        CGPoint tapPoint = [sender locationInView:self];
        
        CGPoint focusPoint = [self convertToPointOfInterestFromViewCoordinates:tapPoint];
        
        if ( [self.camera lockForConfiguration:NULL] == YES ) {
            [self.camera setFocusPointOfInterest:focusPoint];
            [self.camera setFocusMode:AVCaptureFocusModeAutoFocus];
            
            [self.camera setExposurePointOfInterest:focusPoint];
            [self.camera setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
            
            [self.camera unlockForConfiguration];
            
            
            //move focus rect
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            self.sightView.center = tapPoint;
            [UIView commitAnimations];
        }
    }
}

@end
