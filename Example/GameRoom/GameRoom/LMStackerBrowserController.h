//
//  BrowserViewController.h
//  AlphaTouch
//
//  Created by Loki Meyburg on 2013-12-04.
//  Copyright (c) 2013 Loki Meyburg. All rights reserved.
//

#import <UIKit/UIKit.h>

// Create delegate so we can call parent navigation
@protocol LMStackerBrowserControllerDelegate <UINavigationControllerDelegate>
- (void)dismissBrowserView;
@end


@interface LMStackerBrowserController : UINavigationController <UIWebViewDelegate> {
    UIActivityIndicatorView *activityIndicator;
    UIWebView *myWebView;
}

// Delegate property
@property (nonatomic,assign) id <LMStackerBrowserControllerDelegate, UINavigationControllerDelegate> delegate;

@end
