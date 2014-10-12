---
layout: page
title:  "Tutorial: creating a login screen"
---
Out of the box, [Stacker](http://www.lokimeyburg.com/Stacker/) comes with a pretty good example app that can serve as a basis for your own iPhone apps. But what about getting users to log in to your app?

<div style="text-align: center; padding: 20px 0px;">
  <img src='{{ site.baseurl }}/assets/blog/stacker-authentication.gif' style='width: 50%;' />
</div>

I'm going to show you a very simple technique I like to use to show a "welcome screen" that asks a user to log in (or sign up). Even though the server code is written in Rails, the technique is simple enough that it can be applied to most other frameworks without a lot of effort. We'll be building off of the example app, called GameRoom, so be sure to try to get the demo working by following the [getting started documentation.](http://www.lokimeyburg.com/Stacker/docs/getting-started/)

<!--more-->

> You can checkout the complete example below: <br/>
> Rails app: [Download](https://github.com/lokimeyburg/GameRoom/tree/example/authentication) <br/>
> iOS app: [Download](https://github.com/lokimeyburg/Stacker/tree/example/authentication)

There are many ways to authenticate a user in an iOS app but since Stacker uses WebViews, signing in to your app in one WebView means you'll be signed in on your other pages because your session and cookies are shared between pages in your app. This makes our lives a lot easier.

## The cookie technique

The first things we need to do is decide how we're going to tell our iOS app that a user has signed in from the web app. We need to know this in order to show or hide the "sign in" page. The way we're going to do this is by setting a cookie called "signed_in" (and delete it when you log out).

Apple gives us a nice way to monitor changes to our iOS app's cookies using the `NSNotificationCenter`. This means that all our server has to do is set a cookie called `signed_in` after we've successfully signed in and we'll know to hide the "sign in" screen. And visa versa: we'll know when the cookie gets deleted so we'll present the "sign in" page again.

We're going to break this tutorial up into two sections: first the server (Rails) side, followed by the iOS app. I'll try to explain what I'm doing on the server side in a manner that can be applied to any framework besides Rails.

<br>

![authentication-illustration]({{ site.baseurl }}/assets/blog/stacker-authentication-illustration.png)

<br>

## Setting up the server side

Download [GameRoom](https://github.com/lokimeyburg/GameRoom), the example Rails app that is designed to showcase Stacker. Make sure you've tried to run it at least once by following the [Getting Started](http://www.lokimeyburg.com/Stacker/docs/getting-started/) documentation.

### Setup

We're going to use [Devise](https://github.com/plataformatec/devise) as our authentication solution because it's easy to set up.

In your `Gemfile` add the line

```
gem devise
```

Now install the library

```
bundle install
rails generate devise:install
rails generate devise User
rails generate devise:views
rake db:migrate
```

Great! What we've done is installed the library, created a `User` model, generated all the neccessary views and updated our databse by adding the `users` table.

Try running the app with the `rails server` command in your terminal and visiting `http://localhost:3000/users/sign_up` and see if you can create your first user.

In `app/controllers/application_controller.rb` you should add a `before_filter` to ensure the user is always authenticated - if they're not they will be redirected to the sign in screen.

```
class ApplicationController < ActionController::Base
	before_filter :authenticate_user!
end
```

### Setting and deleting your cookie


Remember: the key thing we want to do is set a `signed_in` cookie right after we've signed in and delete it when we log off. This way our iOS app can easily tell whether to display or hide the "sign in" screen.

In Rails we will do this using middleware callbacks, however if you're using another framework you may choose to do it differently. What's important is that the cookie is being set and deleted appropriately.


In `config/initializers/devise.rb` add the following to configure Devise:

```
Devise.setup do |config|

  ... other code ...

  Warden::Manager.after_set_user do |user,auth,opts|
    auth.cookies[:signed_in] = 1
  end

  Warden::Manager.before_logout do |user,auth,opts|
    auth.cookies.delete :signed_in
  end

 end
```

<br>

![ Cookies being set]({{ site.baseurl }}/assets/blog/stacker-authentication-cookie.png)

<br>

Awesome! Now we've got an app that sets a cookie that our iOS app can read to detect if we're logged in.


### Adding a sign out link

At this point, it's a good idea to add a "sign out" link on every page just to help us log out while we're developing. We can remove it after we're finished by placing it in on a different page where it might be more appropriate to have the link.

In `app/views/layouts/application.html.erb` right after the `<body>` add:

```
<%= link_to "Sign out", destroy_user_session_path, :method => :delete if current_user.present? %>
```

### Using database sessions

Since we're relying heavily on sessions for authentication I've found using cookies to store your session information to be unreliable. Also, storing sensitive information in a cookie is generally a bad idea for several reasons, lack of encryption (or weak encryption) being only one of them. Instead, let's use the database to store session information.

```
gem 'activerecord-session_store', github: 'rails/activerecord-session_store'
rails generate active_record:session_migration
rake db:migrate
```

in `config/initializers/session-store.rb`

```
Rails.application.config.session_store :active_record_store
```

### Testing it out

Spin up the Rails server with the `rails server` command in your terminal. Visit `http://localhost:3000/users/sign_up` in Chrome
and try to create your first user. Open the inspector and visit the "resources" tab and see if you can see the `signed_in` cookie being created and destroyed properly.

Great! What we've built is a simple authentication system that sets a cookie to indicate when we're logged in. Next we're going to build the iOS side and use that cookie to display or hide the sign in screen.

## iOS app side

We're going to be building off of the GameRoom app that comes with Stacker. [Download Stacker](http://www.lokimeyburg.com/Stacker/docs/getting-started/) and open the `GameRoom` iOS workspace in Xcode (it's in the `Examples` folder).

```
$ git clone https://github.com/lokimeyburg/Stacker.git
$ cd Stacker/Example
$ open GameRoom.xcworkspace
```

### Creating our welcome controller

We want the sign in page to be in a new `StackerController` which we will call our `welcomeController`

In `AppDelegate.m`, first add our `welcomeController` variable

```
@implementation AppDelegate

NSString *welcomeController;
NSString *DOMAIN_URL;
```

Now let's create our controller:

In `AppDelegate.m` in the `didFinishLaunchingWithOptions` method add:

```
welcomeController = [[LMStackerController alloc] initWithURL: @"http://localhost:3000/users/sign_in?x_page_title=Log+In"];
```

### Listening for cookie notifications

Apple lets us listen to changes made to our cookies using the Notification Center. The (very long) event name is `NSHTTPCookieManagerCookiesChangedNotification`. What we're going to do is run a method called `checkLogInStatus` everytime a cookie gets created or destroyed.

In `AppDelegate.m` just below our `welcomeController` create the observer:

```
[[NSNotificationCenter defaultCenter]
  addObserver:self
  selector:@selector(checkLogInStatus)
  name:NSHTTPCookieManagerCookiesChangedNotification
  object:nil];
```

Great! Now let's write the `checkLogInStatus` method. What we're going to do is iterate through our cookies and check for the `signed_in` cookie. This will tell us if the user has signed in. Also, we'll check if our `welcomeController` is visible so that we now when to show or hide it.

```
-(void) checkLogInStatus
{
    BOOL welcomeModalVisible = welcomeController.isViewLoaded && welcomeController.view.window;
    BOOL isOnline = NO;

    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies) {
        if([cookie.name isEqualToString:@"signed_in"] && [cookie.value isEqualToString:@"1"]){
            isOnline = YES;
        }
    }

    if (isOnline){
        // You are online
        if(welcomeModalVisible) {
            [self closeWelcomeModal];
        }
    } else {
        // You are offline
        if(!welcomeModalVisible) {
            [self showWelcomeModal];
        }
    }
}

-(void) closeWelcomeModal
{
    [homeNavController clearStack];
    [homeNavController refreshPage];
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) showWelcomeModal
{
	[welcomeController clearStack];
    [welcomeController refreshPage];
    [self.window.rootViewController presentViewController:welcomeController animated:YES completion:NULL];
}
```

Now run the app in your simulator to try it out. Your app should load and then the "Log In" screen should slide up. Log in and it should slide down and away. If everything is working then the rest is just polish!

Congratulations - you've built a super simple sign in page for your hybrid iOS app. You can checkout the example - which includes styling and a sign up page by visiting the `example/authentication` branch for both the [Rails app](https://github.com/lokimeyburg/GameRoom/tree/example/authentication) and the [iOS app](https://github.com/lokimeyburg/Stacker/tree/example/authentication) on Github.

> [View the iOS Code](https://github.com/lokimeyburg/Stacker/blob/example/authentication/Example/GameRoom/AppDelegate.m)

## More Details

1. Persisting cookies
2. Adding another cookie check
3. Styling

### Persistent cookies

You may notice that you have to log in again after killing the app. This is because we're not remembering the user between sessions. To fix this we need to tell Devise to always remember a user.

In `app/models/user.rb` add:

```
def remember_me
  true
end
```

and then to remember the user for a very long time we need to edit `config/initializers/devise.rb`

```
# config.remember_for = 2.weeks
config.remember_for = 1.year
```

### Adding another cookie check

We can add an extra check on every request to delete the `signed_in` cookie if the user is no longer signed in to the app. This ensures we're always cleaning up our `signed in` cookie if it's no longer valid.

In `app/controllers/application_controller.rb`

```
before_filter :authenticate_user!
before_filter :delete_signed_in_token_if_logged_out

private

def delete_signed_in_token_if_logged_out
  cookies.delete :signed_in unless current_user.present?
end
```

### Styling

Here are the links to each screen and the styles associated with them:

- [Log in page](https://github.com/lokimeyburg/GameRoom/blob/example/authentication/app/views/devise/sessions/new.html.erb)
- [Sign up page](https://github.com/lokimeyburg/GameRoom/blob/example/authentication/app/views/devise/registrations/new.html.erb)
- [Sign out page](https://github.com/lokimeyburg/GameRoom/blob/example/authentication/app/views/design/settings.html.erb)



