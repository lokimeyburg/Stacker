//
//  Created by Loki Meyburg on 2013-01-04.
//  Copyright (c) 2013 Loki Meyburg. All rights reserved.
//

#import "AppDelegate.h"
#import "LMRGBParser.h"
#import "LMStackerController.h"
#import "LMStackerCustomAction.h"

@implementation AppDelegate

NSString *DOMAIN_URL;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // URL of the web app
    DOMAIN_URL = @"http://localhost:3000";
    
    // 1.) Create a StackerController
    self.homeNavController = [[LMStackerController alloc] initWithURL:
                              [NSString stringWithFormat:@"%@%@", DOMAIN_URL, @"/design/index?x_right_button=search_button&x_left_button=bridge_demo&x_page_title=News+Feed"]];
    
    // 2.) Custom right button actions
    UIBarButtonItem *newPostButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showNewPostPage)];
    UIBarButtonItem *searchButton   = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearchPage)];
    UIBarButtonItem *bridgeDemoButton     = [[UIBarButtonItem alloc] initWithTitle:@"Bridge" style:UIBarButtonItemStyleBordered target:self action:@selector(showJSBridgePage)];
    UIBarButtonItem *sendMessageToBridge     = [[UIBarButtonItem alloc] initWithTitle:@"Fire" style:UIBarButtonItemStyleBordered target:self action:@selector(sendMessageToBridge)];
    
    NSDictionary *buttonHandlers    = @{ @"new_post": newPostButton,
                                         @"search_button": searchButton,
                                         @"bridge_demo": bridgeDemoButton,
                                         @"send_msg_to_bridge": sendMessageToBridge  };
    self.homeNavController.buttonHandlers  = buttonHandlers;
    
    // 3.) Javascript Bridge handler
    [self.homeNavController registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        responseCallback(@"Response from testObjcCallback");
    }];
    
    // 4.) Custom URL Actions
    LMStackerCustomAction *myCustomAction = [[LMStackerCustomAction alloc] init];
    [myCustomAction addTarget:self action:@selector(showCustomActionPage:) withParameter:self ];
    
    NSDictionary *customURLHandlers = @{ @"myAction" : myCustomAction };
    [self.homeNavController setCustomURLHandlers:customURLHandlers];
    
    
    // 5.) Theme the controller
    self.homeNavController.stackerBackgroundColor =  @"F0F1F2";
    self.homeNavController.rootPageTitleImage    = [UIImage imageNamed:@"logo.png"];
    self.homeNavController.statusBarLight        = YES;
    self.homeNavController.refreshSpinnerColor   = @"6F9FCD";
    self.homeNavController.loadingSpinnerColor   = @"1C3347";
    
    // 5.5) Extra theming (but not really Stacker specific)
    LMRGBParser *rgbParser = [[LMRGBParser alloc] init];
    self.homeNavController.tabBarItem.title             = @"News Feed";
    self.homeNavController.tabBarItem.image             = [UIImage imageNamed:@"tab-1.png"];
    self.homeNavController.navigationBar.barTintColor   = [rgbParser colorWithHexString:@"357ebd"];
    self.homeNavController.navigationBar.tintColor      = [rgbParser colorWithHexString:@"FFFFFF"];
    [self.homeNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [rgbParser colorWithHexString:@"FFFFFF"]}];

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [[UITabBar appearance] setTintColor:[rgbParser colorWithHexString:@"FFFFFF"]];
    [[UITabBar appearance] setBarTintColor:[rgbParser colorWithHexString:@"131313"]];
    [tabBarController addChildViewController:self.homeNavController];
    
    
    // Alrighty, spin up the app!
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

// Functions for the purpose of the demo:
// --------------------------------------

-(void)showCustomActionPage:(id)sender
{
    UIViewController *myRootController = [[UIViewController alloc] init];
    myRootController.title = @"Custom Action";
    
    myRootController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(closeCustomActionPage)];
    
    UIWebView *myWebView = [[UIWebView alloc] initWithFrame:myRootController.view.bounds];
    myWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@%@", DOMAIN_URL, @"/design/custom_action"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [myWebView loadRequest:request];
    [myWebView setScalesPageToFit:YES];
    [myWebView setBackgroundColor:[UIColor clearColor]];
    [myWebView setOpaque:NO];
    myWebView.scrollView.bounces = YES;
    [myRootController.view addSubview:myWebView];
    
    LMStackerBrowserController *newPostController = [[LMStackerBrowserController alloc] initWithRootViewController:myRootController];

    [self.window.rootViewController presentViewController:newPostController animated:YES completion:NULL];
}

-(void) closeCustomActionPage
{
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) showSearchPage
{
    [self.homeNavController pushNewPage:[NSString stringWithFormat:@"%@%@", DOMAIN_URL, @"/design/search?x_page_title=Search"]];
}

-(void) showJSBridgePage
{
    [self.homeNavController pushNewPage:[NSString stringWithFormat:@"%@%@", DOMAIN_URL, @"/design/bridge?x_page_title=JS+Bridge+Demo&x_right_button=send_msg_to_bridge"]];
}

-(void) showNewPostPage
{
    [self.homeNavController pushNewPage:[NSString stringWithFormat:@"%@%@", DOMAIN_URL, @"/design/new_post?x_page_title=New+Post"]];
}

-(void) sendMessageToBridge
{
    [self.homeNavController.bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
}


@end

