//
//  OnboardingViewController.m
//  Luxi
//
//  Created by Alina on 2014-07-01.
//  Copyright (c) 2014 Owen Davis. All rights reserved.
//

#import "OnboardingViewController.h"
#import "UIDevice-Hardware.h"

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
    
    UIDeviceFamily deviceFamily = [[UIDevice currentDevice] deviceFamily];
    if (deviceFamily == UIDeviceFamilyiPad ){
        _pageImages = @[@"Onboarding_Luxi_1.png", @"Onboarding_Luxi_2.png"];
    } else { // iphone
        if (self.luxiView){
            _pageImages = @[@"Onboarding_Luxi_1.png", @"Onboarding_Luxi_2.png"];
        } else {
            _pageImages = @[@"Onboarding_NoLuxi_1.png", @"Onboarding_NoLuxi_2.png"];
        }
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
                        self.imageView.image = [UIImage imageNamed:self.pageImages[_currentIndex]];
                    } completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
