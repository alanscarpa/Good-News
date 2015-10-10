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
    
    
    return [self updateExistingArticles:articles withNewArticles:downloadedArticles];
//    HTMLElement *navBtns = [home firstNodeMatchingSelector:@".nextprev"];

//    HTMLElement *navBtn = navBtns.children[1];
//    if ([navBtn.attributes[@"rel"] isEqualToString:@"nofollow prev"]){
//        NSLog(@"We have a previous button & next button");
//        HTMLElement *backBtn = navBtns.children[1];
//        NSLog(@"%@", backBtn.attributes[@"href"]);
//        [self.backAndNextURLs replaceObjectAtIndex:0 withObject:backBtn.attributes[@"href"]];
//        
//        HTMLElement *nextBtn = navBtns.children[3];
//        NSLog(@"%@", nextBtn.attributes[@"href"]);
//        [self.backAndNextURLs replaceObjectAtIndex:1 withObject:nextBtn.attributes[@"href"]];
//        
//    } else {
//        NSLog(@"We only have a next button");
//        HTMLElement *nextBtn = navBtns.children[1];
//        NSLog(@"%@", nextBtn.attributes[@"href"]);
//        [self.backAndNextURLs replaceObjectAtIndex:1 withObject:nextBtn.attributes[@"href"]];
//    }
//    
//    NSLog(@"\nImages: %li\nArticles: %li", (unsigned long)self.imageURLs.count, (unsigned long)self.articleTitles.count);
//    NSLog(@"Back and Next button: %@", self.backAndNextURLs);
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
    NSLog(@"%@", titleElement.textContent);
    NSLog(@"%@", element.children[3][@"href"]);
    HTMLElement *imageElement = element.children[3];
    if (imageElement.children.count > 0){
        NSString *rawURL = imageElement.children[0][@"src"];
        NSString *imageURL = [rawURL stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@"http://"];
        NSLog(@"%@", imageURL);
        article.imageUrlString = imageURL;
    } else {
        NSLog(@"--- BLANK PHOTO ---");
        article.imageUrlString = nil;
    }
    article.title = titleElement.textContent;
    article.urlString = element.children[3][@"href"];
    return article;
}

+ (NSMutableArray *)updateExistingArticles:(NSMutableArray *)existingArticles withNewArticles:(NSMutableArray *)newArticles {
    if (existingArticles.count > 0) {
        for (SKYArticle *newArticle in newArticles){
            for (SKYArticle *existingArticle in existingArticles) {
                if ([newArticle.urlString isEqualToString:existingArticle.urlString]){
                    NSLog(@"Already have article.");
                } else {
                    [existingArticles addObject:newArticle];
                }
            }
        }
        return existingArticles;
    } else {
        return newArticles;
    }
}

@end