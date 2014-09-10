---
layout: page
title: HTML Best Practices 
---

## Add viewport constraint

To make your web app respond nicely to the width of your iPhone set the viewport constraint in the `<head>` of your application:

```
<meta name="viewport" content="user-scalable=no, width=device-width, initial-scale=1.0, maximum-scale=1.0">
```

## Remove 300ms touch delay

Use something like [FastClick](https://github.com/ftlabs/fastclick).

## Don't use JQuery

Keep your Javascript file tiny by using something like [Speedball](https://github.com/lokimeyburg/Speedball) because it doesn't have all the cruft that goes into supporting legacy browsers.

## Lazy load images

Load images after the page has loaded and only once they are visible.

## Remove hover states from links 

When you press a link, Safari applies the hover styling which looks weird when you eventually pop back to the page. Instead remove hover styles to improve the overall design.
