//
//  BrowserViewController.m
//  AlphaTouch
//
//  Created by Loki Meyburg on 2013-12-04.
//  Copyright (c) 2013 Loki Meyburg. All rights reserved.
//

#import "LMStackerBrowserController.h"

@interface LMStackerBrowserController ()

@end

@implementation LMStackerBrowserController

@synthesize delegate;

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
    [self.view setBackgroundColor:[UIColor whiteColor]];

}

-(void) popBack {

}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{


}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activityIndicator removeFromSuperview];

    // Dont show error message for retries (-999)
    if([error code] == -1009){
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"no-network-connection" ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [myWebView loadHTMLString:htmlString baseURL:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
