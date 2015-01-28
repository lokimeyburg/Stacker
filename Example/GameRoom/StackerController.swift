import Foundation
import UIKit

class StackerController : UINavigationController, StackerWebViewControllerDelegate, UIActionSheetDelegate {
    
    var backgroundColor = "#FFFFFF";
    var browserViewURL: String!
    var browserNavController: UINavigationController!
    
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
    
    func replacePage(url: String) {
        var currentViewController = viewControllers.last as StackerWebViewController;
        currentViewController.pageURL = url;
        currentViewController.reloadWebViewInPlace();
    }
    
    func popPage() {
        popViewControllerAnimated(true);
    }
    
    func refreshPage() {
        var currentViewController = viewControllers.last as StackerWebViewController;
        if (currentViewController.requestCount > 0) {
            currentViewController.reloadWebViewInPlace();
        }
    }
    
    func clearStack() {
        popToRootViewControllerAnimated(true);
    }

    
    // EXTERNAL BROWSER MODAL VIEW
    // ------------------------------------------------------------
    // TODO: create my own custom externalBrowser class instead of
    // doing this all inline like below
    
    func showBrowserView(url: String) {
        browserViewURL = url;
        // create the main controller
        var myRootController = UIViewController();
        myRootController.title = url;
        
        // right button
        var rightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "showBrowserActionSheet");
        myRootController.navigationItem.rightBarButtonItem = rightButton;
        
        // left button
        var leftButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "closeTheBrowserView");
        myRootController.navigationItem.leftBarButtonItem = leftButton;
        
        // Now add a webview to the main controller
        var myWebView = UIWebView(frame: myRootController.view.bounds);
        myWebView.autoresizingMask = (UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight);
        var webViewURL = NSURL(string: url);
        var request = NSURLRequest(URL: webViewURL!);
        myWebView.loadRequest(request);
        myWebView.scalesPageToFit = true;
        myWebView.backgroundColor = UIColor.whiteColor();
        myWebView.opaque = false;
        myWebView.scrollView.bounces = true;
        myRootController.view.addSubview(myWebView);

        // Put the main controller in some kind of naviation with a heading
        browserNavController = UINavigationController(rootViewController: myRootController);
        
        // Show it
        self.presentViewController(browserNavController, animated: true, completion: nil);
    }
    
    func closeTheBrowserView () {
        browserNavController.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func showBrowserActionSheet (){
        var other1 = "Copy Link";
        var other2 = "Open in Safari";
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Copy Link", "Open in Safari");
        actionSheet.showInView(UIApplication.sharedApplication().keyWindow);
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        var buttonTitle = actionSheet.buttonTitleAtIndex(buttonIndex);
        if(buttonTitle == "Copy Link"){
            let pb = UIPasteboard.generalPasteboard();
            pb.string = browserViewURL;
        } else if (buttonTitle == "Open in Safari") {
            UIApplication.sharedApplication().openURL(NSURL(string: browserViewURL)!);
        }
    }
    
//    - (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//    {
//    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
//    if ([buttonTitle isEqualToString:@"Copy Link"]) {
//    UIPasteboard *pb = [UIPasteboard generalPasteboard];
//    [pb setString:browserViewURL];
//    }
//    if ([buttonTitle isEqualToString:@"Open in Safari"]) {
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:browserViewURL]];
//    }
//    }

    
    // END: EXTERNAL BROWSER MODAL VIEW
}