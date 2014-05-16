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

## Running the Demo

If you get stuck or want something a little more comprehensive: checkout out the [complete set up guide and tutorial](#)

### 1. Run the demo web app

The demo application is a very simple Rails app called [GameRoom](https://github.com/lokimeyburg/GameRoom). It doesn't really do anything other than showcase some of Stacker's features.

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

Now compile and run your iOS app in the simulator. That's it! You should be able to navigate around GameRoom. Look at the source code and change some of the URLs in the Rails app to see what happens.

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

## Next Steps:

* [Learn the special Stacker URLs](https://github.com/lokimeyburg/Stacker/wiki/Stacker-URL-Structure)

## Coming soon:

* iPad support
* Multiple navigation buttons
* PDF viewer
* Custom "request has timed out" page
