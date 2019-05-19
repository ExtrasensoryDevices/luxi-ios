//
//  WebBrowserViewController.m
//  Luxi
//
//  Created by Alina Kholcheva on 8/7/13.
//  Copyright (c) 2013 Alina Kholcheva. All rights reserved.
//

#import "WebBrowserViewController.h"

@interface WebBrowserViewController ()

@end

@implementation WebBrowserViewController

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
	// Do any additional setup after loading the view.
    
    NSURL *url = [NSURL URLWithString:@"https://luxiforall.com/buy-now"]; //@"http://luxiforall.com/buy-now
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webview loadRequest:request];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    MBProgressHUD *theHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    theHUD.userInteractionEnabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle: nil
                                 message:@"Website is temporary unavailable. Please try again later."
                                 preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self dismiss];
    }];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}


-(IBAction)dismiss{
    if (self.delegate){
        [self.delegate closeWebView];
    }
    
}


@end
