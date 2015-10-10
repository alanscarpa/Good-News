//
//  SKYNewsFeedTableViewCell+Customization.m
//  Good News
//
//  Created by Alan Scarpa on 10/9/15.
//  Copyright © 2015 Skytop Designs. All rights reserved.
//

#import "SKYNewsFeedTableViewCell+Customization.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SKYArticle.h"

@implementation SKYNewsFeedTableViewCell (Customization)

- (void)customizeWithArticle:(SKYArticle *)article {
    self.articleTitleLabel.text = article.title;
    [self.articleImageView sd_setImageWithURL:[NSURL URLWithString:article.imageUrlString]
                             placeholderImage:nil
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                        if (error) {
                                            NSLog(@"Error loading image: %@", error);
                                            self.articleImageView.image = [UIImage imageNamed:@"corgi"];
                                        }
                                    }];
}

@end
