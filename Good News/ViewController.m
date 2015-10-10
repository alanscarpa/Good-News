//
//  ViewController.m
//  Good News
//
//  Created by Alan Scarpa on 7/19/15.
//  Copyright (c) 2015 Skytop Designs. All rights reserved.
//

#import "ViewController.h"
#import "Ono.h"
#import <HTMLReader/HTMLReader.h>


@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *imageURLs;
@property (nonatomic, strong) NSMutableArray *articleURLs;
@property (nonatomic, strong) NSMutableArray *articleTitles;
@property (nonatomic, strong) NSMutableArray *backAndNextURLs;

@end

@implementation ViewController

- (void)initializeStorage {
    self.imageURLs = [[NSMutableArray alloc] init];
    self.articleURLs = [[NSMutableArray alloc] init];
    self.articleTitles = [[NSMutableArray alloc] init];
    self.backAndNextURLs = [[NSMutableArray alloc] initWithArray:@[[NSNull null], [NSNull null]]];
}



- (void)viewDidLoad {
    [super viewDidLoad]; 
    [self initializeStorage];

    NSURL *URL = [NSURL URLWithString:@"https://www.reddit.com/r/UpliftingNews"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithURL:URL completionHandler:
      ^(NSData *data, NSURLResponse *response, NSError *error) {
          
          if (!error){
              NSString *contentType = nil;
              if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                  NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
                  contentType = headers[@"Content-Type"];
              }
              
              
              HTMLDocument *home = [HTMLDocument documentWithData:data
                                                contentTypeHeader:contentType];
              
              HTMLElement *navBtns = [home firstNodeMatchingSelector:@".nextprev"];
              
              NSArray *articles = [home nodesMatchingSelector:@".thing"];

              NSLog(@"Elments: %li", articles.count);
              for (HTMLElement *element in articles){
                  if ([[element.children[3][@"href"] substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"/"]){
                      NSLog(@"It's a mod post!");
                  } else {
                      HTMLElement *titleElement = [element.children[4] firstNodeMatchingSelector:@".title.may-blank"];
                      NSLog(@"%@", titleElement.textContent);
                      NSLog(@"%@", element.children[3][@"href"]);
                      
                      HTMLElement *imageElement = element.children[3];
                      if (imageElement.children.count > 0){
                          NSString *rawURL = imageElement.children[0][@"src"];
                          NSString *imageURL = [rawURL stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@"http://"];
                          NSLog(@"%@", imageURL);
                          [self.imageURLs addObject:imageURL];
                      } else {
                          NSLog(@"--- BLANK PHOTO ---");
                          [self.imageURLs addObject:[UIImage imageNamed:@"corgi"]];
                      }
                      [self.articleTitles addObject:titleElement.textContent];
                      [self.articleURLs addObject:element.children[3][@"href"]];
                  }
            }
              

              HTMLElement *navBtn = navBtns.children[1];
              if ([navBtn.attributes[@"rel"] isEqualToString:@"nofollow prev"]){
                  NSLog(@"We have a previous button & next button");
                  HTMLElement *backBtn = navBtns.children[1];
                  NSLog(@"%@", backBtn.attributes[@"href"]);
                  [self.backAndNextURLs replaceObjectAtIndex:0 withObject:backBtn.attributes[@"href"]];

                  HTMLElement *nextBtn = navBtns.children[3];
                  NSLog(@"%@", nextBtn.attributes[@"href"]);
                  [self.backAndNextURLs replaceObjectAtIndex:1 withObject:nextBtn.attributes[@"href"]];

              } else {
                  NSLog(@"We only have a next button");
                  HTMLElement *nextBtn = navBtns.children[1];
                  NSLog(@"%@", nextBtn.attributes[@"href"]);
                  [self.backAndNextURLs replaceObjectAtIndex:1 withObject:nextBtn.attributes[@"href"]];
              }
              
              NSLog(@"\nImages: %li\nArticles: %li", (unsigned long)self.imageURLs.count, (unsigned long)self.articleTitles.count);
              NSLog(@"Back and Next button: %@", self.backAndNextURLs);

          } else {
              NSLog(@"Error: %@", error);
          }
      }];
    
    [task resume];
}

@end
