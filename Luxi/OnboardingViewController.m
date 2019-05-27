//
//  OnboardingViewController.m
//  Luxi
//
//  Created by Alina on 2014-07-01.
//  Copyright (c) 2014 Owen Davis. All rights reserved.
//

#import "OnboardingViewController.h"

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
//    NSUInteger platformType = [[UIDevice currentDevice] platformType];
//    if (platformType == UIDevice6iPhone) {
//        _pageImages = @[@"Onboarding_iPhone6_1", @"Onboarding_iPhone6_2"]; //6, 7, 8, x, xr, xs
//    } else {
        _pageImages = @[@"Onboarding_1", @"Onboarding_2"]; //5, 6+, 7+, 8+, xs max
//    }

    
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
