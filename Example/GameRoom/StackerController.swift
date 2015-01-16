//
//  StackerController.swift
//  GameRoom
//
//  Created by Loki Meyburg on 2015-01-14.
//  Copyright (c) 2015 Loki Meyburg. All rights reserved.
//

import Foundation
import UIKit

class StackerController : UINavigationController {
    
    
    class func initWithURL(url: NSString) -> StackerController {
        
        var myViewController = StackerWebViewController();
        
        var returnable = self.init(rootViewController: myViewController);
        return returnable;
    }
    
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.view.backgroundColor = UIColor.redColor();
//    }

    
//    -(id)initWithURL:(NSString*)url
//    {
//    self = [super init];
//    
//    LMStackerWebViewController *rootViewController = [[LMStackerWebViewController alloc] init];
//    rootViewController.pageURL = url;
//    rootViewController.rootPage = YES;
//    
//    // init message handlers for the Javascript Bridge
//    self.messageHandlers = [NSMutableDictionary dictionary];
//    
//    self = [self initWithRootViewController:rootViewController];
//    
//    return(self);
//    }
    
    
}