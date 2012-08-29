//
//  ASStoryCell.h
//  Asher
//
//  Created by Alan Zeino on 29/08/12.
//  Copyright (c) 2012 Alan Zeino. All rights reserved.
//

#import <UIKit/UIKit.h>

// 10 points of padding works well with a scrollView indicator
#define kPaddingSize 10.f

#define kMinimumTitleHeightSize 18.f
#define kMaximumTitleWidthSize 320.f - (kPaddingSize * 2)

#define kTitleXOrigin kPaddingSize
#define kTitleYOrigin kPaddingSize

#define kMaximumImageHeightSize 60.f
#define kMaximumImageWidthSize 60.f

#define kImageXOrigin 320.f - kPaddingSize - kMaximumImageWidthSize
#define kImageYOrigin (kPaddingSize * 2) + kMinimumTitleHeightSize

#define kMinimumDescriptionHeightSize 60.f
#define kMaximumDescriptionWidthSize kMaximumTitleWidthSize - kMaximumImageWidthSize - (kPaddingSize * 3)

#define kDescriptionXOrigin kPaddingSize

// let's use padding for all insets as well as the space between title and description
#define kMinimumCellHeightSize kMinimumTitleHeightSize + kMinimumDescriptionHeightSize + (kPaddingSize * 3)

#define kTitleTextFontSize 16.f
#define kSummaryTextFontSize 13.f

@interface ASStoryCell : UITableViewCell

@property (retain, nonatomic) UILabel *titleLabel;
@property (retain, nonatomic) UILabel *descriptionLabel;
@property (retain, nonatomic) UIImageView *storyImageView;

- (void)cleanForReuse;

@end
