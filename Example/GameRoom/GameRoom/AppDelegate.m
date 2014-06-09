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
                              [NSString stringWithFormat:@"%@%@", DOMAIN_URL, @"/design/index?x_right_button=search_button&x_page_title=News+Feed"]];
    
    // 2.) Custom right button actions
    UIBarButtonItem *newPostButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(showNewPostPage)];
    UIBarButtonItem *searchButton   = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(showSearchPage)];
    UIBarButtonItem *saveProfile    = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(sendMessageToBridge)];
    saveProfile.enabled = NO;
    
    NSDictionary *buttonHandlers    = @{ @"new_post": newPostButton, @"search_button": searchButton, @"save_profile": saveProfile  };
    self.homeNavController.buttonHandlers  = buttonHandlers;
    
    
    // 3.) Custom URL Actions
    LMStackerCustomAction *myCustomAction = [[LMStackerCustomAction alloc] init];
    [myCustomAction addTarget:self action:@selector(showModalView:) withParameter:self ];
    
    NSDictionary *customURLHandlers = @{ @"myAction" : myCustomAction };
    [self.homeNavController setCustomURLHandlers:customURLHandlers];
    
    
    // 4.) Theme the controller
    self.homeNavController.stackerBackgroundColor =  @"F0F1F2";
    self.homeNavController.rootPageTitleImage    = [UIImage imageNamed:@"logo.png"];
    self.homeNavController.tabBarItem.image      = [UIImage imageNamed:@"tab-1.png"];
    self.homeNavController.statusBarLight        = YES;
    self.homeNavController.refreshSpinnerColor   = @"6F9FCD";
    self.homeNavController.loadingSpinnerColor   = @"1C3347";
    
    // 4.5) Extra theming (but not really Stacker specific)
    LMRGBParser *rgbParser = [[LMRGBParser alloc] init];
    self.homeNavController.tabBarItem.title = @"News Feed";
    self.homeNavController.navigationBar.barTintColor   = [rgbParser colorWithHexString:@"357ebd"];
    self.homeNavController.navigationBar.tintColor      = [rgbParser colorWithHexString:@"FFFFFF"];
    [self.homeNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [rgbParser colorWithHexString:@"FFFFFF"]}];
    
    
    // 5.) Create some tabs in the footer of the app
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    [[UITabBar appearance] setTintColor:[rgbParser colorWithHexString:@"FFFFFF"]];
    [[UITabBar appearance] setBarTintColor:[rgbParser colorWithHexString:@"212D39"]];
    tabBarController.tabBar.translucent = NO;
    
    
    // 6.) Some extra stuff for the demo
    LMStackerController *profileNavController = [[LMStackerController alloc] initWithURL:
                                                 [NSString stringWithFormat:@"%@%@", DOMAIN_URL, @"/design/my_profile?x_page_title=Profile&x_right_button=save_profile"]];
    profileNavController.tabBarItem.title       = @"Profile";
    profileNavController.tabBarItem.image       = [UIImage imageNamed:@"tab-1.png"];
    profileNavController.stackerBackgroundColor =  @"F0F1F2";
    profileNavController.buttonHandlers         = buttonHandlers;
    [profileNavController setCustomURLHandlers:customURLHandlers];
    
    [profileNavController registerHandler:@"enableSaveButton" handler:^(id data, WVJBResponseCallback responseCallback) {
        saveProfile.enabled = YES;
    }];
    
    [tabBarController addChildViewController:profileNavController];
    [tabBarController addChildViewController:self.homeNavController];
    
    
    // Alrighty, spin up the app!
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)showModalView:(id)sender
{
    // Create the main controller
    UIViewController *myRootController = [[UIViewController alloc] init];
    myRootController.title = @"Custom Action";
    
    
    // Left button
    myRootController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(closeTheBrowserView)];
    
    // Now add a webview to the main controller
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
    
    // Put the main controller in some kind of naviation with a heading
    LMStackerBrowserController *newPostController = [[LMStackerBrowserController alloc] initWithRootViewController:myRootController];
    
    // Show it
    [self.window.rootViewController presentViewController:newPostController animated:YES completion:NULL];
}

-(void) closeTheBrowserView
{
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) showSearchPage
{
    [self.homeNavController pushNewPage:[NSString stringWithFormat:@"%@%@", DOMAIN_URL, @"/design/search?x_page_title=Search"]];
}

-(void) showNewPostPage
{
    [self.homeNavController pushNewPage:[NSString stringWithFormat:@"%@%@", DOMAIN_URL, @"/design/new_post?x_page_title=New+Post"]];
}

-(void) sendMessageToBridge
{
    [self.homeNavController.bridge send:@"oh hai there!"];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

