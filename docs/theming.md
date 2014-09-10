---
layout: page
title: Theming Stacker 
---
Stacking comes with several theming options to customize the look and feel of your application

We'll create a Stacker controller called `myStackerController` and use it in the examples below:

```
StackerController *myStackerController = [[StackerController alloc] initWithURL:@"http://localhost:3000/"];
```

## Background Color

```
[myStackerController setWebViewBackgroundColor:@"F0F1F2"];
```

## Title of the first page

```
myStackerController.rootTitle = @"News Feed";
```

## Image for a title

```
myStackerController.rootPageTitleImage = [UIImage imageNamed:@"logo.png"];
```

There should be two images in your applications directory, one retina and one non-retina. So in above example you need a `logo.png` & `logo@2x.png` image.

## Setting the status bar color

If you want a light status bar:

```
myStackerController.statusBarLight = YES;
```


## Tab Icon

Carried over from it's parent class, `UINavigationController`, you can set the tab bar image. Make sure to include both a retir

```
myStackerController.tabBarItem.image = [UIImage imageNamed:@"tab-1.png"];
```

## Header colors

This will set the background to `#47916B` and all the text to `#FFFFFF`. `RGBParser` comes with Stacker (or you can [download it from Github](https://github.com/lokimeyburg/RGBParser)).

```
RGBParser *rgbParser = [[RGBParser alloc] init];
myStackerController.navigationBar.barTintColor = [rgbParser colorWithHexString:@"47916B"];
myStackerController.navigationBar.tintColor = [rgbParser colorWithHexString:@"FFFFFF"];
[myStackerController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [rgbParser colorWithHexString:@"FFFFFF"]}];
```

## Loading and Refresh Spinner Color

```
myStackerController.refreshSpinnerColor = @"6F9FCD";
myStackerController.loadingSpinnerColor = @"1C3347";
```

## Error Pages

#### No Network Connection Page

Stacker comes with an html file called `no-network-connection.html` and will render it when your app has lost it's Internet connection. Find the file and edit it like you would a regular HTML file (remember, your app is no longer connected to the internet, so customize this HTML page with that in mind).

#### Couldn't find page

Similar to above, it's called `not-found.html` and is shown if the server couldn't be reached.
