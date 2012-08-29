//
//  ASStoryCell.m
//  Asher
//
//  Created by Alan Zeino on 29/08/12.
//  Copyright (c) 2012 Alan Zeino. All rights reserved.
//

#import "ASStoryCell.h"

@implementation ASStoryCell

- (UILabel *)titleLabel
{
    if (_titleLabel)
        return _titleLabel;
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kTitleXOrigin, kTitleYOrigin, kMaximumTitleWidthSize, kMinimumTitleHeightSize)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.numberOfLines = 3;
    _titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    _titleLabel.font = [UIFont fontWithName:@"Palatino-Bold" size:kTitleTextFontSize];
    _titleLabel.textColor = [UIColor colorWithRed:0.18f green:0.33f blue:0.54f alpha:1.00f];;
    _titleLabel.highlightedTextColor = [UIColor whiteColor];
    
    [self addSubview:_titleLabel];
    
    return _titleLabel;
}

- (UILabel *)descriptionLabel
{
    if (_descriptionLabel)
        return _descriptionLabel;
    
    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDescriptionXOrigin, kPaddingSize + kMinimumTitleHeightSize, kMaximumDescriptionWidthSize, kMinimumDescriptionHeightSize)];
    _descriptionLabel.numberOfLines = 15;
    _descriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
    _descriptionLabel.font = [UIFont systemFontOfSize:kSummaryTextFontSize];
    _descriptionLabel.textColor = [UIColor colorWithRed:0.35f green:0.35f blue:0.35f alpha:1.00f];
    _descriptionLabel.highlightedTextColor = [UIColor whiteColor];
    
    [self addSubview:_descriptionLabel];
    
    return _descriptionLabel;
}

- (UIImageView *)storyImageView
{
    if (_storyImageView)
        return _storyImageView;
    
    _storyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageXOrigin, kImageYOrigin, kMaximumImageWidthSize, kMaximumImageHeightSize)];
    _storyImageView.backgroundColor = [UIColor lightGrayColor];
    
    [self addSubview:_storyImageView];
    
    return _storyImageView;
}

- (void)dealloc
{
    [_titleLabel release];
    [_descriptionLabel release];
    [_storyImageView release];
    
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.hidden = YES;
    self.detailTextLabel.hidden = YES;
    
    CGRect _titleRect = self.titleLabel.frame;
    _titleRect.size.height = ceilf([self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(kMaximumTitleWidthSize, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);
    
    self.titleLabel.frame = _titleRect;
    
    CGRect _descRect = self.descriptionLabel.frame;
    _descRect.origin.y = _titleRect.origin.y + _titleRect.size.height;
    _descRect.size.height = ceilf([self.descriptionLabel.text sizeWithFont:self.descriptionLabel.font constrainedToSize:CGSizeMake(kMaximumDescriptionWidthSize, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);
    
    self.descriptionLabel.frame = _descRect;
    
    CGRect _imgRect = self.storyImageView.frame;
    _imgRect.origin.y = _descRect.origin.y;
    
    self.storyImageView.frame = _imgRect;
}

#pragma mark - Public

- (void)cleanForReuse
{
    [self.storyImageView removeFromSuperview];
    self.storyImageView = nil;
}

@end
