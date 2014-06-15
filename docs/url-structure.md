---
layout: page
title: Stacker URL Structure
---

Stacker lets you build what I call "URL-driven iOS apps". That is: you drive your iOS application's navigation, page headings etc all through how you declare your urls. 

An example URL that will stack a new page and set the title to 'Profile' will look like: `/profile?x_push_page=true&x_title=Profile`. 

Parameter  | Description
------------- | -------------
`x_push_page` | stacks the page on top of the current page
`x_replace_page` | replaces the current page with the url
`x_pop_page` | goes back to the previous page
`x_pop_page_and_refresh` | goes back to the previous page and refreshes it 
`x_pop_page_and_replace` | goes back to the previous page but replaces it with the url
`x_clear_stack` | goes back to the first page
`x_clear_stack_and_refresh` | goes back to the first page and refreshes it
`x_clear_stack_and_replace` | goes back to the first page but replaces it with the url
`x_external_page` | opens the page in a separate modal view

##### These parameters are for custom titles, buttons and actions:

Parameter  | Description
------------- | -------------
`x_page_title=My+Profile`  | sets the page's title to "My Profile"
`x_right_button=myButton` | shows a custom right-hand navigation button (see: [custom button handlers](#))
`x_left_button=myButton` | shows a custom left-hand navigation button (see: [custom button handlers](#))
`x_action=myAction` | will invoke your own custom method (see: [custom url actions](#))


## Stacking a new page

If you want to load a new webpage and have it 'stack' (pushed) on top of your current page then you need to specify `x_push_page=true` and set the page title you wish to have displayed in the native iOS header like so `x_page_title=MyPageTitle`. If a page title has multiple words, then use `+` to seperate the words: `x_page_title=My+Profile`

```
myapp.com/profile/2?x_new_page=true&
                    x_page_title=My+Newsfeed
```

## Open an external website

Navigating to a URL that's external to your application should most likely be opened up in a separate browser. To open a link in a browser view just add the `x_external_page=true` parameter to the URL.

```
news.ca/some/article?x_external_page=true
```

Stacker will automatically strips out the custom parameter to make sure that the intended URL structure is preserved when viewing the web page:

```
news.ca/some/article?1230-breaking-news-this-morning&?mobile=1&x_external_page=true

will open:

news.ca/some/article?1230-breaking-news-this-morning&?mobile=1
```

## Popping back one page

You can go back one page by specifying `x_pop_page=true`. 

```
/profile?x_pop_page=true
```

Sometimes you may post something to a server and want the page to go back and refresh to show the new content you created. You can redirect the page to a URL that includes `x_pop_page_and_refresh=true` and this Stacker will go back one page and refresh that page to reveal any changes. You can also replace the page with `x_pop_page_and_replace=true`.

This will go back one page, replace the page with `/newsfeed` and change the title to `News Feed` in the navigation bar:
```
/newsfeed?x_pop_page_and_replace=true&x_page_title="News+Feed"
```

## Showing a button in the navigation bar

If you've [registered a button with Stacker](#) in your iOS app then you can show that button by calling it in the URL like so:

```
/profile?x_page_title=Profile&x_right_button=myNavButton
```

This will show a button that you've registered called `myNavButton`. [Read about registering and using buttons.](https://github.com/lokimeyburg/Stacker/wiki/Custom-Navigation-Buttons)

## Triggering a custom action

You can execute Objective-C functions by calling a URL that looks like this:

```
inapp://capture?x_action=myAction
```

This will execute the action you've registered with Stacker called `myAction`. [Read about registering custom actions.](#)

Note: if you need anything more fancy you may need to look into integrating a [javascript bridge](https://github.com/marcuswestin/WebViewJavascriptBridge) into your StackerController. I've been meaning to do this myself but haven't found the time.
