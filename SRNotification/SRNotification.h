//
//  SRNotification.h
//  SRNotification
//
//  Created by Дмитрий Николаев on 21.01.15.
//  Copyright (c) 2015 Dmitry Nikolaev. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NotificationData.h"

//! Project version number for SRNotification.
FOUNDATION_EXPORT double SRNotificationVersionNumber;

//! Project version string for SRNotification.
FOUNDATION_EXPORT const unsigned char SRNotificationVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <SRNotification/PublicHeader.h>

@interface SRNotification : NSObject

- (void) trackURL: (NSURL *) url updateInterval: (NSTimeInterval) updateInterval startupNotification: (NSNotification *) notification;
- (void) scheduleNotification: (NotificationData *) data;

@end

