//
//  OnboardingViewController.m
//  Luxi
//
//  Created by Alina Kholcheva on 2014-07-01.
//  Copyright (c) 2014 Alina Kholcheva. All rights reserved.
//

#import "OnboardingViewController.h"
#import "ScreenSizeClass.h"

@interface OnboardingViewController (){
    NSInteger _currentIndex;
}

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageImages;



@end

@implementation OnboardingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // FIXME: ONBOARDING
    
    
    switch (ScreenSizeClass.phoneSize) {
        case ScreenSizePhone3_5inch:
        case ScreenSizePhone4inch:
        case ScreenSizeIPad:
        case ScreenSizePhone5_5inch:
            _pageImages = @[@"Onboarding_1", @"Onboarding_2"]; //5, 6+, 7+, 8+, iPad
            break;
            
        case ScreenSizePhone5_8inch: //X, XS
            _pageImages = @[@"Onboarding_iPhone6_1", @"Onboarding_iPhone6_2"];
            break;
        case ScreenSizePhone6_5inch: //XS Max, XR
            if (UIScreen.mainScreen.scale == 3) {
                _pageImages = @[@"Onboarding_1", @"Onboarding_2"]; // xs max
            } else {
                _pageImages = @[@"Onboarding_iPhoneXR_1", @"Onboarding_iPhoneXR_2"]; // xr 
            }
            break;
        case ScreenSizePhone4_7inch:
            _pageImages = @[@"Onboarding_iPhone6_1", @"Onboarding_iPhone6_2"]; //6, 7, 8
            break;
    }
    
    _currentIndex = 0;
    [self updateImage];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTapped)];
    [self.view addGestureRecognizer:recognizer];
    
    
}

-(void) imageTapped
{
    if (_currentIndex == _pageImages.count-1) {
        [self.onboardingViewDelegate dismissOnboarding];
    } else {
        _currentIndex++;
        [self updateImage];
    }
}

-(void) updateImage
{
    [UIView transitionWithView:self.view
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.imageView.image = [UIImage imageNamed:self.pageImages[self->_currentIndex]];
                    } completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
