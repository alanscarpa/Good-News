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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
//        NSURL *url = [[NSURL alloc]initWithString:@"https://www.reddit.com/r/upliftingnews"];
//        NSData *data = [[NSData alloc]initWithContentsOfURL:url];
//        NSError *error;
//    
    
    // Parse a string and find an element.
  //  NSString *markup = @"<p><b>Ahoy there sailor!</b></p>";
//    HTMLDocument *document = [HTMLDocument documentWithData:data contentTypeHeader:nil];
//    NSLog(@"%@", [document firstNodeMatchingSelector:@"entry unvoted"].textContent);
//    // => Ahoy there sailor!
//    
//    // Wrap one element in another.
//    HTMLElement *b = [document firstNodeMatchingSelector:@"b"];
//    NSMutableOrderedSet *children = [b.parentNode mutableChildren];
//    HTMLElement *wrapper = [[HTMLElement alloc] initWithTagName:@"div"
//                                                     attributes:@{@"class": @"special"}];
//    [children insertObject:wrapper atIndex:[children indexOfObject:b]];
//    b.parentNode = wrapper;
//    //NSLog(@"%@", [document.rootElement serializedFragment]);
//    // => <html><head></head><body><p><div class="special"> \
//    <b>Ahoy there sailor!</b></div></p></body></html>
    
    // Load a web page.
    NSURL *URL = [NSURL URLWithString:@"https://www.reddit.com/r/UpliftingNews"];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:URL completionHandler:
      ^(NSData *data, NSURLResponse *response, NSError *error) {
          
          NSString *contentType = nil;
          if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
              NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
              contentType = headers[@"Content-Type"];
          }
          
          HTMLDocument *home = [HTMLDocument documentWithData:data
                                            contentTypeHeader:contentType];
          
          HTMLElement *navBtns = [home firstNodeMatchingSelector:@".nextprev"];
          NSArray *articles = [home nodesMatchingSelector:@".title.may-blank"];
          NSArray *thumbnails = [home nodesMatchingSelector:@".thumbnail.may-blank"];
          
          
          NSLog(@"%li", articles.count);
          NSLog(@"%li", thumbnails.count);

          
          for (HTMLElement *photo in thumbnails){
              if (photo.children.count > 0){
                  HTMLElement *link = photo.children[0];
                  NSString *rawLink = link.attributes[@"src"];
                  NSString *imageLink = [rawLink stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@"http://"];
                  NSLog(@"%@", imageLink);
              }
              
          }
          
          for (HTMLElement *element in articles){
              if ([[element.attributes[@"href"] substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"/"]){
                  NSLog(@"It's a mod post!");
              } else {
                  NSLog(@"%@", element.textContent);
                  NSLog(@"%@", element.attributes[@"href"]);
              }
              
              //if href begins with /r/ then don't add to array. it's a modpost.
          }
          

          HTMLElement *navBtn = navBtns.children[1];
          if ([navBtn.attributes[@"rel"] isEqualToString:@"nofollow prev"]){
              NSLog(@"We have a previous button & next button");
              HTMLElement *backBtn = navBtns.children[1];
              NSLog(@"%@", backBtn.attributes[@"href"]);
              HTMLElement *nextBtn = navBtns.children[3];
              NSLog(@"%@", nextBtn.attributes[@"href"]);

          } else {
              NSLog(@"We only have a next button");
              HTMLElement *nextBtn = navBtns.children[1];
              NSLog(@"%@", nextBtn.attributes[@"href"]);
          }
          
      }] resume];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
