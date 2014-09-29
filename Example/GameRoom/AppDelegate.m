#import "AppDelegate.h"
#import "LMRGBParser.h"
#import "LMStackerController.h"
#import "LMStackerCustomAction.h"

@implementation AppDelegate

NSString *DOMAIN_URL;
LMStackerController *homeNavController;
LMStackerController *settingsController;
LMStackerController *welcomeController;
UITabBarController *tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // URL of the web app
    DOMAIN_URL = @"http://localhost:3000";
    
    // 1.) Create a StackerController
    homeNavController = [[LMStackerController alloc] initWithURL:
                              [NSString stringWithFormat:@"%@%@", DOMAIN_URL, @"/design/index?x_page_title=News+Feed"]];
    
    
    // 2.) Theme the controller
    homeNavController.stackerBackgroundColor =  @"F0F1F2";
    homeNavController.rootPageTitleImage    = [UIImage imageNamed:@"logo.png"];
    homeNavController.statusBarLight        = YES;
    homeNavController.refreshSpinnerColor   = @"6F9FCD";
    homeNavController.loadingSpinnerColor   = @"1C3347";
    
    // 2.5) Extra theming (but not really Stacker specific)
    LMRGBParser *rgbParser = [[LMRGBParser alloc] init];
    homeNavController.tabBarItem.title             = @"News Feed";
    homeNavController.tabBarItem.image             = [UIImage imageNamed:@"tab-1.png"];
    homeNavController.navigationBar.barTintColor   = [rgbParser colorWithHexString:@"357ebd"];
    homeNavController.navigationBar.tintColor      = [rgbParser colorWithHexString:@"FFFFFF"];
    [homeNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [rgbParser colorWithHexString:@"FFFFFF"]}];
    
    
    // 3) Settings Controller
    settingsController = [[LMStackerController alloc] initWithURL:
                                               [NSString stringWithFormat:@"%@%@", DOMAIN_URL, @"/design/settings?x_page_title=Settings"]];
    settingsController.tabBarItem.title             = @"Settings";
    settingsController.navigationBar.barTintColor   = [rgbParser colorWithHexString:@"357ebd"];
    settingsController.navigationBar.tintColor      = [rgbParser colorWithHexString:@"FFFFFF"];
    [settingsController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [rgbParser colorWithHexString:@"FFFFFF"]}];
    settingsController.tabBarItem.image             = [UIImage imageNamed:@"tab-1.png"];
    settingsController.statusBarLight        = YES;

    tabBarController = [[UITabBarController alloc] init];
    [[UITabBar appearance] setTintColor:[rgbParser colorWithHexString:@"FFFFFF"]];
    [[UITabBar appearance] setBarTintColor:[rgbParser colorWithHexString:@"131313"]];
    [tabBarController addChildViewController:homeNavController];
    [tabBarController addChildViewController:settingsController];
    
    
    // 4.) TUTORIAL: Welcome Controller
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
    
    
    // 5.) TUTORIAL: Register cookieChange observer
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
    // Refresh the home and settings pages
    [homeNavController clearStack];
    [homeNavController refreshPage];
    [settingsController clearStack];
    [settingsController refreshPage];
    
    // Go to the homepage (the first tab)
    [tabBarController setSelectedIndex:0];
    
    // Close modal
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


@end

