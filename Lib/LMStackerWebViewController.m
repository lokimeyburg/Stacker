//
//  LMStackerWebViewController.m
//
//  Created by @LokiMeyburg
//  MIT Licence
//

#import "LMStackerWebViewController.h"
#import "LMStackerURLParser.h"
#import "LMStackerCustomAction.h"
#import <UIDevice-Hardware/UIDevice-Hardware.h>
#import <HexColors/HexColor.h>

@interface LMStackerWebViewController ()
@property WebViewJavascriptBridge* bridge;
@end

@implementation LMStackerWebViewController

@synthesize delegate;

- (id)init
{
    return [self initWithPageURL:@"http://www.example.com" andBackgroundColor:@"FFFFFF" asRootPage:NO withRootPageTitle:@"" andRootPageTabImageName:@"tab" buttonHandlers:nil];
}

- (id)initWithPageURL:(NSString*)url
   andBackgroundColor:(NSString*)backgroundColor
           asRootPage:(BOOL)rootPageVal
    withRootPageTitle:(NSString*)rootPageTitleVal
andRootPageTabImageName:(NSString *)pageTabName
       buttonHandlers:(NSDictionary*)buttonHandlers
{
    self = [super init];
    if(self) {
        self.pageURL = url;
        self.backgroundColor = backgroundColor;
        self.rootPage = rootPageVal;
        self.requestCount = 0;
        self.rootPageTabImageName = pageTabName;
        currentlyRefreshing = NO;
        self.buttonHandlers = buttonHandlers;
    }
    return(self);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self setActiveBridge];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Setup Basics
    self.view.frame = CGRectMake(0, 0, 320, 480);

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStyleDone target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backButton];

    if ([self.delegate stackerBackgroundColor] != NULL) {
        [self.view setBackgroundColor:[UIColor colorWithHexString:[self.delegate stackerBackgroundColor]]];
    } else {
        [self.view setBackgroundColor:[UIColor colorWithHexString:@"FFFFFF"]];
    }

    // Setup Navigation Items
    [self updateNavigationItems];

    // Setup WebView
    self.myWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.myWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.myWebView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    [self loadWebView];

    // Setup Javascript Bridge
    [self setUpJavascriptBridge];

    // Setup Refresh Control
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    if ([self.delegate refreshSpinnerColor] != NULL) {
        refreshControl.tintColor = [UIColor colorWithHexString:[self.delegate refreshSpinnerColor]];
    }
    [self.myWebView.scrollView addSubview:refreshControl];
}


- (void)setActiveBridge
{
    self.delegate.bridge = _bridge;
    for (NSString *handlerName in self.delegate.messageHandlers) {
        [_bridge registerHandler:handlerName handler:self.delegate.messageHandlers[handlerName]];
    }
}

- (void)setUpJavascriptBridge {
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.myWebView
                                        webViewDelegate:self
                                                handler:^(id data, WVJBResponseCallback responseCallback) { /*..*/ }];
    [self setActiveBridge];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *requestedURL          = [[request URL] absoluteString];
    LMStackerURLParser *parser      = [[LMStackerURLParser alloc] initWithURLString:requestedURL];
    NSString *pushPageVariable      = [parser valueForVariable:@"x_push_page"];

    NSString *replacePageVariable   = [parser valueForVariable:@"x_replace_page"];

    NSString *popPage               = [parser valueForVariable:@"x_pop_page"];
    NSString *popPageAndRefresh     = [parser valueForVariable:@"x_pop_page_and_refresh"];
    NSString *popPageAndReplace     = [parser valueForVariable:@"x_pop_page_and_replace"];

    NSString *clearStack            = [parser valueForVariable:@"x_clear_stack"];
    NSString *clearStackAndRefresh  = [parser valueForVariable:@"x_clear_stack_and_refresh"];
    NSString *clearStackAndReplace  = [parser valueForVariable:@"x_clear_stack_and_replace"];

    NSString *externalURLVariable   = [parser valueForVariable:@"x_external_page"];
    NSString *customActionHandler   = [parser valueForVariable:@"x_action"];

    // Don't move to the next page if we're reshreshing the page and always ignore the first request
    // on non-root pages to ensure we don't cause an infinte loop
    if(!currentlyRefreshing && (self.rootPage || [self.requestCount intValue] > 0)) {

        // -- Custom capture paths (href="inapp://capture?x_action=foo")
        if ([request.URL.scheme isEqualToString:@"inapp"]) {
            if ([request.URL.host isEqualToString:@"capture"]) {
                NSDictionary *myHandlers = [delegate customURLHandlers];
                NSObject *myCustomAction = myHandlers[customActionHandler];
                [myCustomAction performSelector:@selector(performAction)];
            }
            return NO;
        }


        // -- Push new page
        if ([pushPageVariable isEqualToString:@"true"]) {
            [self.delegate pushNewPage:requestedURL];
            return NO;
        }

        // -- Replace page
        if([replacePageVariable isEqualToString:@"true"]) {
            [self.delegate replacePage:requestedURL];
            return NO;
        }

        // -- Go back one page
        if([popPage isEqualToString:@"true"]){
            [self.delegate popPage];
            return NO;
        }

        // -- Go back one page and refresh
        if ([popPageAndRefresh isEqualToString:@"true"]) {
            [self.delegate popPage];
            [self.delegate refreshPage];
            return NO;
        }

        // -- Go back one page and replace
        if ([popPageAndReplace isEqualToString:@"true"]) {
            [self.delegate popPage];
            [self.delegate replacePage:requestedURL];
            return NO;
        }

        // -- Clear the stack
        if([clearStack isEqualToString:@"true"]){
            [self.delegate clearStack];
            return NO;
        }

        // -- Clear the stack and refresh (useful when you post something)
        if ([clearStackAndRefresh isEqualToString:@"true"]) {
            [self.delegate clearStack];
            [self.delegate refreshPage];
            return NO;
        }

        // -- Clear the stack and replace (useful when you post something)
        if ([clearStackAndReplace isEqualToString:@"true"]) {
            [self.delegate clearStack];
            [self.delegate replacePage:requestedURL];
            return NO;
        }

        // -- External urls go in a browser
        if ([externalURLVariable isEqualToString:@"true"]) {
            // we need to strip the tilt_external_url parameter so as to keep the intended url
            NSURL *newURL = [[NSURL alloc] initWithScheme:[[request URL] scheme]
                                                     host:[[request URL] host]
                                                     path:[[request URL] path]];


            NSMutableArray* urlVariables = [parser.variables mutableCopy];
            [urlVariables enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString *parameter, NSUInteger index, BOOL *stop) {
                if ([parameter rangeOfString:@"x_external_page"].location != NSNotFound) {
                    [urlVariables removeObjectAtIndex:index];
                }
            }];
            NSString *variablesWithoutExternalParamater = [urlVariables componentsJoinedByString:@"&"];
            NSString *urlForBrowser = [[[newURL absoluteString] stringByAppendingString:@"?"] stringByAppendingString:variablesWithoutExternalParamater];
            [self.delegate showBrowserView:urlForBrowser];

            return NO;
        }

    }

    self.requestCount = [NSNumber numberWithInt:[self.requestCount intValue] + 1];

    return YES;
}

- (void) updateNavigationItems
{
    // Create our URL parser to use in the next steps
    LMStackerURLParser *parser        = [[LMStackerURLParser alloc] initWithURLString:self.pageURL];

    // Setup title
    NSString *newPageTitle          = [parser valueForVariable:@"x_page_title"];
    if([self stringIsNilOrEmpty:newPageTitle]) {
        self.title = @" ";
    } else {
        newPageTitle = [newPageTitle stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        self.title = newPageTitle;
    }

    // Setup first page title image
    if (self.rootPage) {
        if ([self.delegate rootPageTitleImage] != nil){
            self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[self.delegate rootPageTitleImage]];
        } else {
            self.navigationItem.titleView = nil;
        }
    }

    // Setup left hand button handler
    self.buttonHandlers = [self.delegate buttonHandlers];

    if (self.rootPage) {
        NSString *leftButtonHandler    = [parser valueForVariable:@"x_left_button"];
        UIBarButtonItem *ourLeftButton = self.buttonHandlers[leftButtonHandler];
        if(ourLeftButton != NULL){
            self.navigationItem.leftBarButtonItems = @[ourLeftButton];
        }
    }

    // Setup right hand button handler
    NSString *rightButtonHandler    = [parser valueForVariable:@"x_right_button"];
    self.buttonHandlers = [self.delegate buttonHandlers];
    UIBarButtonItem *ourButton = self.buttonHandlers[rightButtonHandler];
    if(ourButton != NULL){
        self.navigationItem.rightBarButtonItems = @[ourButton];
    } else {
        self.navigationItem.rightBarButtonItems = nil;
    }

}

- (void) loadWebView
{

    // Clear any previous instances so we make some room in memory
    [self.myWebView removeFromSuperview];

    // Now let's add a webview with our URL
    NSURL *url = [[NSURL alloc]initWithString:self.pageURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    request = [self requestWithStackerHeaders:request];

    [self.myWebView loadRequest:request];
    [self.myWebView setScalesPageToFit:YES];
    self.myWebView.delegate = self;
    [self.myWebView setBackgroundColor:[UIColor clearColor]];
    [self.myWebView setOpaque:NO];
    self.myWebView.scrollView.bounces = YES;
    self.myWebView.alpha = 0.0f;
    [self.view addSubview:self.myWebView];

    // Lets show a loading indicator
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = self.view.center;
    [activityIndicator startAnimating];
    if([self.delegate loadingSpinnerColor] != NULL){
        [activityIndicator setColor:[UIColor colorWithHexString:[self.delegate loadingSpinnerColor]]];
    } else {
        [activityIndicator setColor:[UIColor blackColor]];
    }
    [self.view addSubview:activityIndicator];
}


- (void) reloadWebViewInPlace
{
    currentlyRefreshing = YES;
    self.requestCount = 0;
    [self loadWebView];
    [self updateNavigationItems];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicator removeFromSuperview];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.1];
    webView.alpha = 1.0f;
    currentlyRefreshing = NO;
    [UIView commitAnimations];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [activityIndicator removeFromSuperview];

    if([error code] == -1009){
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"no-network-connection" ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [self.myWebView loadHTMLString:htmlString baseURL:nil];
    }

    if([error code] == -1004){
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"not-found" ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [self.myWebView loadHTMLString:htmlString baseURL:nil];
    }

}

-(void)handleRefresh:(UIRefreshControl *)refresh {
    // Let this instance know it's refreshing
    currentlyRefreshing = YES;

    // Reload my data
    NSString *fullURL = self.pageURL;
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    requestObj = [self requestWithStackerHeaders:requestObj];
    [self.myWebView loadRequest:requestObj];
    [refresh endRefreshing];
}

- (NSURLRequest*) requestWithStackerHeaders:(NSURLRequest*)originalRequest
{
    // Create a mutable copy of the immutable request and add more headers
    NSMutableURLRequest *mutableRequest = [originalRequest mutableCopy];
    [mutableRequest addValue:[self applicationVersion] forHTTPHeaderField:@"x-version"];
    [mutableRequest addValue:[self deviceIdentifierHeader ] forHTTPHeaderField:@"x-device-info"];

    // Now set our request variable with an (immutable) copy of the altered request
    originalRequest = [mutableRequest copy];
    return originalRequest;
}

-(BOOL)stringIsNilOrEmpty:(NSString*)aString {
    return !(aString && aString.length);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Returns a string such as "iPhone 5c (GSM);iPhone5,3;iPhone OS 7.0.4"
-(NSString*)deviceIdentifierHeader
{
    UIDevice* device = [UIDevice currentDevice];
    return [NSString stringWithFormat:@"%@;%@;%@ %@", [device modelName], [device modelIdentifier], device.systemName, device.systemVersion];
}

- (NSString*)applicationVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
}

@end
