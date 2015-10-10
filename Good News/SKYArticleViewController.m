//
//  SKYArticleViewController.m
//  Good News
//
//  Created by Alan Scarpa on 10/6/15.
//  Copyright © 2015 Skytop Designs. All rights reserved.
//

#import "SKYArticleViewController.h"
#import "SKYArticle.h"

@interface SKYArticleViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation SKYArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
}

- (void)setUpUI {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.shareButton.layer.cornerRadius = 8.0;
    self.shareButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.shareButton.titleLabel.minimumScaleFactor = 0.5;
    [self prepareWebView];
}

- (void)prepareWebView {
    self.article.urlString = [self.article.urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSString *escapedURL = [@"http://readability.com/api/content/v1/parser?token=781e1dfed669b731e19f697ad977c3b8a0304d9c&url=" stringByAppendingString:self.article.urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:escapedURL]
                                                           cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (data){
            NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSString *title = [NSString stringWithFormat:@"%@", jsonArray[@"title"]];

            NSMutableString *html = [NSMutableString stringWithFormat:@"<html><meta name=\"viewport\" content=\"width=device-width\"><link rel=\"stylesheet\" type=\"text/css\" href=\"normalize.css\"><link rel=\"stylesheet\" type=\"text/css\" href=\"foundation.css\"><script src=\"modernizr.js\"></script><script src=\"jquery.js\"></script><script src=\"foundation.min.js\"></script><link rel=\"stylesheet\" type=\"text/css\" href=\"custom.css\"><h3>%@</h3>", title];
            
            [html appendFormat:@"%@</html>", jsonArray[@"content"]];
            
            [self.webView loadHTMLString:html baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
        } else {
            // Show Alert Somehow
            NSLog(@"Error sending to DiffBot");
            NSLog(@"%@", response);
            NSLog(@"%@", connectionError);
        }
        
        
        
        
    }];
    [self.webView loadHTMLString:@"There was a baby!  It was drowning, but before it gasped it's last sweet breath, a magnificent corgi named Yogi fearlessly dove into the ocean and pulled the baby out by it's diaper.\n\nThere was a baby!  It was drowning, but before it gasped it's last sweet breath, a magnificent corgi named Yogi fearlessly dove into the ocean and pulled the baby out by it's diaper.\n\nThere was a baby!  It was drowning, but before it gasped it's last sweet breath, a magnificent corgi named Yogi fearlessly dove into the ocean and pulled the baby out by it's diaper.\n\nThere was a baby!  It was drowning, but before it gasped it's last sweet breath, a magnificent corgi named Yogi fearlessly dove into the ocean and pulled the baby out by it's diaper.\n\nThere was a baby!  It was drowning, but before it gasped it's last sweet breath, a magnificent corgi named Yogi fearlessly dove into the ocean and pulled the baby out by it's diaper.\n\nThere was a baby!  It was drowning, but before it gasped it's last sweet breath, a magnificent corgi named Yogi fearlessly dove into the ocean and pulled the baby out by it's diaper.\n\nThere was a baby!  It was drowning, but before it gasped it's last sweet breath, a magnificent corgi named Yogi fearlessly dove into the ocean and pulled the baby out by it's diaper.\n\nThere was a baby!  It was drowning, but before it gasped it's last sweet breath, a magnificent corgi named Yogi fearlessly dove into the ocean and pulled the baby out by it's diaper.\n\n" baseURL:nil];
}
- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareButtonTapped:(id)sender {
    NSString *texttoshare = [NSString stringWithFormat:@"Joy to the world  powered by @goodnewsapp"];
    NSArray *activityItems = @[texttoshare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
    [self presentViewController:activityVC animated:YES completion:nil];
}




@end
