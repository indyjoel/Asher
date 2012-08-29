//
//  ASNetwork.h
//  Asher
//
//  Created by Alan Zeino on 29/08/12.
//  Copyright (c) 2012 Alan Zeino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASFeed.h"

@class ASNetwork;

@protocol ASNetworkDelegate <NSObject>

@required
- (void)beganRequestWithNetwork:(ASNetwork *)network;
- (void)network:(ASNetwork *)network didEndRequestWithFeed:(ASFeed *)feed;

@end

@interface ASNetwork : NSObject

@property (assign, nonatomic) id <ASNetworkDelegate> delegate;

- (void)loadJSONFromURL:(NSURL *)url;

+ (UIImage *)cachedImageForURL:(NSURL *)url;

@end
