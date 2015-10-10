//
//  SKYNewsFeedTableViewCell.m
//  Good News
//
//  Created by Alan Scarpa on 10/6/15.
//  Copyright © 2015 Skytop Designs. All rights reserved.
//

#import "SKYNewsFeedTableViewCell.h"

@interface SKYNewsFeedTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *articleTitleBackgroundView;

@end

@implementation SKYNewsFeedTableViewCell

- (void)awakeFromNib {
    [self setUpArticleTitleBackground];
}

- (void)setUpArticleTitleBackground {
    self.articleTitleBackgroundView.layer.cornerRadius = 8.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
