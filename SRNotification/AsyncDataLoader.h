//
//  StringAsyncLoader.h
//  Numi 2
//
//  Created by Дмитрий Николаев on 20.05.14.
//  Copyright (c) 2014 Дмитрий Николаев. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AsyncDataLoaderBlock)(NSData *data, NSError *error);

@interface AsyncDataLoader : NSObject

@property (assign, nonatomic, readonly) BOOL loading;

- (void) dataFromURL: (NSURL *) url block: (AsyncDataLoaderBlock) block;

@end
