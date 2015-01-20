//
//  StackerController.swift
//  GameRoom
//
//  Created by Loki Meyburg on 2015-01-14.
//  Copyright (c) 2015 Loki Meyburg. All rights reserved.
//

import Foundation
import UIKit

class StackerController : UINavigationController, StackerWebViewControllerDelegate {
    
    var backgroundColor = "#FFFFFF";
    
    convenience init(url: String) {
        self.init();
        var myViewController = StackerWebViewController();
        myViewController.pageURL = url;
        myViewController.delegate = self;
        self.addChildViewController(myViewController);
    }
    
}