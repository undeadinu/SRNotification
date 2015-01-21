//
//  NotificationData.m
//  SimpleRemoteNotifications
//
//  Created by Дмитрий Николаев on 20.01.15.
//  Copyright (c) 2015 Dmitry Nikolaev. All rights reserved.
//

#import "NotificationData.h"

NSString * const NotificationDataIDKey = @"id";
NSString * const NotificationDataTitleKey = @"title";
NSString * const NotificationDataMessageKey = @"message";
NSString * const NotificationDataURLKey = @"url";
NSString * const NotificationDataDateKey = @"date";
NSString * const NotificationDataButtonKey = @"button";
NSString * const NotificationDataShowAnywayKey = @"anyway";
NSString * const NotificationDataActiveKey = @"active";

@implementation NotificationData

- (NSDictionary *) dictionary {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if (self.identifier) {
        dict[NotificationDataIDKey] = self.identifier;
    }
    
    if (self.title) {
        dict[NotificationDataTitleKey] = self.title;
    }
    
    if (self.message) {
        dict[NotificationDataMessageKey] = self.message;
    }

    if (self.url) {
        dict[NotificationDataURLKey] = [self.url absoluteString];
    }
    if (self.date) {
        dict[NotificationDataDateKey] = [[self dateFormatter] stringFromDate:self.date];
    }

    if (self.button) {
        dict[NotificationDataButtonKey] = self.button;
    }

    dict[NotificationDataShowAnywayKey] = [NSNumber numberWithBool:self.showAnyway];
    dict[NotificationDataActiveKey] = [NSNumber numberWithBool:self.active];

    return dict;
}

- (NSDateFormatter *) dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    
    return dateFormatter;
}

+ (NotificationData *) notificationDataFromDictionary: (NSDictionary *) dict {
    NotificationData *data = [[NotificationData alloc] init];
    
    data.identifier = dict[NotificationDataIDKey];
    
    NSNumber *activeNum = dict[NotificationDataActiveKey];
    if (activeNum) {
        data.active = [activeNum boolValue];
    }
    
    data.title = dict[NotificationDataTitleKey];
    data.message = dict[NotificationDataMessageKey];
    if (dict[NotificationDataURLKey]) {
        data.url = [NSURL URLWithString:dict[NotificationDataURLKey]];
    }
    
    NSString *dateStr = dict[NotificationDataDateKey];
    if (dateStr) {
        data.date = [[data dateFormatter] dateFromString:dateStr];
    }
    
    data.button = dict[NotificationDataButtonKey];
    
    NSNumber *showAnywayNum = dict[NotificationDataShowAnywayKey];
    if (showAnywayNum) {
        data.showAnyway = [showAnywayNum boolValue];
    }
    
    return data;
}

@end
