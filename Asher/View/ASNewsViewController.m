//
//  ASNewsViewController.m
//  Asher
//
//  Created by Alan Zeino on 29/08/12.
//  Copyright (c) 2012 Alan Zeino. All rights reserved.
//

#import "ASNewsViewController.h"
#import "ASNetwork.h"
#import "ASFeed.h"
#import "ASStoryCell.h"

@interface ASNewsViewController () <ASNetworkDelegate>

@property (retain, nonatomic) ASNetwork *network;

@property (retain, nonatomic) ASFeed *feed;

@end

@implementation ASNewsViewController

- (ASNetwork *)network
{
    if (_network)
        return _network;
    
    _network = [[ASNetwork alloc] init];
    _network.delegate = self;
    
    return _network;
}

- (void)dealloc
{
    [_network dealloc];
    [_feed dealloc];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addObserver:self forKeyPath:@"feed" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self.network loadJSONFromURL:[NSURL URLWithString:kAsherJSONFeed]];
}

- (void)viewDidUnload
{
    [self removeObserver:self forKeyPath:@"feed" context:NULL];
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"feed"])
    {
        self.title = self.feed.feedTitle;
        [self.tableView reloadData];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Story *_story = [self.feed.feedStories objectAtIndex:indexPath.row];
    
    CGFloat _height = (kPaddingSize * 2);
    _height += ceilf([_story.title sizeWithFont:[UIFont fontWithName:@"Palatino-Bold" size:kTitleTextFontSize] constrainedToSize:CGSizeMake(kMaximumTitleWidthSize, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);
    _height += ceilf([_story.description sizeWithFont:[UIFont systemFontOfSize:kSummaryTextFontSize] constrainedToSize:CGSizeMake(kMaximumDescriptionWidthSize, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);
        
    return (_height < kMinimumCellHeightSize) ? kMinimumCellHeightSize : _height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.feed.feedStories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StoryCell";
    ASStoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[ASStoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else
    {
        // clean up for reuse because prepareForReuse is buggy in 3.2-4.2.1
        [cell cleanForReuse];
    }
    
    Story *_story = [self.feed.feedStories objectAtIndex:indexPath.row];
    cell.titleLabel.text = _story.title;
    cell.descriptionLabel.text = _story.description;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage *_imageForStory = [ASNetwork cachedImageForURL:[NSURL URLWithString:_story.imageURL]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            cell.storyImageView.image = _imageForStory;
            
        });
    });
    
    return cell;
}

#pragma mark - ASNetworkDelegate

- (void)beganRequestWithNetwork:(ASNetwork *)network
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.title = @"Loading...";
}

- (void)network:(ASNetwork *)network didEndRequestWithFeed:(ASFeed *)feed
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (network == _network)
        self.feed = feed;
}

@end
