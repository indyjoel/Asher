//
//  ASFeed.h
//  Asher
//
//  Created by Alan Zeino on 29/08/12.
//  Copyright (c) 2012 Alan Zeino. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASFeed : NSObject

@property (retain, nonatomic) NSString *feedTitle;
@property (retain, nonatomic) NSArray *feedStories;

- (ASFeed *)initWithDictionary:(NSDictionary *)dictionary;

@end

@interface Story : NSObject

@property (retain, nonatomic) NSString *description;
@property (retain, nonatomic) NSString *imageURL;
@property (retain, nonatomic) NSString *title;

- (Story *)initWithDescription:(NSString *)description image:(NSString *)image title:(NSString *)title;

@end
