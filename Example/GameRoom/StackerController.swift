import Foundation
import UIKit

class StackerController : UINavigationController, StackerWebViewControllerDelegate {
    
    var backgroundColor = "#FFFFFF";
    
    convenience init(url: String) {
        self.init();
        var myViewController = StackerWebViewController();
        myViewController.pageURL = url;
        myViewController.delegate = self;
        myViewController.rootPage = true;
        self.addChildViewController(myViewController);
    }
    
    
    func pushNewPage(url: String) {
        var newController = StackerWebViewController();
        newController.pageURL = url;
        newController.delegate = self;
        pushViewController(newController, animated: true);
    }
    
}