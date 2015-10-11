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
    if (!self.article.isUrlEscaped) {
        self.article.urlStringEscaped = [self.article.urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        self.article.isUrlEscaped = YES;
    }
    
    NSString *escapedURL = [@"http://readability.com/api/content/v1/parser?token=781e1dfed669b731e19f697ad977c3b8a0304d9c&url=" stringByAppendingString:self.article.urlStringEscaped];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:escapedURL]
                                                           cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        if (data){
            NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSString *title = [NSString stringWithFormat:@"%@", jsonArray[@"title"]];

            
            NSMutableString *html = [NSMutableString stringWithFormat:@"<link rel=\"stylesheet\" type=\"text/css\" href=\"custom.css\"><h3>%@</h3>", title];
            
            [html appendFormat:@"%@</html>", jsonArray[@"content"]];
            
            [self.webView loadHTMLString:html baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];

        } else {
            NSLog(@"Error calling Readability");
            NSLog(@"%@", response);
            NSLog(@"%@", connectionError);
        }
    }];
}

- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareButtonTapped:(id)sender {
    NSString *texttoshare = [NSString stringWithFormat:@"Here's some good news for a change: %@  via @goodnewsapp", self.article.urlString];
    NSArray *activityItems = @[texttoshare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
    [self presentViewController:activityVC animated:YES completion:nil];
}

@end
