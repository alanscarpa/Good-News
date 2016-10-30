//
//  SKYArticleTransformer.h
//  Good News
//
//  Created by Alan Scarpa on 10/8/15.
//  Copyright © 2015 Skytop Designs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKYArticleTransformer : NSObject

+ (NSMutableArray *)updateArticles:(NSMutableArray *)articles
              withArticlesFromData:(NSData *)data
                       andResponse:(NSURLResponse *)response;
+ (NSString *)nextPageArticlesURLStringFromData:(NSData *)data
                                            andResponse:(NSURLResponse *)response;

@end
