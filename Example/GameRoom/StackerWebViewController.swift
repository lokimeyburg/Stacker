import Foundation
import UIKit

protocol StackerWebViewControllerDelegate {
    var backgroundColor: String { get }
    func pushNewPage(url: String)
    func replacePage(url: String)
    func refreshPage()
    func popPage()
    func clearStack()
    func showBrowserView(url: String)
}

class StackerWebViewController : UIViewController, UIWebViewDelegate {
    
    var myWebView           : UIWebView!
    var activityIndicator   : UIActivityIndicatorView!
    var refreshControl      : UIRefreshControl!
    var pageURL             : String!
    var bridge              : StackerBridge!
    var delegate            : StackerWebViewControllerDelegate?
    var currentlyRefreshing = true
    var rootPage            = false
    var requestCount        = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.frame = CGRectMake(0, 0, 320, 480)

        // Hide 'back button' text
        var backButton = UIBarButtonItem(title: " ", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
        
        if let bgColor = delegate?.backgroundColor {
           view.backgroundColor = UIColor(rgba: bgColor)
        } else {
            view.backgroundColor = UIColor.whiteColor()
        }
        
        updateNavigationItems()
        
        myWebView = UIWebView(frame: self.view.bounds)
        myWebView.autoresizingMask = (UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight)
        
        loadWebView()
        
        bridge = StackerBridge(webView: myWebView, webViewDelegate: self, { (data, responseCallback) -> () in
            // do nothing
        })
        
        bridge.registerHandler("testSwiftCallback", handler: { (data, responseCallback) -> () in
            responseCallback(data:"Hello world. This is swift!")
        })
        
        // Demo Button
        var bridgeDemoButton = UIBarButtonItem(title: "Test", style: UIBarButtonItemStyle.Bordered, target: self, action: "sendMessageToBridge")
        navigationItem.rightBarButtonItems = [bridgeDemoButton]
        
        // Refresh Control
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("handleRefresh:"), forControlEvents: UIControlEvents.ValueChanged)

        myWebView.scrollView.addSubview(refreshControl)
    }
    
    func sendMessageToBridge() {
        
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        var requestedURL = request.URL.absoluteString
        var parser = StackerURLParser(url: requestedURL!)
        
        var pushPageVariable        = parser.valueForVariable("x_push_page")
        var replacePageVariable     = parser.valueForVariable("x_replace_page")
        var popPage                 = parser.valueForVariable("x_pop_page")
        var popPageAndRefresh       = parser.valueForVariable("x_pop_page_and_refresh")
        var popPageAndReplace       = parser.valueForVariable("x_pop_page_and_replace")
        var clearStack              = parser.valueForVariable("x_clear_stack")
        var clearStackAndRefresh    = parser.valueForVariable("x_clear_stack_and_refresh")
        var clearStackAndReplace    = parser.valueForVariable("x_clear_stack_and_replace")
        var externalURLVariable     = parser.valueForVariable("x_external_page")
        var customActionHandler     = parser.valueForVariable("x_action")
        
        // Don't move to the next page if we're reshreshing the page and always ignore the first request
        // on non-root pages to ensure we don't cause an infinte loop
        if(!currentlyRefreshing && (rootPage || requestCount > 0)) {
            // -- Push page
            if(pushPageVariable == "true") {
                delegate?.pushNewPage(requestedURL!)
                return false
            }
            // -- Replace page
            if(replacePageVariable == "true") {
                delegate?.replacePage(requestedURL!)
                return false
            }
            // -- Go back one page
            if(popPage == "true") {
                delegate?.popPage()
                return false
            }
            
            // -- Go back one page and refresh
            if(popPageAndRefresh == "true") {
                delegate?.popPage()
                delegate?.refreshPage()
                return false
            }
            
            // -- Go back one page and replace
            if(popPageAndReplace == "true") {
                delegate?.popPage()
                delegate?.replacePage(requestedURL!)
                return false
            }
            
            // -- Clear the stack
            if(clearStack == "true") {
                delegate?.clearStack()
                return false
            }
            
            // -- Clear the stack and refresh (useful when you post something)
            if(clearStackAndRefresh == "true") {
                delegate?.clearStack()
                delegate?.refreshPage()
                return false
            }
            
            // -- Clear the stack and refresh (useful when you post something)
            if(clearStackAndReplace == "true") {
                delegate?.clearStack()
                delegate?.replacePage(requestedURL!)
                return false
            }
            
            // -- External urls go in a browser
            if(externalURLVariable == "true") {
                // TODO: we need to strip the x_external_url parameter so as to keep the intended url
                var newURL = NSURL(scheme: request.URL.scheme!, host: request.URL.host!, path: request.URL.path!)
                delegate?.showBrowserView(requestedURL!)
                return false
            }
        }
        
        requestCount++
        return true
    }

    func updateNavigationItems() {
        var parser = StackerURLParser(url: pageURL)
        
        var newPageTitle = parser.valueForVariable("x_page_title")
        
        if let pageTitle = newPageTitle {
            title = pageTitle.stringByReplacingOccurrencesOfString("+", withString: " ")
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activityIndicator.removeFromSuperview()
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.1)
        webView.alpha = 1
        currentlyRefreshing = false
        UIView.commitAnimations()
    }

    func loadWebView(){
        myWebView.removeFromSuperview()
        
        var myURL = NSURL(string: pageURL)?
        var myURLRequest = NSURLRequest(URL: myURL!)
        myWebView.loadRequest(myURLRequest)
        
        myWebView.scalesPageToFit = true
        myWebView.delegate = self
        myWebView.backgroundColor = UIColor.clearColor()
        myWebView.opaque = true
        myWebView.scrollView.bounces = true
        myWebView.alpha = 0
        view.addSubview(myWebView)
        
        // Show the loading indicator
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        
        view.addSubview(activityIndicator)
    }

    func  handleRefresh(refresh: UIRefreshControl){
        currentlyRefreshing = true
        var url = NSURL(string: pageURL)
        var request = NSURLRequest(URL: url!)
        myWebView.loadRequest(request)
        refresh.endRefreshing()
    }
    
    func reloadWebViewInPlace() {
        currentlyRefreshing = true
        requestCount = 0
        loadWebView()
        updateNavigationItems()
    }

    
}