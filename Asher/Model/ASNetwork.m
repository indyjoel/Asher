//
//  ASNetwork.m
//  Asher
//
//  Created by Alan Zeino on 29/08/12.
//  Copyright (c) 2012 Alan Zeino. All rights reserved.
//

#import "ASNetwork.h"
#import "JSONKit.h"

@interface ASNetwork ()

- (void)_requestComplete:(NSData *)requestData;

@end

@implementation ASNetwork

#pragma mark - Private

+ (NSString *)_thumbsLocation
{
    NSString *_loc = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"/thumbs/"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:_loc])
        [[NSFileManager defaultManager] createDirectoryAtPath:_loc withIntermediateDirectories:NO attributes:nil error:nil];
    
    return _loc;
}

- (void)_requestBegan
{
    if ([self.delegate respondsToSelector:@selector(beganRequestWithNetwork:)])
        [self.delegate beganRequestWithNetwork:self];
}

- (void)_requestComplete:(NSData *)requestData
{
    // returned JSON is not Unicode compliant
    NSString *_jsonString = [[[NSString alloc] initWithData:requestData encoding:NSASCIIStringEncoding] autorelease];
    NSData *_utfJSONData = [_jsonString dataUsingEncoding:NSUTF8StringEncoding];

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
    NSError *_jsonError = nil;
    NSDictionary *_rootObj = [NSJSONSerialization JSONObjectWithData:_utfJSONData
                                                             options:NSJSONWritingPrettyPrinted
                                                               error:&_jsonError];
    if (_rootObj == nil)
        NSLog(@"_jsonError: %@", [_jsonError localizedDescription]);
#else
    NSDictionary *_rootObj = [_utfJSONData objectFromJSONData];
#endif
        
    if ([self.delegate respondsToSelector:@selector(network:didEndRequestWithFeed:)])
        [self.delegate network:self didEndRequestWithFeed:[[[ASFeed alloc] initWithDictionary:_rootObj] autorelease]];
}

#pragma mark - Public

- (void)loadJSONFromURL:(NSURL *)url
{
    [self _requestBegan];
    
    NSURLRequest *_request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:_request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *_resp, NSData *_data, NSError *_error) {
                               [self _requestComplete:_data];
                           }];
}

+ (UIImage *)cachedImageForURL:(NSURL *)url
{
    // placeholder for missing URLs
    if (url == nil)
        return [UIImage imageNamed:@"Missing.png"];
    
    NSString *_fullPath = [[ASNetwork _thumbsLocation] stringByAppendingPathComponent:url.lastPathComponent];
    
    // return cached image
    if ([[NSFileManager defaultManager] fileExistsAtPath:_fullPath])
        return [UIImage imageWithContentsOfFile:_fullPath];
    
    NSError *_error = nil;
    NSURLResponse *_resp = nil;
    
    // since cachedImageForURL: is called async, this is okay (for now)
    NSData *_data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url]
                                          returningResponse:&_resp
                                                      error:&_error];
    
    
    if (_data == nil)
        return [UIImage imageNamed:@"Missing.png"];
    else if (((NSHTTPURLResponse *)_resp).statusCode == 200)
        [_data writeToFile:_fullPath atomically:YES];
    
    return [UIImage imageWithContentsOfFile:_fullPath];
    
}

@end
