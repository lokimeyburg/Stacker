---
layout: page
title: Javascript Bridge
---

Stacker comes with a Javascript bridge which lets you send messages between Objective-C and Javascript code. Stacker's bridge is based on the popular [WebViewJavascriptBridge](https://github.com/marcuswestin/WebViewJavascriptBridge) project which is also used by Facebook.

## Setting up your web app

Always wait for the WebViewJavascriptBridgeReady DOM event:

```
document.addEventListener('WebViewJavascriptBridgeReady', function(event) {
    var bridge = event.bridge
    bridge.init()

    // Start using the bridge by registering events
}, false)

```

## Calling JS from ObjC

To register a handler in Javascript called `testJavascriptHandler` and sending a response:

```
bridge.registerHandler('testJavascriptHandler', function(data, responseCallback) {
  log('ObjC called testJavascriptHandler with', data)
  var responseData = { 'Javascript Says':'Right back atcha!' }
  log('JS responding with', responseData)
  responseCallback(responseData)
})
```

To call the `testJavascriptHandler` from your StackerController:

```
[myStackerController.bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
```

Alternatively you can do something with the callback:

```
[myStackerController.bridge callHandler:@"testJavascriptHandler" data:nil responseCallback:^(id responseData) {
    NSLog(@"Responded with: %@", responseData);
}];
```

## Calling ObjC from JS

First register a handler in ObjC, let's call it `testObjcCallback`

```
[myStackerController.registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
  NSLog(@"testObjcCallback called: %@", data);
  responseCallback(@"Response from testObjcCallback");
}];
```

No call it from your JS:

```
bridge.callHandler('testObjcCallback', {'foo': 'bar'}, function(response) {
  log('JS got response', response)
})
```
