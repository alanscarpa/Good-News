//
//  SKYNetworkHandler.h
//  Good News
//
//  Created by Alan Scarpa on 10/8/15.
//  Copyright © 2015 Skytop Designs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SKYNetworkHandler : NSObject

+ (void)getNewestArticlesForArticleList:(NSMutableArray *)articles
                             FromSource:(NSString *)urlString
                  withCompletionHandler:(void (^)(NSMutableArray *articles, NSError *error))completionHandler ;
+ (NSMutableArray *)getNextPageArticlesForArticleList:(NSMutableArray *)articles
                                           FromSource:(NSString *)urlString;

@end
