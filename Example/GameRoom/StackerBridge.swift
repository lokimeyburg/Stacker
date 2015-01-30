//
//  StackerBridge.swift
//  GameRoom
//
//  Created by Loki Meyburg on 2015-01-27.
//  Copyright (c) 2015 Loki Meyburg. All rights reserved.
//

import Foundation
import UIKit

typealias WVJBResponseCallback = ( data : String) -> ()
typealias WVJBHandler = ( data : String, responseCallback: WVJBResponseCallback) -> ()

class StackerBridge : NSObject, UIWebViewDelegate {
    
    private var _uniqueId = 0;
    private var _numRequestsLoading = 0;
    private var _webView:           UIWebView!;
    private var _webViewDelegate:   UIWebViewDelegate!;
    private var _messageHandler:    WVJBHandler!;
    private var _messageHandlers    = [String:WVJBHandler]();
    private var _responseCallbacks  = [String:WVJBResponseCallback]();
    private var _startupMessageQueue = [WVJBHandler]();
    
    private let _customProtocolScheme = "stackerscheme";
    private let _queueHasMessage = "__STACKER_QUEUE_MESSAGE__"
    
    
    override init (){ }
    
    convenience init(webView: UIWebView, webViewDelegate: UIWebViewDelegate, messageHandler: WVJBHandler){
        self.init();
        _webView = webView;
        _webViewDelegate = webViewDelegate;
        _messageHandler = messageHandler;
        _webView.delegate = self;
    }
//    
//    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
//        
//        
//        if (webView != _webView) { return true; }
//        
//        var url = request.URL;
//        if(url.scheme == _customProtocolScheme) {
//            if(url.host == _queueHasMessage) {
//                    // flushMessageQueue();
//            } else {
//                println("StackerBridge: WARNING: Received unknown WebViewJavascriptBridge command " + _customProtocolScheme + "//" + url.path!);
//            }
//            return false;
//        } else {
//            return _webViewDelegate.webView!(webView, shouldStartLoadWithRequest: request, navigationType: navigationType);
//        }
//    }
//
//    func webViewDidFinishLoad(webView: UIWebView) {
//        if(webView != _webView) { return ; }
//        
//        _numRequestsLoading--;
//        
//        if(_numRequestsLoading == 0 && (webView.stringByEvaluatingJavaScriptFromString("typeof StackerBridge == 'object'") == "true")) {
//            var bundle = NSBundle.mainBundle();
//            var filePath = bundle.pathForResource("StackerBridge.js", ofType: "txt");
//            var js = String(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding, error: nil);
//            webView.stringByEvaluatingJavaScriptFromString(js!);
//        }
//        
//        // TODO: dispatch message queue
//        
//        _webViewDelegate.webViewDidFinishLoad?(webView);
//    }
//    
//    
    func webViewDidStartLoad(webView: UIWebView) {
        println("1 -----------");
        _numRequestsLoading++;
        _webViewDelegate.webViewDidStartLoad?(webView);
    }
    
}