//
//  SKYNewsFeedTableViewCell+Customization.m
//  Good News
//
//  Created by Alan Scarpa on 10/9/15.
//  Copyright © 2015 Skytop Designs. All rights reserved.
//

#import "SKYNewsFeedTableViewCell+Customization.h"
#import "SKYArticle.h"

@implementation SKYNewsFeedTableViewCell (Customization)

- (void)customizeWithArticle:(SKYArticle *)article {
    self.articleTitleLabel.text = article.title;
}

@end
