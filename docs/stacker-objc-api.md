---
layout: page
title: Obj-C API 
---

Even though the StackerController can mostly be driven by using the [special url structures](#) sometimes you may need a little more control

## Go back to the root page
```
 -(void)goBackToRootView;
 -(void)goBackToRootViewAndSetURL:(NSString*)newURL;
```

## Refresh the current page
```
 -(void)refreshCurrentPage;
```
## Change the current page's URL
```
 -(void)refreshCurrentPageWithURL:(NSString*)newURL;
```

## Stack a new page
```
 -(void)stackNewPage:(NSString*)pageURL
```
