//
//  LMStackerWebViewController.h
//
//  Created by @LokiMeyburg
//  MIT Licence
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <WebViewJavascriptBridge/WKWebViewJavascriptBridge.h>

// Create delegate so we can call parent navigation
@protocol LMStackerWebViewControllerDelegate <NSObject>

- (void) pushNewPage:(NSString*)pageURL;
- (void) replacePage:(NSString*)pageURL;
- (void) refreshPage;
- (void) popPage;
- (void) clearStack;
- (void) showBrowserView:(NSString*)browserURL;

// Delegate navigation properties
@property UIImage                   *rootPageTitleImage;
@property NSString                  *stackerBackgroundColor;
@property NSDictionary              *customURLHandlers;
@property NSDictionary              *buttonHandlers;
@property NSString                  *refreshSpinnerColor;
@property NSString                  *loadingSpinnerColor;
@property WKWebViewJavascriptBridge *bridge;
@property NSMutableDictionary       *messageHandlers;

@end


@interface LMStackerWebViewController : UIViewController <WKNavigationDelegate> {
    UIActivityIndicatorView *activityIndicator;
    UIRefreshControl        *refreshControl;
    BOOL                    currentlyRefreshing;
}

// Delegate property
@property (assign) id <LMStackerWebViewControllerDelegate> delegate;

// Methods
- (void) loadWebView;
- (void) reloadWebViewInPlace;

// Properties
@property WKWebView     *myWebView;
@property NSString      *pageURL;
@property NSNumber      *requestCount;
@property NSString      *backgroundColor;
@property BOOL          rootPage;
@property NSString      *rootPageTitle;
@property NSString      *rootPageTabImageName;
@property NSDictionary  *buttonHandlers;


@end

