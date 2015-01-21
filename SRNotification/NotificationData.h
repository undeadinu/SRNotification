//
//  NotificationData.h
//  SimpleRemoteNotifications
//
//  Created by Дмитрий Николаев on 20.01.15.
//  Copyright (c) 2015 Dmitry Nikolaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationData : NSObject

@property (strong) NSString *identifier;

@property (assign) BOOL active;
@property (strong) NSString *title;
@property (strong) NSString *message;
@property (strong) NSURL *url;
@property (strong) NSDate *date;
@property (strong) NSString *button;
@property (assign) BOOL showAnyway;

- (NSDictionary *) dictionary;

+ (NotificationData *) notificationDataFromDictionary: (NSDictionary *) dict;

@end
