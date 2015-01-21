//
//  SRNotification.m
//  SimpleRemoteNotifications
//
//  Created by Дмитрий Николаев on 20.01.15.
//  Copyright (c) 2015 Dmitry Nikolaev. All rights reserved.
//

#import "SRNotification.h"
#import "AsyncDataLoader.h"
#import "NotificationData.h"

NSString * const SRNotificationsIDKey = @"srn_id";
NSString * const SRNotificationsURLKey = @"srn_url";

@interface SRNotification () <NSUserNotificationCenterDelegate>

@property (strong) NSURL *URL;
@property (assign) NSTimeInterval updateInterval;
@property (strong) NSTimer *timer;
@property (strong) AsyncDataLoader *dataLoader;

@end

@implementation SRNotification

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.dataLoader = [[AsyncDataLoader alloc] init];
        [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    }
    return self;
}

- (void) trackURL: (NSURL *) url updateInterval: (NSTimeInterval) updateInterval startupNotification: (NSNotification *) notification {
    
    if (NSAppKitVersionNumber < NSAppKitVersionNumber10_9) {
        return;
    }
    
    NSDictionary *notificationDict = [notification.userInfo objectForKey:NSApplicationLaunchUserNotificationKey];
    if (notificationDict) {
        [self notificationAction];
    }
    
    self.URL = url;
    self.updateInterval = updateInterval;
    
    [self checkForUpdates];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.updateInterval target:self selector:@selector(timerDing:) userInfo:nil repeats:YES];
}

- (void) dealloc {
    [self.timer invalidate];
}

- (void) timerDing: (id) sender {
    if (!self.dataLoader.loading) {
        [self checkForUpdates];
    }
}

- (void) checkForUpdates {
    [self.dataLoader dataFromURL:self.URL block:^(NSData *data, NSError *error) {
        if (data) {
            
            @try {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if (dict) {
                    NotificationData *data = [NotificationData notificationDataFromDictionary:dict];
                    // NSLog(@"data: %@", [data dictionary]);
                    
                    if (![data.title length] || ![data.message length]) {
                        // NSLog(@"No title or message. Abort");
                        return;
                    }
                    
                    // NSLog(@"Receive data");
                    
                    if (![data.identifier isEqual:[self savedNotificationID]] && data.active) {
                        // NSLog(@"Schedule notification '%@'", data.identifier);
                        
                        [self removeAllNotifications];
                        [self saveNotificationID:data.identifier url:data.url];
                        
                        if (!data.showAnyway && [data.date compare:[NSDate date]] == NSOrderedAscending) {
                            // NSLog(@"Notification '%@' out of date. Ignored", data.identifier);
                            return;
                        }
                        
                        [self scheduleNotification:data];
                    } else {
                        // NSLog(@"Notification '%@' ignored", data.identifier);
                    }
                }
                
            } @catch (NSException * e) {
                NSLog(@"Exception: %@", e);
            }
        }
    }];
}

#pragma mark - NSUserNotificationCenterDelegate

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification
{
    return YES;
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification {
    [self notificationAction];
}

#pragma mark - Private

- (void) notificationAction {
    NSString *urlStr = [[NSUserDefaults standardUserDefaults] stringForKey:SRNotificationsURLKey];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:urlStr]];
}

- (void) removeAllNotifications {
    NSArray *notifications = [[NSUserNotificationCenter defaultUserNotificationCenter] scheduledNotifications];
    for (NSUserNotification *notification in notifications) {
        [[NSUserNotificationCenter defaultUserNotificationCenter] removeScheduledNotification:notification];
    }
}

- (void) scheduleNotification: (NotificationData *) data {
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = data.title;
    notification.informativeText = data.message;
    notification.soundName = NSUserNotificationDefaultSoundName;
    notification.hasActionButton = YES;
    notification.actionButtonTitle = data.button;
    notification.deliveryDate = data.date;
    [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:notification];
}

- (void) saveNotificationID: (NSString *) identifier url: (NSURL *) url {
    [[NSUserDefaults standardUserDefaults] setObject:identifier forKey:SRNotificationsIDKey];
    [[NSUserDefaults standardUserDefaults] setObject:[url absoluteString] forKey:SRNotificationsURLKey];
}

- (NSString *) savedNotificationID {
    return [[NSUserDefaults standardUserDefaults] stringForKey:SRNotificationsIDKey];
}

@end
