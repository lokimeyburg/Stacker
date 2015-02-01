import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        var myNavController = StackerController.init(url: "http://127.0.0.1.xip.io:3000/design/bridge?x_page_title=GameRoom");
        myNavController.backgroundColor = "#f8f8f8";
        
        
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.rootViewController = myNavController;
        window.makeKeyAndVisible();
        
        return true
    }



}
