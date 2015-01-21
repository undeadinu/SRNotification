//
//  StringAsyncLoader.m
//  Numi 2
//
//  Created by Дмитрий Николаев on 20.05.14.
//  Copyright (c) 2014 Дмитрий Николаев. All rights reserved.
//

#import "AsyncDataLoader.h"

@interface AsyncDataLoader ()

@property (assign, nonatomic, readwrite) BOOL loading;

@end

@implementation AsyncDataLoader

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.loading = NO;
    }
    return self;
}

- (void) dataFromURL: (NSURL *) url block: (AsyncDataLoaderBlock) block {
    if (!self.loading) {
        self.loading = YES;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSError *error;
            NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
            dispatch_sync(dispatch_get_main_queue(), ^{
                self.loading = NO;
                block(data, error);
            });
        });
    } else {
        block(nil, nil);
    }
}


@end
