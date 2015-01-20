//
//  StackerWebViewController.swift
//  GameRoom
//
//  Created by Loki Meyburg on 2015-01-14.
//  Copyright (c) 2015 Loki Meyburg. All rights reserved.
//

import Foundation
import UIKit

protocol StackerWebViewControllerDelegate {
    var backgroundColor: String { get };
}

class StackerWebViewController : UIViewController, UIWebViewDelegate {
    
    var myWebView           : UIWebView!
    var activityIndicator   : UIActivityIndicatorView!
    var currentlyRefreshing : Bool!
    var refreshControl      : UIRefreshControl!
    var pageURL             : String!
    var delegate            : StackerWebViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Basics
        view.frame = CGRectMake(0, 0, 320, 480);

        // Hide 'back button' text
        var backButton = UIBarButtonItem(title: " ", style: UIBarButtonItemStyle.Done, target: nil, action: nil);
        navigationItem.backBarButtonItem = backButton;
        
        // TODO: set background color from delegate
        view.backgroundColor = UIColor.whiteColor();
        println(delegate?.backgroundColor);
        
        // TODO: set up navigation items
        
        myWebView = UIWebView(frame: self.view.bounds);
        myWebView.autoresizingMask = (UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight);
        loadWebView();
        
        refreshControl = UIRefreshControl();
        refreshControl.addTarget(self, action: Selector("handleRefresh:"), forControlEvents: UIControlEvents.ValueChanged);

        // TODO: set refresh control color from delegate
        
        myWebView.scrollView.addSubview(refreshControl);
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        return true;
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activityIndicator.removeFromSuperview();
        UIView.beginAnimations(nil, context: nil);
        UIView.setAnimationDuration(0.1);
        webView.alpha = 1;
        currentlyRefreshing = false;
        UIView.commitAnimations();
    }

    func loadWebView(){
        myWebView.removeFromSuperview();
        
        var myURL = NSURL(string: pageURL)?;
        var myURLRequest = NSURLRequest(URL: myURL!);
        myWebView.loadRequest(myURLRequest);
        
        myWebView.scalesPageToFit = true;
        myWebView.delegate = self;
        myWebView.backgroundColor = UIColor.clearColor();
        myWebView.opaque = true;
        myWebView.scrollView.bounces = true;
        myWebView.alpha = 0;
        view.addSubview(myWebView);
        
        // Show the loading indicator
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray);
        activityIndicator.center = view.center;
        activityIndicator.startAnimating();
        
        // TODO: set activity indicator style from deleagate
        
        view.addSubview(activityIndicator);
    }

    func  handleRefresh(refresh: UIRefreshControl){
        currentlyRefreshing = true;
        // TODO: move loading webview URL into private method
        var url = NSURL(string: pageURL);
        var request = NSURLRequest(URL: url!);
        myWebView.loadRequest(request);
        // TODO: we could probably hold off on ending the refresh until after the webview has loaded?
        refresh.endRefreshing();
    }

    
}