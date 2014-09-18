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
LMStackerController *homeNavController;
LMStackerController *welcomeController;
//BOOL welcomeModalVisible = NO;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // URL of the web app
    DOMAIN_URL = @"http://localhost:3000";
    
    // 1.) Create a StackerController
    homeNavController = [[LMStackerController alloc] initWithURL:
                              [NSString stringWithFormat:@"%@%@", DOMAIN_URL, @"/design/index?x_right_button=reload_button&x_page_title=News+Feed"]];
    
    // 2.) Custom right button actions
    UIBarButtonItem *reloadPageButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadMainPage)];
    NSDictionary *buttonHandlers    = @{ @"reload_button": reloadPageButton };
    homeNavController.buttonHandlers  = buttonHandlers;
    
    // 5.) Theme the controller
    homeNavController.stackerBackgroundColor =  @"F0F1F2";
    homeNavController.rootPageTitleImage    = [UIImage imageNamed:@"logo.png"];
    homeNavController.statusBarLight        = YES;
    homeNavController.refreshSpinnerColor   = @"6F9FCD";
    homeNavController.loadingSpinnerColor   = @"1C3347";
    
    // 5.5) Extra theming (but not really Stacker specific)
    LMRGBParser *rgbParser = [[LMRGBParser alloc] init];
    homeNavController.tabBarItem.title             = @"News Feed";
    homeNavController.tabBarItem.image             = [UIImage imageNamed:@"tab-1.png"];
    homeNavController.navigationBar.barTintColor   = [rgbParser colorWithHexString:@"357ebd"];
    homeNavController.navigationBar.tintColor      = [rgbParser colorWithHexString:@"FFFFFF"];
    [homeNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [rgbParser colorWithHexString:@"FFFFFF"]}];

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [[UITabBar appearance] setTintColor:[rgbParser colorWithHexString:@"FFFFFF"]];
    [[UITabBar appearance] setBarTintColor:[rgbParser colorWithHexString:@"131313"]];
    [tabBarController addChildViewController:homeNavController];
    
    
    // Welcome Controller
    welcomeController = [[LMStackerController alloc] initWithURL:
                              [NSString stringWithFormat:@"%@%@", DOMAIN_URL, @"/users/sign_in?x_page_title=Log+In&x_right_button=show_signup_page"]];
    welcomeController.stackerBackgroundColor = @"F0F1F2";
    welcomeController.statusBarLight        = YES;
    welcomeController.navigationBar.barTintColor   = [rgbParser colorWithHexString:@"0F76C5"];
    welcomeController.navigationBar.tintColor      = [rgbParser colorWithHexString:@"FFFFFF"];
    [welcomeController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [rgbParser colorWithHexString:@"FFFFFF"]}];

    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(checkLogInStatus)
     name:NSHTTPCookieManagerCookiesChangedNotification
     object:nil];
    
    UIBarButtonItem *showSignUpPageButton   = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up"
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(showLoginPage)];
    NSDictionary *welcomeButtonHandlers    = @{ @"show_signup_page": showSignUpPageButton };
    welcomeController.buttonHandlers  = welcomeButtonHandlers;
    
    
    // Alrighty, spin up the app!
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    [self.window.rootViewController presentViewController:welcomeController animated:NO completion:NULL];
    return YES;
}

- (void)reloadMainPage
{
    NSLog(@"-- Reloading page");
    [homeNavController refreshPage];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"--- Entering foreground. Checking logged in state...");
}

-(void) checkLogInStatus
{
    BOOL welcomeModalVisible = welcomeController.isViewLoaded && welcomeController.view.window;
    BOOL isOnline = NO;
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies) {
        if([cookie.name isEqualToString:@"signed_in"] && [cookie.value isEqualToString:@"1"]){
            isOnline = YES;
        }
    }
    
    if (isOnline){
        // You are online
        if(welcomeModalVisible) {
            [self closeWelcomeModal];
        }
    } else {
        // You are offline
        if(!welcomeModalVisible) {
            [self showWelcomeModal];
        }
    }
}

-(void) closeWelcomeModal
{
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    [homeNavController clearStack];
    [homeNavController refreshPage];
}

-(void) showWelcomeModal
{
    [self.window.rootViewController presentViewController:welcomeController animated:YES completion:NULL];
    [welcomeController clearStack];
    [welcomeController refreshPage];
}

-(void) showLoginPage
{
    [welcomeController pushNewPage:[NSString stringWithFormat:@"%@%@", DOMAIN_URL, @"/users/sign_up?x_page_title=Sign+Up"]];
}

-(void) closeCustomActionPage
{
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) showSearchPage
{
    [homeNavController pushNewPage:[NSString stringWithFormat:@"%@%@", DOMAIN_URL, @"/design/search?x_page_title=Search"]];
}

-(void) showJSBridgePage
{
    [homeNavController pushNewPage:[NSString stringWithFormat:@"%@%@", DOMAIN_URL, @"/design/bridge?x_page_title=JS+Bridge+Demo&x_right_button=send_msg_to_bridge"]];
}

-(void) showNewPostPage
{
    [homeNavController pushNewPage:[NSString stringWithFormat:@"%@%@", DOMAIN_URL, @"/design/new_post?x_page_title=New+Post"]];
}

-(void) sendMessageToBridge
{
    [homeNavController.bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
}


@end

