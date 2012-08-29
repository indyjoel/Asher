//
//  ASFeed.m
//  Asher
//
//  Created by Alan Zeino on 29/08/12.
//  Copyright (c) 2012 Alan Zeino. All rights reserved.
//

#import "ASFeed.h"

@implementation ASFeed

#pragma mark - Private

- (NSArray *)_sanitisedFeedFromArray:(NSArray *)feedArray
{
    NSMutableArray *_sanitisedArray = [[NSMutableArray alloc] initWithCapacity:feedArray.count];
    for (NSDictionary *_story in feedArray)
    {
        NSString *_desc = [_story objectForKey:@"description"];
        NSString *_imageLoc = [_story objectForKey:@"imageHref"];
        NSString *_title = [_story objectForKey:@"title"];
        
        // never show an end–user improperly formatted data
        // in this case, the json has 'null' values
        // and we all know the json standard considers null values undefined
        // and I know very well that NSJSON* uses NSNull to keep your collection objects happy
        // so I guess I'll just throw away any 'story' with a null value in the title
        if ([_title isKindOfClass:[NSNull class]])
            continue;
        
        [_sanitisedArray addObject:[[[Story alloc] initWithDescription:_desc image:_imageLoc title:_title] autorelease]];
    }
    
    return [_sanitisedArray autorelease];
}

- (ASFeed *)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.feedTitle = [dictionary objectForKey:@"title"];
        self.feedStories = [self _sanitisedFeedFromArray:[dictionary objectForKey:@"rows"]];
    }
    return self;
}

- (void)dealloc
{
    [_feedStories release];
    [_feedTitle release];
    
    [super dealloc];
}

@end

@implementation Story

- (Story *)initWithDescription:(NSString *)description image:(NSString *)image title:(NSString *)title
{
    self = [super init];
    if (self)
    {
        self.description = ([description isKindOfClass:[NSNull class]]) ? nil : description;
        self.imageURL = ([image isKindOfClass:[NSNull class]]) ? nil : image;
        self.title = ([title isKindOfClass:[NSNull class]]) ? nil: title;
    }
    return self;
}

- (void)dealloc
{
    [_description release];
    [_imageURL release];
    [_title release];
    
    [super dealloc];
}

@end
