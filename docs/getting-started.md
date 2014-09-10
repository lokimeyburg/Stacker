---
layout: page
title: Getting Started
---

Stacker is an iOS view-controller to kickstart development of hybrid native/web iOS apps. Stacker was built to keep your navigation native while the rest of your app is driven by webviews using [Stacker's special URLs.]({{ site.baseurl }}/docs/url-structure)

Inspired by this post by DHH: [Hybrid sweet spot: Native navigation, web content](http://signalvnoise.com/posts/3743-hybrid-sweet-spot-native-navigation-web-content)

Built for: iPhones running iOS 7 & 8 (iPad support coming soon)

## Running the demo

The demo application is a very simple Rails app called [GameRoom](https://github.com/lokimeyburg/GameRoom). It's designed to showcase Stacker's features.

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
$ cd Stacker/Example
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

**If you're not using CocoaPods** (you really should)

[Download Stacker from Github](https://github.com/lokimeyburg/Stacker), and then copy everything in the `Lib` folder into your XCode project. Finally copy and paste everything form the `assets` folder into your `Supporting Files` folder.

## Next steps:

* [Learn the special Stacker URLs]({{ site.baseurl }}/docs/url-structure)
* [Customize the look of Stacker]({{ site.baseurl }}/docs/theming)
* [Learn how to use the Javascript bridge]({{ site.baseurl }}/docs/javascript-bridge)

## Coming soon:

* iPad support
* More than one right-hand navigation buttons
* More robust ObjC API to interface with Stacker
