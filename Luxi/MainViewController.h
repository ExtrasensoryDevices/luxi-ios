//
//  MainViewController.h
//  Luxi
//
//  Created by Alina Kholcheva on 2013-09-27.
//  Copyright (c) 2013 Alina Kholcheva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
#import "WebBrowserViewController.h"
#import "OnboardingViewController.h"
#import "CameraView.h"




@interface MainViewController : UIViewController <CameraViewDelegate, SettingsViewDelegate, WebViewDelegate, OnboardingViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@end
