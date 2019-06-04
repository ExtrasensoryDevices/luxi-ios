
// TDI//
//  MainViewController.m
//  Luxi
//
//  Created by Alina on 2013-09-27.
//  Copyright (c) 2013 Alina Kholcheva. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "MainViewController.h"

#import "Settings.h"

#import "OnboardingViewController.h"




@interface MainViewController ()


#define kEvStepSize 0.1;
#define kLuxStepSize 0.1;



enum AppState : NSUInteger {
    AppStateNoLuxiMode = 1,
    AppStateLuxiOffMode = 2,
    AppStateLuxiOnMode = 3,
};


enum PickerType{
    PickerTypeFstop,
    PickerTypeTime,
    PickerTypeIso,
};

enum Lockable{
    LockableFSTOP,
    LockableTIME,
    LockableISO,
};



@property (atomic) enum AppState currentState;


// ---------  LUXI ON view  ---------------- //
@property (weak, nonatomic) IBOutlet UIView *luxiView;
@property (weak, nonatomic) IBOutlet UISlider *evSlider;
@property (weak, nonatomic) IBOutlet UISlider *luxSlider;

- (IBAction)defaultButtonClicked:(id)sender;
- (IBAction)calibrationSliderValueChanged:(UISlider *)sender;

@property (weak, nonatomic) IBOutlet UILabel *evCalibrationValueLbl;
@property (weak, nonatomic) IBOutlet UILabel *luxCalibrationValueLbl;

@property (weak, nonatomic) IBOutlet UILabel *ev100Lbl2;
@property (weak, nonatomic) IBOutlet UILabel *evLbl2;
@property (weak, nonatomic) IBOutlet UILabel *luxLbl2;

@property (weak, nonatomic) IBOutlet UIView *fstopView2;
@property (weak, nonatomic) IBOutlet UIView *timeView2;
@property (weak, nonatomic) IBOutlet UIView *isoView2;

@property (weak, nonatomic) IBOutlet UILabel *fstopLbl2;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl2;
@property (weak, nonatomic) IBOutlet UILabel *isoLbl2;


@property (weak, nonatomic) IBOutlet UIImageView *fstopLockImg2;
@property (weak, nonatomic) IBOutlet UIImageView *timeLockImg2;
@property (weak, nonatomic) IBOutlet UIImageView *isoLockImg2;

-(void) updateCalibrationLabels;




// ---------  LUXI OFF & NO LUXI views  ---------------- //
@property (weak, nonatomic) IBOutlet UIView *noLuxiView;

@property (weak, nonatomic) IBOutlet CameraView *cameraContainerView;

@property (weak, nonatomic) IBOutlet UILabel *permissionLabel;

@property (weak, nonatomic) IBOutlet UILabel *ev100Lbl1;
@property (weak, nonatomic) IBOutlet UILabel *evLbl1;
@property (weak, nonatomic) IBOutlet UILabel *luxLbl1;

@property (weak, nonatomic) IBOutlet UIView *fstopView1;
@property (weak, nonatomic) IBOutlet UIView *timeView1;
@property (weak, nonatomic) IBOutlet UIView *isoView1;

@property (weak, nonatomic) IBOutlet UILabel *fstopLbl1;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl1;
@property (weak, nonatomic) IBOutlet UILabel *isoLbl1;


@property (weak, nonatomic) IBOutlet UIImageView *fstopLockImg1;
@property (weak, nonatomic) IBOutlet UIImageView *timeLockImg1;
@property (weak, nonatomic) IBOutlet UIImageView *isoLockImg1;



// ---------  ROOT view  ---------------- //
@property (weak, nonatomic) IBOutlet UIButton *buyLuxiBtn;
@property (weak, nonatomic) IBOutlet UILabel  *helpLabel;
@property (weak, nonatomic) IBOutlet UIButton *settingsBtn;
@property (weak, nonatomic) IBOutlet UIButton *holdBtn;

- (IBAction)holdBtnPressed:(id)sender;



// locked numerical values
@property (nonatomic) float isoValueLocked;
@property (nonatomic) float fstopValueLocked;
@property (nonatomic) float timeValueLocked;

@property (nonatomic) float isoValueCalculated; // calculated from locked FSTOP and TIME
@property (nonatomic) float isoValueCalculatedNormalized; // nearest value from the picker to the isoValueCalculated

@property (nonatomic) float fstopValueCalculated;  // calculated from locked ISO and TIME
@property (nonatomic) float fstopValueCalculatedNormalized; // nearest value from the picker to the fstopValueCalculated

@property (nonatomic) float timeValueCalculated;  // calculated from locked FSTOP and ISO
@property (nonatomic) float timeValueCalculatedNormalized; // nearest value from the picker to the timeValueCalculated

// lock state flags
@property (nonatomic) BOOL allValuesLocked;
@property (nonatomic) BOOL fstopLocked;
@property (nonatomic) BOOL timeLocked;
@property (nonatomic) BOOL isoLocked;

@property (nonatomic) enum Lockable lastLockedValue;




// pickers
@property (strong, nonatomic) NSArray *fstopPickerValues;
@property (strong, nonatomic) NSArray *timePickerValues;
@property (strong, nonatomic) NSArray *timePickerNumericValues;
@property (strong, nonatomic) NSArray *isoPickerValues;

@property (nonatomic) enum PickerType pickerType;

@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerViewBottomLayoutConstraint;
@property (weak, nonatomic) IBOutlet UINavigationItem *pickerViewNavigationItem;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;


- (IBAction)closePicker:(id)sender;

-(void) createShadowForPickerView;

// onboarding
@property (strong, nonatomic) OnboardingViewController *onboardingViewController;


@end




@implementation MainViewController


BOOL _initialized = false;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.fstopPickerValues = [[NSArray alloc] initWithObjects:@"0.9",
                              @"1",
                              @"1.1",
                              @"1.2",
                              @"1.3",
                              @"1.4",
                              @"1.6",
                              @"1.7",
                              @"1.8",
                              @"2",
                              @"2.2",
                              @"2.4",
                              @"2.5",
                              @"2.8",
                              @"3.2",
                              @"3.4",
                              @"3.6",
                              @"4",
                              @"4.5",
                              @"4.8",
                              @"5",
                              @"5.7",
                              @"6.3",
                              @"6.7",
                              @"7.1",
                              @"8",
                              @"9",
                              @"9.5",
                              @"10.1",
                              @"11.3",
                              @"12.7",
                              @"13.5",
                              @"14.3",
                              @"16",
                              @"18",
                              @"19",
                              @"20.2",
                              @"22.6",
                              @"25.4",
                              @"26.9",
                              @"28.5",
                              @"32",
                              @"35.9",
                              @"38.1",
                              @"40.3",
                              @"45.3",
                              @"50.8",
                              @"53.8",
                              @"57",
                              @"64",
                              @"71.8",
                              @"76.1",
                              @"80.6",
                              @"90.5",
                              @"101.6",
                              @"107.6",
                              @"114",
                              @"128",
                              @"143.7",
                              @"152.2",
                              @"161.3",
                              @"181",
                              @"203.2",
                              @"215.3",
                              @"228.1",
                              @"256",
                              @"287.4",
                              @"304.4",
                              @"322.5",
                              @"362",
                              @"406.4",
                              @"430.5",
                              @"456.1",
                              @"512",
                              nil];
    
    self.timePickerValues = [[NSArray alloc] initWithObjects:@"1/16000",
                              @"1/12000",
                              @"1/8000",
                              @"1/6400",
                              @"1/4000",
                              @"1/2500",
                              @"1/2000",
                              @"1/1600",
                              @"1/1000",
                              @"1/800",
                              @"1/640",
                              @"1/500",
                              @"1/400",
                              @"1/320",
                              @"1/250",
                              @"1/200",
                              @"1/160",
                              @"1/125",
                              @"1/100",
                              @"1/96",
                              @"1/80",
                              @"1/60",
                              @"1/50",
                              @"1/50",
                              @"1/48",
                              @"1/40",
                              @"1/30",
                              @"1/25",
                              @"1/20",
                              @"1/15",
                              @"1/13",
                              @"1/10",
                              @"1/8",
                              @"1/6",
                              @"1/5",
                              @"1/4",
                              @"1/3",
                              @"2/5",
                              @"1/2",
                              @"5/8",
                              @"10/13",
                              @"1",
                              @"13/10",
                              @"8/5",
                              @"2",
                              @"5/2",
                              @"3",
                              @"4",
                              @"5",
                              @"6",
                              @"8",
                              @"10",
                              @"13",
                              @"16",
                              @"20",
                              @"26",
                              @"32",
                             nil];
    
    self.timePickerNumericValues = [[NSArray alloc] initWithObjects:
                                     @"6.25E-05",
                                     @"8.33E-05",
                                     @"0.000125",
                                     @"0.00015625",
                                     @"0.00025",
                                     @"0.0004",
                                     @"0.0005",
                                     @"0.000625",
                                     @"0.001",
                                     @"0.00125",
                                     @"0.0015625",
                                     @"0.002",
                                     @"0.0025",
                                     @"0.003125",
                                     @"0.004",
                                     @"0.005",
                                     @"0.00625",
                                     @"0.008",
                                     @"0.01",
                                     @"0.0104166667",
                                     @"0.0125",
                                     @"0.0166666667",
                                     @"0.02",
                                     @"0.02",
                                     @"0.0208333333",
                                     @"0.025",
                                     @"0.0333333333",
                                     @"0.04",
                                     @"0.05",
                                     @"0.0666666667",
                                     @"0.0769230769",
                                     @"0.1",
                                     @"0.125",
                                     @"0.1666666667",
                                     @"0.2",
                                     @"0.25",
                                     @"0.3333333333",
                                     @"0.4",
                                     @"0.5",
                                     @"0.625",
                                     @"0.7692307692",
                                     @"1",
                                     @"1.3",
                                     @"1.6",
                                     @"2",
                                     @"2.5",
                                     @"3",
                                     @"4",
                                     @"5",
                                     @"6",
                                     @"8",
                                     @"10",
                                     @"13",
                                     @"16",
                                     @"20",
                                     @"26",
                                     @"32",
                                    nil];
    
    self.isoPickerValues = [[NSArray alloc] initWithObjects:@"0.8",
                            @"1",
                            @"1.2",
                            @"1.6",
                            @"2",
                            @"2.5",
                            @"3",
                            @"4",
                            @"5",
                            @"6",
                            @"8",
                            @"10",
                            @"12",
                            @"16",
                            @"20",
                            @"25",
                            @"32",
                            @"40",
                            @"50",
                            @"64",
                            @"80",
                            @"100",
                            @"125",
                            @"160",
                            @"200",
                            @"250",
                            @"320",
                            @"400",
                            @"500",
                            @"640",
                            @"800",
                            @"1000",
                            @"1250",
                            @"1600",
                            @"2000",
                            @"2500",
                            @"3200",
                            @"4000",
                            @"5000",
                            @"6400",
                            @"12800",
                            @"25600",
                            @"51200",
                            @"102400",
                            nil];
    
    
    [self initBrightnessValues];
    
    [self initCalibrationSliders];
    
    [self.permissionLabel setHidden: YES];
    
    [self setupHelpButton];
}

-(void)setupHelpButton {
    
    UIColor *color = [UIColor colorWithRed:194.0/255.0 green:194.0/255.0 blue:194.0/255.0 alpha:1.0];
    [self.helpLabel setTextColor:color];
    [self.helpLabel.layer setBorderColor:color.CGColor];
    [self.helpLabel.layer setCornerRadius:self.helpLabel.bounds.size.width/2];
    [self.helpLabel.layer setBorderWidth:3];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapHelpButton:)];
    [self.helpLabel addGestureRecognizer:tapRecognizer];
    [self.helpLabel setUserInteractionEnabled:YES];
}

-(void)initCurrentState
{
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];

    switch (authStatus) {
        case AVAuthorizationStatusAuthorized: {
            if ([Settings userSettings].luxiModeOn){
                self.currentState = AppStateLuxiOffMode; // detect if luxi is ON later
                [self.cameraContainerView setupCaptureSession:AVCaptureDevicePositionFront];
                
            } else {
                self.currentState = AppStateNoLuxiMode;
                [self.cameraContainerView setupCaptureSession:AVCaptureDevicePositionBack];
            }
            [self updateUIPermissionGranted: YES];
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted: {
            // denied
            // restricted (parental control?), normally won't happen
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle: @"Luxi uses your device's front-facing camera as its light sensor."
                                        message: @"Please allow Luxi to use the camera in the Settings app."
                                        preferredStyle: UIAlertControllerStyleAlert];

            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:@"Cancel"
                                           style:UIAlertActionStyleCancel
                                           handler:nil];
            
            [alert addAction:cancelAction];
            UIAlertAction *settingsAction = [UIAlertAction
                                           actionWithTitle:@"Settings"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action){
                                               [self openSettings];
                                           }];
            
            [alert addAction:settingsAction];
            [self presentViewController: alert animated:YES completion:nil];

            [self updateUIPermissionGranted: NO];
            break;
        }
        case AVAuthorizationStatusNotDetermined: {
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                if(granted){
                    NSLog(@"Granted access to %@", mediaType);
                } else {
                    NSLog(@"Not granted access to %@", mediaType);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self updateUIPermissionGranted: granted];
                });
            }];
            break;
        }
    }

}

-(void) updateUIPermissionGranted:(BOOL)granted
{
    [self.permissionLabel setHidden: granted];
    
    if (granted) {
        for (UIGestureRecognizer *recognizer in self.permissionLabel.gestureRecognizers) {
            [self.permissionLabel removeGestureRecognizer: recognizer];
        }
    } else if (self.permissionLabel.gestureRecognizers.count == 0) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleNoCameraViewTap:)];
        [self.permissionLabel addGestureRecognizer:tapRecognizer];
        [self.permissionLabel setUserInteractionEnabled:YES];
    }
}

-(void) openSettings
{
    [UIApplication.sharedApplication
     openURL: [NSURL URLWithString: UIApplicationOpenSettingsURLString]
     options:@{}
     completionHandler:nil];
}

-(void) initBrightnessValues
{
    // load default values
    NSNumber *savedFstop = [[Settings userSettings] fstop];
    NSNumber *savedTime  = [[Settings userSettings] time];
    NSNumber *savedIso   = [[Settings userSettings] iso];

    if (savedFstop == nil && savedTime == nil && savedIso == nil) {
        self.fstopValueLocked = 2.8;
        [self setFstopLblText: @"f/2.8"];
        
        [self setTimeLblText: @""];
        
        self.isoValueLocked = 100;
        [self setIsoLblText: @"100"];
        
        self.fstopLocked = YES;
        self.timeLocked = NO;
        self.isoLocked = YES;
        
        [self updateLockImages];
        
        return;
    }
    
    if (savedFstop != nil){
        NSInteger index = [self indexOfTheNearestValue:[savedFstop floatValue] inArray:self.fstopPickerValues];
        NSString *fstopStringValue = self.fstopPickerValues[index];
        self.fstopValueLocked = [fstopStringValue floatValue];
        [self setFstopLblText:[@"f/" stringByAppendingString:fstopStringValue]];
    } else {
        [self setFstopLblText: @""];
    }
    
    if (savedTime != nil){
        NSInteger index = [self indexOfTheNearestValue:[savedTime floatValue] inArray:self.timePickerNumericValues];
        NSString *timeStringValue = self.timePickerValues[index];
        NSString *timeNumericValue = self.timePickerNumericValues[index];
        [self setTimeLblText:timeStringValue];
        self.timeValueLocked = [timeNumericValue floatValue];
    } else {
        [self setTimeLblText: @""];
    }
    
    if (savedIso != nil){
        NSInteger index = [self indexOfTheNearestValue:[savedIso floatValue] inArray:self.isoPickerValues];
        NSString *isoStringValue = self.isoPickerValues[index];
        self.isoValueLocked = [isoStringValue floatValue];
        [self setIsoLblText:isoStringValue];
    } else {
        [self setIsoLblText: @""];
    }
    
    self.fstopLocked = (savedFstop != nil);
    self.timeLocked = (savedTime != nil);
    self.isoLocked = (savedIso != nil);
    
    [self updateLockImages];
}

-(void) initCalibrationSliders
{
    // Fix for the size of the thumb:
    //     imageWithBorderFromImage inscreases the size and draws a border
    UIImage *thumb = [self imageWithBorderFromImage:[UIImage imageNamed:@"IndicatorBar"]];
    UIImage *track = [UIImage imageNamed:@"SliderTrack"];
    
    [self.evSlider setThumbImage:thumb forState:UIControlStateNormal];
    [self.evSlider setThumbImage:thumb forState:UIControlStateHighlighted];
    [self.evSlider setMinimumTrackImage: track forState: UIControlStateNormal];
    [self.evSlider setMaximumTrackImage: track forState: UIControlStateNormal];
    
    [self.luxSlider setThumbImage:thumb forState:UIControlStateNormal];
    [self.luxSlider setThumbImage:thumb forState:UIControlStateHighlighted];
    [self.luxSlider setMinimumTrackImage: track forState: UIControlStateNormal];
    [self.luxSlider setMaximumTrackImage: track forState: UIControlStateNormal];
    
    NSNumber *savedCalibrationEv = [[Settings userSettings] calibrationEV];
    if (savedCalibrationEv != nil){
        [self.evSlider setValue:[savedCalibrationEv floatValue]];
    }
    
    NSNumber *savedCalibrationLux = [[Settings userSettings] calibrationLUX];
    if (savedCalibrationLux != nil){
        [self.luxSlider setValue:[savedCalibrationLux floatValue]];
    }
    [self updateCalibrationLabels];
    
}

- (UIImage*)imageWithBorderFromImage:(UIImage*)source;
{
    CGSize oldSize = [source size];
    CGSize size = CGSizeMake(oldSize.width*2, oldSize.height*1.2);
    
    UIGraphicsBeginImageContextWithOptions(size, true, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, UIColor.whiteColor.CGColor);
    CGContextSetStrokeColorWithColor(context,UIColor.blackColor.CGColor);
    CGContextSetLineWidth(context, 2.0);
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextFillRect(context, rect);
    CGContextStrokeRect(context, rect);
    
    UIImage *testImg =  UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return testImg;
}



-(void)viewWillAppear:(BOOL)animated
{
    [self.view layoutSubviews];
    [super viewWillAppear:animated];
    
}


- (void)viewDidAppear:(BOOL)animated
{
    
    if (!_initialized) {
        [self initCurrentState];
        _initialized = true;
    }
    
    [self showOnboarding];

    [_cameraContainerView setDelegate:self];
    if (self.onboardingViewController == nil){
        [_cameraContainerView startRunning];
    }
    
    [self initLabelViewGestureRecognizers];
    
    [self createShadowForPickerView];
    
    [super viewDidAppear:animated];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [_cameraContainerView stopRunning];
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - Show/Hide Onboarding

-(void) showOnboarding
{
    if ([[Settings userSettings] showOnboarding]){
        // Create page view controller
        self.onboardingViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"OnboardingViewControllerId"];
        _onboardingViewController.onboardingViewDelegate = self;
        _onboardingViewController.luxiView = self.currentState == AppStateLuxiOnMode;
        
        _onboardingViewController.view.alpha = 0.0f;
        [self addChildViewController:_onboardingViewController];
        [self.view addSubview:_onboardingViewController.view];
        
        [UIView transitionWithView:_onboardingViewController.view
                          duration:0.2f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self->_onboardingViewController.view.alpha = 1.0f;
                        } completion:nil];
        
        [Settings userSettings].showOnboarding = NO;
    }
}

-(void) hideOnboarding
{
    if (_onboardingViewController){
        
        
        [UIView transitionWithView:_onboardingViewController.view
                          duration:0.2f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self->_onboardingViewController.view.alpha = 0.0f;
                        } completion:^(BOOL finished){
                            [self->_onboardingViewController removeFromParentViewController];
                            [self->_onboardingViewController.view removeFromSuperview];
                            self.onboardingViewController = nil;
                            [Settings userSettings].showOnboarding = NO;
                        }];
    }
}


#pragma mark - Locking

-(void) updateLockImages
{
    self.fstopLockImg1.hidden = self.fstopLockImg2.hidden = !(self.fstopLocked || self.allValuesLocked);
    self.timeLockImg1.hidden = self.timeLockImg2.hidden = !(self.timeLocked || self.allValuesLocked);
    self.isoLockImg1.hidden = self.isoLockImg2.hidden = !(self.isoLocked || self.allValuesLocked);
}





-(void) lock:(enum Lockable) valueToLock unlock:(enum Lockable) valueToUnlock
{
    if (valueToLock == LockableFSTOP){
        self.fstopLocked = YES;
        self.lastLockedValue = LockableFSTOP;
        self.fstopValueLocked = self.fstopValueCalculatedNormalized; // will be changed by picker, it user opens it
        self.lastLockedValue = LockableFSTOP;
    }
    else if (valueToLock == LockableTIME){
        self.timeLocked = YES;
        self.lastLockedValue = LockableTIME;
        self.timeValueLocked = self.timeValueCalculatedNormalized;  // will be changed by picker, it user opens it
        self.lastLockedValue = LockableTIME;
    }
    else if (valueToLock == LockableISO){
        self.isoLocked = YES;
        self.lastLockedValue = LockableISO;
        self.isoValueLocked = self.isoValueCalculatedNormalized;  // will be changed by picker, it user opens it
        self.lastLockedValue = LockableISO;
    }
    
    
    if (valueToUnlock == LockableFSTOP){
        self.fstopLocked = NO;
    }
    else if (valueToUnlock == LockableTIME){
        self.timeLocked = NO;
    }
    else if (valueToUnlock == LockableISO){
        self.isoLocked = NO;
    }
    [self updateLockImages];
}


#pragma mark - Gesture handling



- (void)handleNoCameraViewTap:(UITapGestureRecognizer *)sender {
    [self openSettings];
}


-(void) initLabelViewGestureRecognizers
{
    if (self.fstopView1.gestureRecognizers.count  == 0){
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleFstopViewTap:)];
        tapRecognizer.numberOfTapsRequired = 1;
        [self.fstopView1 addGestureRecognizer:tapRecognizer];
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleFstopViewLongPress:)];
        [self.fstopView1 addGestureRecognizer:longPressRecognizer];
    }
    if (self.fstopView2.gestureRecognizers.count  == 0){
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleFstopViewTap:)];
        tapRecognizer.numberOfTapsRequired = 1;
        [self.fstopView2 addGestureRecognizer:tapRecognizer];
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleFstopViewLongPress:)];
        [self.fstopView2 addGestureRecognizer:longPressRecognizer];
    }
    if (self.timeView1.gestureRecognizers.count  == 0){
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTimeViewTap:)];
        tapRecognizer.numberOfTapsRequired = 1;
        [self.timeView1 addGestureRecognizer:tapRecognizer];
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTimeViewLongPress:)];
        [self.timeView1 addGestureRecognizer:longPressRecognizer];
    }
    if (self.timeView2.gestureRecognizers.count  == 0){
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTimeViewTap:)];
        tapRecognizer.numberOfTapsRequired = 1;
        [self.timeView2 addGestureRecognizer:tapRecognizer];
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTimeViewLongPress:)];
        [self.timeView2 addGestureRecognizer:longPressRecognizer];
    }
    if (self.isoView1.gestureRecognizers.count  == 0){
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleIsoViewTap:)];
        tapRecognizer.numberOfTapsRequired = 1;
        [self.isoView1 addGestureRecognizer:tapRecognizer];
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleIsoViewLongPress:)];
        [self.isoView1 addGestureRecognizer:longPressRecognizer];
    }
    if (self.isoView2.gestureRecognizers.count  == 0){
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleIsoViewTap:)];
        tapRecognizer.numberOfTapsRequired = 1;
        [self.isoView2 addGestureRecognizer:tapRecognizer];
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleIsoViewLongPress:)];
        [self.isoView2 addGestureRecognizer:longPressRecognizer];
    }
}



- (void)handleFstopViewTap:(UITapGestureRecognizer *)sender {
    if (self.allValuesLocked) {
        return;
    }
    if (sender.state == UIGestureRecognizerStateEnded){
        if (self.fstopLocked) {
            // unlock FSTOP
            // lock other unlocked parameter
            if (!self.timeLocked){ // TIME is unlocked --> lock it
                [self lock:LockableTIME unlock:LockableFSTOP];
            } else { // ISO is unlocked --> lock it
                [self lock:LockableISO unlock:LockableFSTOP];
            }
        } else { // FSTOP not locked, lock it and popup a picker, unlock TIME
            [self lock:LockableFSTOP unlock:LockableTIME];
            //[self showPicker:PickerTypeFstop];
        }
    }
    [self saveBrightnessValues];
}


- (void)handleTimeViewTap:(UITapGestureRecognizer *)sender {
    if (self.allValuesLocked) {
        return;
    }
    if (sender.state == UIGestureRecognizerStateEnded){
        if (self.timeLocked) {
            // unlock TIME
            // lock other unlocked parameter
            if (!self.fstopLocked){ // FSTOP is unlocked --> lock it
                [self lock:LockableFSTOP unlock:LockableTIME];
            } else { // ISO is unlocked --> lock it
                [self lock:LockableISO unlock:LockableTIME];
            }
        } else { // TIME not locked, lock it and popup a picker
            // unlock FSTOP
            [self lock:LockableTIME unlock:LockableFSTOP];
            //[self showPicker:PickerTypeTime];
        }
    }
    [self saveBrightnessValues];
}


- (void)handleIsoViewTap:(UITapGestureRecognizer *)sender {
    if (self.allValuesLocked) {
        return;
    }
    if (sender.state == UIGestureRecognizerStateEnded){
        if (self.isoLocked) {
            // unlock ISO
            // lock other unlocked parameter
            if (!self.fstopLocked){ // FSTOP is unlocked --> lock it
                [self lock:LockableFSTOP unlock:LockableISO];
            } else { // TIME is unlocked --> lock it
                [self lock:LockableTIME unlock:LockableISO];
            }
        } else { // ISO not locked, lock it and popup a picker
            // unlock lastLockedValue
            [self lock:LockableISO unlock:self.lastLockedValue];
            //[self showPicker:PickerTypeIso];
        }
    }
    [self saveBrightnessValues];
}

- (void)handleFstopViewLongPress:(UILongPressGestureRecognizer *)sender {
    if (!self.allValuesLocked){
        if (!self.fstopLocked) {
            [self lock:LockableFSTOP unlock:LockableTIME];
        }
        [self showPicker:PickerTypeFstop];
    }
}


- (void)handleTimeViewLongPress:(UILongPressGestureRecognizer *)sender {
    if (!self.allValuesLocked){
        if (!self.timeLocked) {
            [self lock:LockableTIME unlock:LockableFSTOP];
        }
        [self showPicker:PickerTypeTime];
    }
}


- (void)handleIsoViewLongPress:(UILongPressGestureRecognizer *)sender {
    if (!self.allValuesLocked){
        if (!self.isoLocked) {
            [self lock:LockableISO unlock:self.lastLockedValue];
        }
        [self showPicker:PickerTypeIso];
    }
}



- (IBAction)holdBtnPressed:(UIButton*)sender {
    sender.selected = !sender.selected;
    self.allValuesLocked = sender.selected;
    UIColor *color = self.allValuesLocked ? [UIColor redColor] : [UIColor blackColor];
    self.fstopLbl1.textColor =  self.fstopLbl2.textColor = color;
    self.timeLbl1.textColor = self.timeLbl2.textColor = color;
    self.isoLbl1.textColor = self.isoLbl2.textColor = color;
    [self updateLockImages];
    self.cameraContainerView.pauseCameraProcessing = self.allValuesLocked;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showHelp"])  {
        WebBrowserViewController* webVC = (WebBrowserViewController*)[segue destinationViewController];
        webVC.delegate = self;
        webVC.webViewDestination = WebViewDestinationShowHelp;
        
    } else if ([[segue identifier] isEqualToString:@"buyLuxi"] )  {
        WebBrowserViewController* webVC = (WebBrowserViewController*)[segue destinationViewController];
        webVC.delegate = self;
        webVC.webViewDestination = WebViewDestinationBuyLuxi;
        
    } else if ([[segue identifier] isEqualToString:@"goToSettingsView"])  {
        ((SettingsViewController*)[segue destinationViewController]).settingsViewDelegate = self;
    }
}




-(void) changeStateTo:(enum AppState) newState
{
    enum AppState oldState = self.currentState;
    self.currentState = newState;

    
    //AppStateNoLuxiMode --> AppStateLuxiOffMode
    //AppStateNoLuxiMode --> AppStateLuxiOnMode - not possible (only goes through AppStateLuxiOffMode)
    //AppStateLuxiOffMode --> AppStateNoLuxiMode
    //AppStateLuxiOnMode --> AppStateNoLuxiMode
    if ((oldState == AppStateNoLuxiMode && newState == AppStateLuxiOffMode) ||
        (oldState == AppStateLuxiOffMode && newState == AppStateNoLuxiMode) ||
        (oldState == AppStateLuxiOnMode && newState == AppStateNoLuxiMode)){
        // backCamera --> frontCamera  or vice versa
        [self.cameraContainerView stopRunning];
        [self.cameraContainerView useCamera: (newState == AppStateNoLuxiMode) ? AVCaptureDevicePositionBack : AVCaptureDevicePositionFront];
        [self.cameraContainerView startRunning];
    }
    
    UIView *oldView;
    UIView *newView;
    //AppStateLuxiOffMode --> AppStateLuxiOnMode
    //AppStateLuxiOnMode --> AppStateLuxiOffMode
    //AppStateLuxiOnMode --> AppStateNoLuxiMode
    if ((oldState == AppStateLuxiOffMode && newState == AppStateLuxiOnMode) ||
        (oldState == AppStateLuxiOnMode && newState == AppStateLuxiOffMode) ||
        (oldState == AppStateLuxiOnMode && newState == AppStateNoLuxiMode)) {
        
        if (oldState == AppStateLuxiOffMode){
            oldView = self.noLuxiView;
            newView = self.luxiView;
        } else { //(oldState == AppStateLuxiOnMode && newState == (AppStateLuxiOffMode||AppStateNoLuxiMode) )
            oldView = self.luxiView;
            newView = self.noLuxiView;
        }
        
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:NO];
        
        [oldView setHidden:YES];
        [newView setHidden:NO];
        
        [self.buyLuxiBtn setHidden:(self.currentState == AppStateLuxiOnMode)];
        
        [UIView commitAnimations];
    }

}



- (void)didTapHelpButton:(UITapGestureRecognizer *)sender{
    [self performSegueWithIdentifier:@"showHelp" sender:self];
}



#pragma mark - Screen label setters

-(void) setFstopLblText:(NSString *)fstopLblText
{
    self.fstopLbl1.text = self.fstopLbl2.text = fstopLblText;
}

-(void) setTimeLblText:(NSString *)timeLblText
{
    self.timeLbl1.text = self.timeLbl2.text = timeLblText;
}

-(void) setIsoLblText:(NSString *)isoLblText
{
    self.isoLbl1.text = self.isoLbl2.text = isoLblText;
}


-(void) setEvLblText:(NSString *)evLblText
{
    self.evLbl1.text = self.evLbl2.text = evLblText;
}


-(void) setEv100LblText:(NSString *)ev100LblText
{
    self.ev100Lbl1.text = self.ev100Lbl2.text = ev100LblText;
}

-(void) setLuxLblText:(NSString *)luxLblText
{
    self.luxLbl1.text = self.luxLbl2.text = luxLblText;
}


#pragma mark - Onboarding View Delegate

-(void) dismissOnboarding
{
    [self hideOnboarding];
    [_cameraContainerView startRunning];
    

}



#pragma mark - Camera View Delegate

int cnt;

-(void) handleLuxiIsOn:(BOOL)isOn
{
    int threshold = 10;
    if (isOn){
        if (self.currentState == AppStateLuxiOffMode){
            if (cnt == threshold){
                cnt = 0;
                [self changeStateTo:AppStateLuxiOnMode];
            } else {
                cnt++;
            }
        } else {
            cnt = 0;
        }
    } else {
        if (self.currentState == AppStateLuxiOnMode){
            if (cnt == threshold){
                cnt = 0;
                [self changeStateTo:AppStateLuxiOffMode];
            } else {
                cnt++;
            }
        } else {
            cnt = 0;
        }
    }
}



- (void) logBrightness:(NSNumber*) brightnessValue
{
    
    // handle HOLD button
    if (self.allValuesLocked){
        return;
    }
    
    
    // ev 100
    int iso100 = 100;
    float ev100 = [brightnessValue floatValue] + log2f(iso100 * 0.2973);
    [self setEv100LblText: [NSString stringWithFormat:@"%.2f", ev100]];
    
    
    //  ev
    float evCalibrationValue = self.evSlider.value;
    float ev = 0;
    if (self.isoLocked){
        ev = ev100 - 4.8938 + log2f( self.isoValueLocked * 0.2973 );
    } else {
        ev = log2 ( pow(self.fstopValueLocked, 2) / self.timeValueLocked);
//        ev = log2 ( pow(self.fstopValueCalculated, 2) / self.timeValueCalculated);
    }
    ev += evCalibrationValue;
    [self setEvLblText: [NSString stringWithFormat:@"%.2f", ev]];
    
    
    // lux
    float luxCalibrationValue = 0.4 + self.luxSlider.value;
    float lux = powf(2, ev100) * 2.5 * luxCalibrationValue;
    [self setLuxLblText:  [NSString stringWithFormat:@"%.ld", (long)lux]];
    
    
    
    if(!self.fstopLocked){
        // calculate FSTOP depending on locked TIME and ISO
        float fstop = sqrt ( self.timeValueLocked *  pow (2, ev) );
        
        NSInteger index = [self indexOfTheNearestValue:fstop inArray:self.fstopPickerValues];
        
        NSString *fstopStringValue = self.fstopPickerValues[index];
        [self setFstopLblText:[@"f/" stringByAppendingString:fstopStringValue]];
        
        self.fstopValueCalculated = fstop;
        self.fstopValueCalculatedNormalized = [fstopStringValue floatValue];
        
    } else if(!self.timeLocked){
        // calculate TIME depending on locked FSTOP and ISO
        float time = pow(self.fstopValueLocked,2) /  pow(2,ev);
        
        NSInteger index = [self indexOfTheNearestValue:time inArray:self.timePickerNumericValues];
        
        NSString *timeStringValue = self.timePickerValues[index];
        NSString *timeNumericValue = self.timePickerNumericValues[index];
        [self setTimeLblText:timeStringValue];
        
        self.timeValueCalculated = time;
        self.timeValueCalculatedNormalized = [timeNumericValue floatValue];
        
        
        
    } else if(!self.isoLocked){
        // calculate ISO depending on locked TIME and FSTOP
        float iso = pow(2, (ev - ev100 + 4.8938)) / 0.2973;
        
        NSInteger index = [self indexOfTheNearestValue:iso inArray:self.isoPickerValues];
        NSString *isoStringValue = self.isoPickerValues[index];
        [self setIsoLblText:isoStringValue];
        
        self.isoValueCalculated = iso;
        self.isoValueCalculatedNormalized = [isoStringValue floatValue];
    }
}

-(NSInteger)indexOfTheNearestValue:(float)value inArray:(NSArray*)array
{
    // find nearest TIME picker value
    float nv1 = 0;
    float nv2 = 0;
    int index = -1;
    for (NSString* o in array){
        index++;
        if ((index + 1) < array.count) {
            nv1 = o.floatValue;
            nv2 = [array[index + 1] floatValue];
            if (value <= nv2) {
                break;
            }
        }
    }
    // calculate which nv is closest to time
    float nv1diff = fabsf(nv1 - value);
    float nv2diff = fabsf(nv2 - value);
    
    
    if ((nv1diff < nv2diff) || (index == (array.count - 1))) {
        return index;
    }
    else {
        return index + 1;
    }

}

-(void) saveBrightnessValues
{
    if (!self.fstopLocked){
        [[Settings userSettings] setFstop:nil
                                     time:[NSNumber numberWithFloat:self.timeValueLocked]
                                      iso:[NSNumber numberWithFloat:self.isoValueLocked]];
        
    }
    else if (!self.timeLocked){
        [[Settings userSettings] setFstop:[NSNumber numberWithFloat:self.fstopValueLocked]
                                     time:nil
                                      iso:[NSNumber numberWithFloat:self.isoValueLocked]];
        
    }
    else if (!self.isoLocked){
        [[Settings userSettings] setFstop:[NSNumber numberWithFloat:self.fstopValueLocked]
                                     time:[NSNumber numberWithFloat:self.timeValueLocked]
                                      iso:nil];
        
    }
}




#pragma mark - Settings View Delegate



- (void)luxiModeDidChange:(BOOL) changed
{
    if (changed){
        [self changeStateTo: [Settings userSettings].luxiModeOn ? AppStateLuxiOffMode : AppStateNoLuxiMode];
    }
}

- (void)onboardingModeDidChange:(BOOL)changed
{
    if (changed){
        // do nothing it will be handled onViewDidAppear
        //[self showOnboarding];
    }
}

-(void)dismissSettingsView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Web View Delegate

-(void) closeWebView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark - Calibration

- (IBAction)defaultButtonClicked:(id)sender {
    float evCentre = (self.evSlider.maximumValue + self.evSlider.minimumValue ) / 2;
    float luxCentre = (self.luxSlider.maximumValue + self.luxSlider.minimumValue ) / 2;
    
    [self.evSlider setValue:evCentre animated:YES];
    [self.luxSlider setValue:luxCentre animated:YES];
    
    [self saveCalibrationValues];
    [self updateCalibrationLabels];
}

- (IBAction)calibrationSliderValueChanged:(UISlider *)sender {
    
    float stepSize = 1;
    if (sender == self.luxSlider){
        stepSize = kLuxStepSize;
    } else { // if(sender == self.evSlider){
        stepSize = kEvStepSize;
    }
    
    float newStep = roundf((sender.value) / stepSize);
    sender.value = newStep * stepSize;

    [self saveCalibrationValues];
    [self updateCalibrationLabels];
}

-(void) saveCalibrationValues
{
    // save to user defaults
    [[Settings userSettings] setCalibrationEV:[NSNumber numberWithFloat:_evSlider.value]];
    [[Settings userSettings] setCalibrationLUX:[NSNumber numberWithFloat:_luxSlider.value]];

}

-(void) updateCalibrationLabels
{
    self.evCalibrationValueLbl.text = [NSString stringWithFormat:@"%.1f", _evSlider.value];
    self.luxCalibrationValueLbl.text = [NSString stringWithFormat:@"%.2f", _luxSlider.value];
}










#pragma mark - Picker

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (self.pickerType) {
        case PickerTypeFstop:
            return self.fstopPickerValues.count;
        case PickerTypeTime:
            return self.timePickerValues.count;
        case PickerTypeIso:
            return self.isoPickerValues.count;
        default:
            return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (self.pickerType) {
        case PickerTypeFstop:
            return [@"f/" stringByAppendingString:self.fstopPickerValues[row]];
        case PickerTypeTime:
            return self.timePickerValues[row];
        case PickerTypeIso:
            return self.isoPickerValues[row];
        default:
            return 0;
    }
    
}


-(void) createShadowForPickerView
{
    CALayer *layer = self.pickerView.layer;
    layer.masksToBounds = NO;
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowOpacity = 0.8;
    layer.shadowRadius = 20;
    layer.shadowOffset = CGSizeMake(-20,0);
    layer.shadowPath = [UIBezierPath bezierPathWithRect:self.pickerView.bounds].CGPath;
}


-(void)showPicker:(enum PickerType) pickerType
{
    self.pickerType = pickerType;
    [self.picker reloadAllComponents];
    
    NSArray *values = nil;
    float lookupValue;
    if (pickerType == PickerTypeFstop){
        self.pickerViewNavigationItem.title = @"FSTOP";
        values = self.fstopPickerValues;
        lookupValue = self.fstopLocked ? self.fstopValueLocked : self.fstopValueCalculatedNormalized;
    } else if (pickerType == PickerTypeTime){
        self.pickerViewNavigationItem.title = @"TIME";
        values = self.timePickerNumericValues;
        lookupValue = self.timeLocked ? self.timeValueLocked : self.timeValueCalculatedNormalized;
    } else { // ISO
        self.pickerViewNavigationItem.title = @"ISO";
        values = self.isoPickerValues;
        lookupValue = self.isoValueLocked ? self.isoValueLocked : self.isoValueCalculatedNormalized;
    }
    NSInteger selectedRow = 0;
    for (int i=0; i<values.count; i++){
        if ( [values[i] floatValue] == lookupValue){
            selectedRow = i;
            break;
        }
    }
    
    
    [self.picker selectRow:selectedRow inComponent:0 animated:NO];
    
    self.pickerViewBottomLayoutConstraint.constant = 0;
    self.pickerView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
                        [self.view layoutIfNeeded];

                     }
                     completion:nil];
}


- (IBAction)closePicker:(id)sender
{
    NSInteger ind = [self.picker selectedRowInComponent:0];
    
    switch (self.pickerType) {
        case PickerTypeFstop:
            self.fstopValueLocked = [self.fstopPickerValues[ind] floatValue];
            [self setFstopLblText: [@"f/" stringByAppendingString:self.fstopPickerValues[ind]]];
            break;
        case PickerTypeTime:
            self.timeValueLocked = [self.timePickerNumericValues[ind] floatValue];
            [self setTimeLblText: self.timePickerValues[ind]];
            break;
        case PickerTypeIso:
            self.isoValueLocked = [self.isoPickerValues[ind] floatValue];
            [self setIsoLblText: self.isoPickerValues[ind]];
            break;
    }
    
    [self saveBrightnessValues];
    
    CGRect pickerViewFrame = self.pickerView.frame;
    self.pickerViewBottomLayoutConstraint.constant = -pickerViewFrame.size.height;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished){
                         if(finished){
                             self.pickerView.hidden = YES;
                         }
                     }];

}


@end
