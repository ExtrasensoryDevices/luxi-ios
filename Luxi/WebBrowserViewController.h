//
//  WebBrowserViewController.h
//  Luxi
//
//  Created by Alina Kholcheva on 8/7/13.
//  Copyright (c) 2013 Alina Kholcheva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@protocol WebViewDelegate <NSObject, UIWebViewDelegate>
- (void)closeWebView;
@end



@interface WebBrowserViewController : UIViewController

@property (weak, nonatomic) id<WebViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIWebView *webview;

-(IBAction)dismiss;

@end
