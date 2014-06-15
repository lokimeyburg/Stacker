---
layout: page
title: Custom URL Actions 
---
An alternative to using the [Javascript Bridge]() to call custom Objective-C code is to simple call it by registering a custom URL that when triggered will run the function.

A custom function might look like:

```
LMStackerCustomAction *openCNN = [[LMStackerCustomAction alloc] init];
[myCustomAction addTarget:self action:@selector(openSafariToCNN) ];
    
NSDictionary *customURLHandlers = @{ @"open_cnn" : openCNN };
[myStackerController setCustomURLHandlers:customURLHandlers];
```

Now to run the `openSafariToCNN` function, I have to open the URL with `open_cnn` from my web app like so:

```
inapp://capture?x_action=open_cnn
```
