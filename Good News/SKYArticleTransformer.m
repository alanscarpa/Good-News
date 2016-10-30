//
//  SKYArticleTransformer.m
//  Good News
//
//  Created by Alan Scarpa on 10/8/15.
//  Copyright © 2015 Skytop Designs. All rights reserved.
//

#import "SKYArticleTransformer.h"
#import <HTMLReader/HTMLReader.h>
#import "SKYArticle.h"

@implementation SKYArticleTransformer

+ (NSMutableArray *)updateArticles:(NSMutableArray *)articles withArticlesFromData:(NSData *)data andResponse:(NSURLResponse *)response {
    NSMutableArray *downloadedArticles = [[NSMutableArray alloc] initWithArray:[self articlesFromData:data andResponse:response]];
    return [self updateExistingArticles:articles withNextPageArticles:downloadedArticles];
}

+ (NSMutableArray *)addNewestArticlesToExistingArticles:(NSMutableArray *)articles withArticlesFromData:(NSData *)data andResponse:(NSURLResponse *)response {
    NSMutableArray *downloadedArticles = [[NSMutableArray alloc] initWithArray:[self articlesFromData:data andResponse:response]];
    return [self addToExistingArticles:articles withNewestArticles:downloadedArticles];
}

+ (NSMutableArray *)articlesFromData:(NSData *)data andResponse:(NSURLResponse *)response {
    NSMutableArray *articles = [[NSMutableArray alloc] init];
    HTMLDocument *home = [self htmlDocumentFromData:data andResponse:response];
        for (HTMLElement *element in [home nodesMatchingSelector:@".thing"]){
            if (![self isElementModPost:element]){
                
                [articles addObject:[self articleFromElement:element]];
            }
        }
    return articles;
}

+ (NSString *)nextPageArticlesURLStringFromData:(NSData *)data andResponse:(NSURLResponse *)response {
    NSString *nextPageArticlesURLString = [[NSString alloc] init];
    HTMLDocument *home = [self htmlDocumentFromData:data andResponse:response];
    HTMLElement *navBtns = [home firstNodeMatchingSelector:@".nextprev"];
    HTMLElement *navBtn = navBtns.children[1];
    if ([navBtn.attributes[@"class"] isEqualToString:@"prev-button"]){
        HTMLElement *nextBtn = navBtns.children[3];
        HTMLElement *link = nextBtn.childElementNodes[0];
        nextPageArticlesURLString = link.attributes[@"href"];
    } else {
        HTMLElement *nextBtn = navBtns.children[1];
        HTMLElement *link = nextBtn.childElementNodes[0];
        nextPageArticlesURLString = link.attributes[@"href"];
    }
    return nextPageArticlesURLString;
}

+ (HTMLDocument *)htmlDocumentFromData:(NSData *)data andResponse:(NSURLResponse *)response {
    NSString *contentType = nil;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
        contentType = headers[@"Content-Type"];
    }
    return [HTMLDocument documentWithData:data
                        contentTypeHeader:contentType];
}

+ (BOOL)isElementModPost:(HTMLElement *)element {
    if ([[element.children[3][@"href"] substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"/"]){
        return YES;
    } else {
        return NO;
    }
}

+ (SKYArticle *)articleFromElement:(HTMLElement *)element {
    SKYArticle *article = [[SKYArticle alloc] init];
    HTMLElement *titleElement = [element.children[4] firstNodeMatchingSelector:@".title.may-blank"];
    //NSLog(@"%@", titleElement.textContent);
    //NSLog(@"%@", element.children[3][@"href"]);
    HTMLElement *imageElement = element.children[3];
    if (imageElement.children.count > 0){
        NSString *rawURL = imageElement.children[0][@"src"];
        NSString *imageURL = [rawURL stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@"http://"];
        //NSLog(@"%@", imageURL);
        article.imageUrlString = imageURL;
    } else {
        //NSLog(@"--- BLANK PHOTO ---");
        article.imageUrlString = nil;
    }
    article.title = titleElement.textContent;
    article.urlString = element.children[3][@"href"];
    
    return article;
}

+ (NSMutableArray *)updateExistingArticles:(NSMutableArray *)existingArticles withNextPageArticles:(NSMutableArray *)newArticles {
    NSMutableArray *articlesToAdd = [[NSMutableArray alloc] init];
    if (existingArticles.count > 0) {
        for (SKYArticle *newArticle in newArticles){
            BOOL articleExists = NO;
            for (SKYArticle *existingArticle in existingArticles) {
                if ([newArticle.urlString isEqualToString:existingArticle.urlString]){
                    articleExists = YES;
                    break;
                }
            }
            if (!articleExists) {
                [articlesToAdd addObject:newArticle];
            }
        }
        [existingArticles addObjectsFromArray:articlesToAdd];
        return existingArticles;
    } else {
        return newArticles;
    }
}

+ (NSMutableArray *)addToExistingArticles:(NSMutableArray *)existingArticles withNewestArticles:(NSMutableArray *)newArticles {
    NSMutableArray *articlesToAdd = [[NSMutableArray alloc] init];
    if (existingArticles.count > 0) {
        for (SKYArticle *newArticle in newArticles){
            BOOL articleExists = NO;
            for (SKYArticle *existingArticle in existingArticles) {
                if ([newArticle.urlString isEqualToString:existingArticle.urlString]){
                    articleExists = YES;
                    break;
                }
            }
            if (!articleExists) {
                [articlesToAdd addObject:newArticle];
            }
        }
        [articlesToAdd addObjectsFromArray:existingArticles];
        return articlesToAdd;
    } else {
        return newArticles;
    }
}

@end
