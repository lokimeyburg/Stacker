<img src="http://f.cl.ly/items/0z2m1E2N1B2J2A0S3147/stacker.png" alt="Drawing" width='400px'/>

Stacker is an iOS view-controller to kickstart development of hybrid native/web iOS apps. Stacker was built to keep your navigation native while the rest of your app is driven by webviews using [Stacker's special URLs.](http://www.lokimeyburg.com/Stacker/docs/url-structure/)

Built for: iPhones running iOS 7 & iOS 8 (iPad support coming soon)

## Features

- Build [URL-driven iOS apps](http://www.lokimeyburg.com/Stacker/docs/url-structure/)
- Send messages between Obj-C and JavaScript
- Custom navigation button handlers
- View external websites in a separate modal view
- Theming options
- Pull to refresh on all pages
- Error pages
- App version and device information sent in HTTP headers

## Getting Started & Documentation

[View the official Stacker documentation](http://www.lokimeyburg.com/Stacker/docs/getting-started/) to get started.

## Creating a StackerController

**If you're using [CocoaPods:](http://cocoapods.org)**

In your Podfile add:
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

### How to update the documentation

The [documentation site](http://www.lokimeyburg.com/Stacker/) is being created with [Github Pages](https://pages.github.com/) and so it can be found by checking out the "[gh-pages](https://github.com/lokimeyburg/Stacker/tree/gh-pages)" branch. The actual documentation is in the `/docs` folder. If you find a spelling mistake or any errors in the documentation please submit a pull request to the branch.
