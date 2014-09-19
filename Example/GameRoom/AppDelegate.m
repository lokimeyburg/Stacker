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
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookieAcceptPolicy];
    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies) {
        NSLog(@"%@ => %@ ", cookie.name, cookie.value);
    }
    
    // URL of the web app
    DOMAIN_URL = @"http://localhost:3000";
    
    // 1.) Create a StackerController
    homeNavController = [[LMStackerController alloc] initWithURL:
                              [NSString stringWithFormat:@"%@%@", DOMAIN_URL, @"/design/index?x_page_title=News+Feed"]];
    
    
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
    
    LMStackerController *settingsController = [[LMStackerController alloc] initWithURL:
                                               [NSString stringWithFormat:@"%@%@", DOMAIN_URL, @"/design/settings?x_page_title=Settings"]];
    settingsController.tabBarItem.title             = @"Settings";
    settingsController.navigationBar.barTintColor   = [rgbParser colorWithHexString:@"357ebd"];
    settingsController.navigationBar.tintColor      = [rgbParser colorWithHexString:@"FFFFFF"];
    [settingsController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [rgbParser colorWithHexString:@"FFFFFF"]}];
    settingsController.tabBarItem.image             = [UIImage imageNamed:@"tab-1.png"];
    settingsController.statusBarLight        = YES;

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [[UITabBar appearance] setTintColor:[rgbParser colorWithHexString:@"FFFFFF"]];
    [[UITabBar appearance] setBarTintColor:[rgbParser colorWithHexString:@"131313"]];
    [tabBarController addChildViewController:homeNavController];
    [tabBarController addChildViewController:settingsController];
    
    
    // Welcome Controller
    welcomeController = [[LMStackerController alloc] initWithURL:
                              [NSString stringWithFormat:@"%@%@", DOMAIN_URL, @"/users/sign_in?x_page_title=Welcome&x_right_button=show_signup_page"]];
    welcomeController.stackerBackgroundColor = @"F0F1F2";
    welcomeController.statusBarLight        = YES;
    welcomeController.navigationBar.barTintColor   = [rgbParser colorWithHexString:@"357ebd"];
    welcomeController.navigationBar.tintColor      = [rgbParser colorWithHexString:@"FFFFFF"];
    [welcomeController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [rgbParser colorWithHexString:@"FFFFFF"]}];
    

    
    UIBarButtonItem *showSignUpPageButton   = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up"
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(showLoginPage)];
    NSDictionary *welcomeButtonHandlers    = @{ @"show_signup_page": showSignUpPageButton };
    welcomeController.buttonHandlers  = welcomeButtonHandlers;
    
    
    // Register cookieChange observer 
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(checkLogInStatus)
     name:NSHTTPCookieManagerCookiesChangedNotification
     object:nil];
    
    
    // Alrighty, spin up the app!
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
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
    [homeNavController clearStack];
    [homeNavController refreshPage];
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) showWelcomeModal
{
    [welcomeController clearStack];
    [welcomeController refreshPage];
    [self.window.rootViewController presentViewController:welcomeController animated:YES completion:NULL];
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

