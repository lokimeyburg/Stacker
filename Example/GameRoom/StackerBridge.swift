//
//  StackerBridge.swift
//
//  Created by Loki Meyburg on 2015-01-27.
//  Copyright (c) 2015 Loki Meyburg. All rights reserved.
//

import Foundation
import UIKit

typealias WVJBResponseCallback = ( data : AnyObject) -> Void
typealias WVJBHandler = ( data : AnyObject, responseCallback: WVJBResponseCallback) -> ()
typealias WVJBMessage = [AnyObject]

class StackerBridge : NSObject, UIWebViewDelegate {
    private var _uniqueId =             0
    private var _numRequestsLoading =   0
    private var _bridgeComplete =       false
    private let _customProtocolScheme = "stackerscheme"
    private let _queueHasMessage =      "__STACKER_QUEUE_MESSAGE__"
    
    private var _webView:               UIWebView!
    private var _webViewDelegate:       UIWebViewDelegate!
    private var _messageHandler:        WVJBHandler!
    
    private var _messageHandlers =      [String:WVJBHandler]()
    private var _responseCallbacks =    [String:WVJBResponseCallback]()
    private var _startupMessageQueue =  [AnyObject]()
    
    
    init(webView: UIWebView, webViewDelegate: UIWebViewDelegate, messageHandler: WVJBHandler) {
        super.init()
        _webView = webView
        _webViewDelegate = webViewDelegate
        _messageHandler = messageHandler
        _webView.delegate = self
    }

    deinit {
        _webView.delegate = nil
    }
    
    // API
    // ---
    
    func send(data: AnyObject, responseCallback: WVJBResponseCallback?, handlerName: String? = nil) {
        
        var message = [ "data" : data ]
        
        if let responseCb = responseCallback {
            _uniqueId++
            var callbackId = String(format: "swift_cb_%d", _uniqueId)
            _responseCallbacks[callbackId] = responseCallback
            message["callbackId"] = callbackId
        }
        
        if let handler = handlerName {
            message["handlerName"] = handler
        }
        
        queueMessage(message)
    }

    func registerHandler(handlerName: String, handler: WVJBHandler){
        _messageHandlers[handlerName] = handler
    }
    
    func callHandler(handlerName: String, data: AnyObject = "", responseCallback: WVJBResponseCallback? = nil) {
        send(data, responseCallback: responseCallback, handlerName: handlerName)
    }
    
    // Internals
    // ---------
    
    func queueMessage(message: AnyObject) {
        if(_bridgeComplete){
            dispatchMessageQueue(message)
        } else {
            _startupMessageQueue.append(message)
        }
    }
    
    func dispatchMessageQueue(message: AnyObject) {
        var messageJSON = serializeMessage(message)
        messageJSON = escapedJSONString(messageJSON)
        
        var javascriptCommand = "StackerBridge._handleMessageFromSwift('" + messageJSON + "')"
        
        println("Sending JS: " + javascriptCommand)
        
        if(NSThread.currentThread().isMainThread) {
            _webView.stringByEvaluatingJavaScriptFromString(javascriptCommand)
        }
    }
    
    func flushMessageQueue() {
        var messageQueueString = _webView.stringByEvaluatingJavaScriptFromString("StackerBridge._fetchQueue()")!
        
        var messages = deserializeMessageJSON(messageQueueString)
        
        for message in messages {
            if let responseId : AnyObject = message["responseId"] {
                var responseCallback = _responseCallbacks[responseId as String]
                
                if let responseMessage : AnyObject = message["responseData"] {
                   responseCallback?(data: responseMessage)
                }
            } else {
                var responseCallback = {(data: AnyObject) -> () in /* empty callback */ }
                
                var callbackId = message["callbackId"]
                if let callId: AnyObject = callbackId? {
                    responseCallback = {(data: AnyObject) -> () in
                        var msg = ["responseId": callId, "responseData": data]
                        self.queueMessage(msg)
                    }
                }
                var handler: WVJBHandler
                if let messageHandler : AnyObject = message["handlerName"] {
                    handler = _messageHandlers[messageHandler as String]!
                } else {
                    handler = _messageHandler
                }
                handler(data: message, responseCallback)
            }
        }
    }
    
    func serializeMessage(value: AnyObject, prettyPrinted: Bool = false) -> String {
        var options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : nil
        if NSJSONSerialization.isValidJSONObject(value) {
            if let data = NSJSONSerialization.dataWithJSONObject(value, options: options, error: nil) {
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    return string
                }
            }
        }
        return ""
    }
    
    
    func deserializeMessageJSON(jsonString: String) -> [AnyObject] {
        if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
            if let array = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil)  as? [AnyObject] {
                return array
            }
        }
        return [AnyObject]()
    }
    
    
    func escapedJSONString(message: String) -> String {
        var escapedJSON = message
        escapedJSON = escapedJSON.stringByReplacingOccurrencesOfString("\\", withString: "\\\\")
        escapedJSON = escapedJSON.stringByReplacingOccurrencesOfString("\"", withString: "\\\"")
        escapedJSON = escapedJSON.stringByReplacingOccurrencesOfString("\'", withString: "\\\'")
        escapedJSON = escapedJSON.stringByReplacingOccurrencesOfString("\n", withString: "\\n")
        escapedJSON = escapedJSON.stringByReplacingOccurrencesOfString("\r", withString: "\\r")
        return escapedJSON
    }

    // UIWebView Delegate Methods
    // --------------------------
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if (webView != _webView) { return true }
        
        var url = request.URL
        if(url.scheme == _customProtocolScheme) {
            if(url.host == _queueHasMessage) {
                flushMessageQueue()
            } else {
                println("StackerBridge: WARNING: Received unknown StackerBridge command " + _customProtocolScheme + "//" + url.path!)
            }
            return false
        } else {
            return _webViewDelegate.webView!(webView, shouldStartLoadWithRequest: request, navigationType: navigationType)
        }
    }


    func webViewDidFinishLoad(webView: UIWebView) {
        if(webView != _webView) { return  }
        
        _numRequestsLoading--
        
        if(_numRequestsLoading == 0 && (webView.stringByEvaluatingJavaScriptFromString("typeof StackerBridge == 'object'") != "true")) {
            var bundle = NSBundle.mainBundle()
            var filePath = bundle.pathForResource("StackerBridge.js", ofType: "txt")
            var js = String(contentsOfFile: filePath!, encoding: NSUTF8StringEncoding, error: nil)
            webView.stringByEvaluatingJavaScriptFromString(js!)
        }
            
        for queuedMessage in _startupMessageQueue {
            dispatchMessageQueue(queuedMessage)
        }

        _bridgeComplete = true
        
        _webViewDelegate.webViewDidFinishLoad?(webView)
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        if(webView != _webView) { return  }
        _numRequestsLoading--
        _webViewDelegate.webView!(webView, didFailLoadWithError: error)
    }

    func webViewDidStartLoad(webView: UIWebView) {
        _numRequestsLoading++
        _webViewDelegate.webViewDidStartLoad?(webView)
    }
    
}