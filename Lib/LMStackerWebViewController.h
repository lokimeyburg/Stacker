//
//  LMStackerWebViewController.h
//
//  Created by @LokiMeyburg
//  MIT Licence
//

#import <UIKit/UIKit.h>

// Create delegate so we can call parent navigation
@protocol LMStackerWebViewControllerDelegate <NSObject>

- (void) pushNewPage:(NSString*)pageURL;
- (void) replacePage:(NSString*)pageURL;
- (void) refreshPage;
- (void) popPage;
- (void) clearStack;

- (void) showBrowserView:(NSString*)browserURL;

@property UIImage *rootPageTitleImage;
@property NSString *stackerBackgroundColor;
@property NSDictionary *customURLHandlers;
@property NSDictionary *buttonHandlers;
@property NSString *refreshSpinnerColor;
@property NSString *loadingSpinnerColor;

@end


@interface LMStackerWebViewController : UIViewController <UIWebViewDelegate> {
    UIActivityIndicatorView *activityIndicator;
    UIRefreshControl *refreshControl;
    BOOL *currentlyRefreshing;
    
}

// Delegate property
@property (assign) id <LMStackerWebViewControllerDelegate> delegate;

// Methods
- (void) loadWebView;
- (void) reloadWebViewInPlace;

// Properties
@property UIWebView *myWebView;
@property NSString *pageURL;
@property NSNumber *requestCount;
@property NSString *backgroundColor;
@property BOOL *rootPage;
@property NSString *rootPageTitle;
@property NSString *rootPageTabImageName;
@property NSDictionary *buttonHandlers;


@end

