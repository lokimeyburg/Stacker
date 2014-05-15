<img src="http://f.cl.ly/items/0z2m1E2N1B2J2A0S3147/stacker.png" alt="Drawing" width='400px'/>

Stacker is an iOS view-controller to kickstart development of hybrid native/web iOS apps. Stacker was built to keep your navigation native while the rest of your app is driven by webviews using [Stacker's special URLs.](https://github.com/lokimeyburg/Stacker/wiki/Stacker-URL-Structure)

Inspired by this post by DHH: [Hybrid sweet spot: Native navigation, web content](http://signalvnoise.com/posts/3743-hybrid-sweet-spot-native-navigation-web-content)

Built for: iPhones & iOS7

## Features

- Easily build [URL-driven iOS apps](https://github.com/lokimeyburg/Stacker/wiki/Stacker-URL-Structure)
- Browse external websites in a modal view
- Theming
- Pull to refresh on all pages
- Custom navigation button handlers
- Display a page when there's no internet connection
- Custom URL handlers
- Easily jump back into native code when you need to

## Getting Started

If you get stuck or want something a little more comprehensive, checkout out the [complete set up guide and tutorial](#)
 
### 1. Install Stacker

**If you're using [CocoaPods:](http://cocoapods.org)**

In your Podile add:
```
pod 'LMStacker', :git => 'https://github.com/lokimeyburg/Stacker.git'
```
And then run
```
$ pod install
```

**If you're using something else**

Clone Stacker 

```
$ git clone https://github.com/lokimeyburg/Stacker.git
```
And import all the files from the `/lib` folder to your own XCode project

### 2. Run the demo web app

```
git clone https://github.com/lokimeyburg/stackly-app.git
cd stackly
rails s
```

### 3. Point Stacker to your web app

If you wantIn your iOS application in a file like AppDelegate.m:

```
// Import Stacker
#import "StackerController.h"

// Create a controller and point it to your web app's url
StackerController *myController = [[StackerController alloc] initWithURL:@"http://localhost:3000/my_webapp"];

// Give it a title
myController.rootTitle = @"News Feed";

```

Now compile and run your iOS app.

## Next Steps:

* Learn the special Stacker URLs
* Run the demo
* Build a complete Stacker App from scratch 

## Coming soon:

* iPad support
* Multiple navigation buttons
* PDF viewer
* Custom "request has timed out" page
