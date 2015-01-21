# Simple Remote Notification for AppKit

For those who want to send message to your users and do not want to make it through Apple Remote Notification. 

Framework uses remote JSON file with message, action URL, time when message should appear and few other options. Library check with time interval you choose, if it found new message there, it will schedule it through local notification system.

## How to use SRNotification

1\. Add framework to your project: File -> Add Files -> SRNotification project file

2\. In your AppDelegate add this

```objective-c
@import SRNotification;
```
	
3\. Add instance variable to hold SRNotification instance:

```objective-c
@property (strong) SRNotifications *notifications;
```
	
4\. Later in applicationDidFinishLaunching: (NSNotification *) aNotification:

```objective-c
self.notifications = [[SRNotifications alloc] init];
[self.notifications trackURL:Remote-message-URL  updateInterval:Update-interval-in-seconds startupNotification:aNotification];
```
	
For example, for update every hour:

```objective-c
self.notifications = [[SRNotifications alloc] init];
[self.notifications trackURL:[NSURL URLWithString:@"http://mysite.com/remote_message.json"]  updateInterval:60*60 startupNotification:aNotification];
```

You should pass aNotification object to the framework since if you app is offline, after user click notification, app will be started and message action should be made.

5\. Enable alert notifications 

If you want do not want your notifications dissapear after several seconds, add key `NSUserNotificationAlertStyle` and set it to `alert` into your info.plist.

## Format of JSON file

Here is the sample JSON file:

```json
{
    "id" : "15",
    "title" : "Thank you for using my app!",
    "message" : "You can visit our site for more information.",
    "url" : "http://myappsite.com",
    "date" : "2015-01-20 18:23",
    "button" : "Visit",
    "anyway" : true,
    "active" : true
}
```

Parameters:

**id** - identifier of the message. Used to distinguish one message from another, when some message was shown, ID is saved and next time this message will not be shown

**title** - Title of the message.

**message** - Message text.

**url** - Where user will be redirected if he press the button.

**date** - Date when message should be shown converted to GMT.

**button** - Text on button with action.

**anyway** - Where message should be shown even if the date is in the past

**active** - If message is inactive, it will not be shown

## Requirements

SRNotification requires AppKit >= 10.9, but could be integrated in any project since 10.6 (but it won't work there)
