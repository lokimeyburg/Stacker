---
layout: page
title: Getting Started 
---

Stacker is an iOS view-controller to kickstart development of hybrid native/web iOS apps. Stacker was built to keep your navigation native while the rest of your app is driven by webviews using [Stacker's special URLs.](https://github.com/lokimeyburg/Stacker/wiki/Stacker-URL-Structure)

Inspired by this post by DHH: [Hybrid sweet spot: Native navigation, web content](http://signalvnoise.com/posts/3743-hybrid-sweet-spot-native-navigation-web-content)

Built for: iPhones & iOS 7 (iPad and iOS 8 support coming soon)

## Running the demo

If you get stuck or want something a little more comprehensive: checkout out the [complete set up guide and tutorial](#). The demo application is a very simple Rails app called [GameRoom](https://github.com/lokimeyburg/GameRoom). It doesn't really do anything other than showcase some of Stacker's features.

### 1. Run the demo web app

```
git clone https://github.com/lokimeyburg/GameRoom.git
cd GameRoom
bundle install
rails s
```

Now open up a web browser and visit `http://localhost:3000`. You should see GameRoom running in your browser.
 
### 2. Run the example iOS app

Download Stacker and open the `GameRoom` iOS project which is in the `Examples` folder 

```
$ git clone https://github.com/lokimeyburg/Stacker.git
$ cd Stacker/Example/GameRoom
$ open GameRoom.xcodeproj
```

Now compile and run your iOS app for an iPhone in the simulator. That's it! You should be able to navigate around GameRoom. Look at the source code and change some of the URLs in the Rails app to see what happens.

## Creating a StackerController

**If you're using [CocoaPods:](http://cocoapods.org)**

In your Podile add:
```
pod 'LMStacker', :git => 'https://github.com/lokimeyburg/Stacker.git'
```
And then run
```
$ pod install
```

Now in your XCode project:

```
// Import Stacker
#import "LMStackerController.h"

// Create a controller and point it to your web app's url
LMStackerController *myController = [[LMStackerController alloc] initWithURL:@"http://localhost:3000?x_page_title=Home"];
```

## Next steps:

* [Learn the special Stacker URLs](https://github.com/lokimeyburg/Stacker/wiki/Stacker-URL-Structure)
* [Customize the look of Stacker](#)
* [Build an app from scratch using Stacker](#)

## Coming soon:

* iPad & iOS 8 support
* More than one right-hand navigation buttons
