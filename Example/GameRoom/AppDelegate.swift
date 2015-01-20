//
//  Created by Loki Meyburg on 2013-01-04.
//  Copyright (c) 2013 Loki Meyburg. All rights reserved.


import UIKit
//import StackerController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        var myNavController = StackerController.init(url: "http://www.thinkgeek.com/");
        myNavController.backgroundColor = "#EFEFEF";
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.rootViewController = myNavController;
        window.makeKeyAndVisible();
        
        return true
    }
    

}
