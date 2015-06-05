//
//  LMStackerController.m
//
//  Created by @LokiMeyburg
//  MIT Licence
//

#import "LMStackerController.h"
#import "LMStackerWebViewController.h"
#import <HexColors/HexColor.h>

@interface LMStackerController ()

@end

@implementation LMStackerController

@synthesize delegate;



-(id)initWithURL:(NSString*)url
{
    self = [super init];

    LMStackerWebViewController *rootViewController = [[LMStackerWebViewController alloc] init];
    rootViewController.pageURL = url;
    rootViewController.rootPage = YES;
    
    // init message handlers for the Javascript Bridge
    self.messageHandlers = [NSMutableDictionary dictionary];

    self = [self initWithRootViewController:rootViewController];

    return(self);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (id)initWithRootViewController:(LMStackerWebViewController *)rootViewController
{
    if ((self = [super initWithRootViewController:rootViewController])) {
        rootViewController.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [self setNeedsStatusBarAppearanceUpdate];
    [super viewDidLoad];
}

-(UIStatusBarStyle)preferredStatusBarStyle{

    if(self.statusBarLight){
        return UIStatusBarStyleLightContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}


- (void) showBrowserView:(NSString*)browserURL
{
    browserViewURL = browserURL;

    // Create the main controller
    UIViewController *myRootController = [[UIViewController alloc] init];
    myRootController.title = browserURL;


    // Right button
    UIBarButtonItem *rightbutton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showBrowserActionSheet:)];
    myRootController.navigationItem.rightBarButtonItem = rightbutton;

    // Left button
    UIBarButtonItem *leftbutton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(closeTheBrowserView)];
    myRootController.navigationItem.leftBarButtonItem = leftbutton;

    // Now add a webview to the main controller
    UIWebView *myWebView = [[UIWebView alloc] initWithFrame:myRootController.view.bounds];
    myWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    myWebView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    NSURL *url = [[NSURL alloc]initWithString:browserURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [myWebView loadRequest:request];
    [myWebView setScalesPageToFit:YES];
    [myWebView setBackgroundColor:[UIColor clearColor]];
    [myWebView setOpaque:NO];
    myWebView.scrollView.bounces = YES;
    [myRootController.view addSubview:myWebView];

    // Put the main controller in some kind of naviation with a heading
    browserNavController = [[LMStackerBrowserController alloc] initWithRootViewController:myRootController];
    browserNavController.navigationBar.barTintColor = [UIColor colorWithHexString:@"EBEBEB"];
    browserNavController.navigationBar.tintColor = [UIColor colorWithHexString:@"666666"];
    browserNavController.navigationBar.translucent = YES;

    // Show it
    [self presentViewController:browserNavController animated:YES completion:nil];
}

- (void) pushStackerWebViewController:(LMStackerWebViewController*)newStackerWebViewController animated:(BOOL)animatedVal
{
    newStackerWebViewController.delegate = self;
    [self pushViewController:newStackerWebViewController animated:animatedVal];
}

-(void) closeTheBrowserView
{
    [browserNavController dismissViewControllerAnimated:YES completion:nil];
}

- (void)showBrowserActionSheet:(id)sender
{
    NSString *other1 = @"Copy Link";
    NSString *other2 = @"Open in Safari";
    NSString *cancelTitle = @"Cancel";
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:other1, other2, nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Copy Link"]) {
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString:browserViewURL];
    }
    if ([buttonTitle isEqualToString:@"Open in Safari"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:browserViewURL]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)pushNewPage:(NSString*)pageURL
{
    LMStackerWebViewController *newViewController = [[LMStackerWebViewController alloc] init];
    newViewController.pageURL = pageURL;

    newViewController.delegate = self;
    [self pushViewController:newViewController animated:YES];
}

-(void)popPage
{
    [self popViewControllerAnimated:YES];
}

-(void)clearStack
{
    [self popToRootViewControllerAnimated:YES];
}

-(void)refreshPage
{
    LMStackerWebViewController *currentViewController = self.viewControllers.lastObject;
    if(currentViewController.requestCount > 0){
        [currentViewController reloadWebViewInPlace];
    }
}

-(void)replacePage:(NSString*)newURL
{
    LMStackerWebViewController *currentViewController = self.viewControllers.lastObject;
    currentViewController.pageURL = newURL;
    [currentViewController reloadWebViewInPlace];
}

- (void)registerHandler:(NSString *)handlerName handler:(WVJBHandler)handler {
    self.messageHandlers[handlerName] = [handler copy];
}


@end
