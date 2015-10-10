//
//  SKYNetworkHandler.m
//  Good News
//
//  Created by Alan Scarpa on 10/8/15.
//  Copyright © 2015 Skytop Designs. All rights reserved.
//

#import "SKYNetworkHandler.h"
#import "SKYArticle.h"
#import "SKYArticleTransformer.h"

@implementation SKYNetworkHandler

+ (void)getNewestArticlesForArticleList:(NSMutableArray *)articles
                             FromSource:(NSString *)urlString
                  withCompletionHandler:(void (^)(NSMutableArray *articles, NSError *error))completionHandler {

    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:URL completionHandler:
                              ^(NSData *data, NSURLResponse *response, NSError *error) {
                                  if (!error){
                                      [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                          completionHandler([SKYArticleTransformer updateArticles:articles withArticlesFromData:data andResponse:response], nil);
                                      }];
                                  } else {
                                      [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                          completionHandler(nil, error);
                                      }];
                                  }
                              }];
    [task resume];
    
}

+ (NSMutableArray *)getNextPageArticlesForArticleList:(NSMutableArray *)articles
                                           FromSource:(NSString *)urlString {
    return nil;
}

@end
