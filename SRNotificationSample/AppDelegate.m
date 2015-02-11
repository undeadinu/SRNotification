//
//  AppDelegate.m
//  SRNotificationSample
//
//  Created by Дмитрий Николаев on 11.02.15.
//  Copyright (c) 2015 Dmitry Nikolaev. All rights reserved.
//

#import "AppDelegate.h"
@import SRNotification;

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong) SRNotification *remoteNotificationCenter;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)buttonClicked:(id)sender {
    self.remoteNotificationCenter = [[SRNotification alloc] init];
    
    NotificationData *data = [[NotificationData alloc] init];
    data.identifier = @"myid";
    data.title = @"My Title";
    data.message = @"Message";
    data.url = [NSURL URLWithString:@"http://mysite.com"];
    data.date = [NSDate date];
    data.button = @"Go";
    data.showAnyway = YES;
    
    [self.remoteNotificationCenter scheduleNotification:data];
    
}

@end
