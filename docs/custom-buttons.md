---
layout: page
title: Custom Navigation Buttons
---

Sometimes you want to show a button in the navigation bar of your app. In order to do this with Stacker you first need to create your native button, register it with your StackerController, and then finally call it from a URL in your web app.

Let's imagine you're creating a button to post a comment:

## 1. Create the button

```
UIBarButtonItem *postCommentButton = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStyleBordered target:self action:@selector(postComment)];
```

What this will do is create a button named "postCommentButton", with the text "Post". The target is "self" which means that it will call a method named "postComment" in the file that this line is found. If you want to call a method on another object use that object as the target instead.

## 2. Register the button with Stacker

A StackerController has `buttonHandlers`: a list of button names and the button they correspond with. If the button is called from a URL, Stacker will look up the button and the `buttonHandler` dictionary and display the one with the corresponding name.

```
NSDictionary *buttonHandlers = @{ @"post_comment_button" : postCommentButton,
                                  @"edit_comment_button" : editCommentButton
                                  };

myStackerController.buttonHandlers = buttonHandlers;
```

This registers two buttons with Stacker. The one we just created, `postCommentButton`, will be registered under the name "post_comment_button".

## 3. Reference the button in the URL

Now you can make the `postCommentButton` appear by calling it from a url like so:

```
/comment/new?x_page_title=Comment&x_right_button=post_comment_button
```

You can also make it appear on the left hand side with `x_left_button`, but this will only work on the first page.
