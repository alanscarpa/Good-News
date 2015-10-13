//
//  SKYArticleViewController.m
//  Good News
//
//  Created by Alan Scarpa on 10/6/15.
//  Copyright © 2015 Skytop Designs. All rights reserved.
//

#import "SKYArticleViewController.h"
#import "SKYArticle.h"
#import <Chartboost/Chartboost.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface SKYArticleViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic) BOOL areAdsRemoved;
@property (weak, nonatomic) IBOutlet UIButton *noAdsButton;

@end

@implementation SKYArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self prepareWebView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self checkIfAdsAreRemoved];
}

- (void)checkIfAdsAreRemoved {
    self.areAdsRemoved = [[NSUserDefaults standardUserDefaults] boolForKey:@"areAdsRemoved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (!self.areAdsRemoved){
        [Chartboost showInterstitial:CBLocationHomeScreen];
    } else {
        self.noAdsButton.hidden = YES;
    }
}

- (void)setUpUI {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.shareButton.layer.cornerRadius = 8.0;
    self.shareButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.shareButton.titleLabel.minimumScaleFactor = 0.5;
}

- (void)prepareWebView {
    [SVProgressHUD show];

    self.webView.delegate = self;
    if (!self.article.isUrlEscaped) {
        self.article.urlStringEscaped = [self.article.urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        self.article.isUrlEscaped = YES;
    }
    
    NSString *escapedURL = [NSString stringWithFormat:@"http://api.embed.ly/1/extract?key=e96aa82e44c449c694e1e5b23cea1a36&url=%@&maxwidth=500", self.article.urlStringEscaped];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:escapedURL]
                                                           cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                       timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        if (data){

            NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSString *title = [NSString stringWithFormat:@"%@", jsonArray[@"title"]];
            NSString *htmlContent = jsonArray[@"content"];
            NSArray *imagesDictionary = [[NSArray alloc] init];
            NSMutableArray *imagesHTMLString = [[NSMutableArray alloc] init];

            if (jsonArray[@"content"] == [NSNull null]) {
                htmlContent = jsonArray[@"media"][@"html"];
            }
            if (jsonArray[@"content"] == [NSNull null] && [jsonArray[@"media"] count] == 0) {
                imagesDictionary = jsonArray[@"images"];
                if (imagesDictionary.count > 0) {
                    for (NSDictionary *dictionary in imagesDictionary) {
                        NSString *imageHTMLString = [NSString stringWithFormat:@"<br><br><img src=\"%@\">", dictionary[@"url"]];
                        [imagesHTMLString addObject:imageHTMLString];
                    }
                    htmlContent = [imagesHTMLString componentsJoinedByString:@""];
                }
            }
            
            NSMutableString *html = [NSMutableString stringWithFormat:@"<html><style>body{background:#fff;color:#222;cursor:auto;font-family:\"IowanOldStyle\";fontstyle:normal;font-weight:normal;line-height:1.5;margin:0;padding:10px;position:relative;font-size:20px;}img{max-width:92%%;margin:0 auto;display:table;}iframe{max-width:98%%;}h3{font-family: \"Iowan Old Style\";}</style><h3>%@</h3>%@<br><i>Source: <a href=\"%@\">%@</a>" , title, htmlContent, self.article.urlString, self.article.urlString];
            
            [self.webView loadHTMLString:html baseURL:[NSURL URLWithString:@"http://skytopdesigns.com"]];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [SVProgressHUD dismiss];
            }];
        } else {
            NSLog(@"Error calling Embedly");
            [SVProgressHUD dismiss];
            NSLog(@"%@", response);
            NSLog(@"%@", connectionError);
        }
    }];
}

- (IBAction)backButtonTapped:(id)sender {
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareButtonTapped:(id)sender {
    NSString *texttoshare = [NSString stringWithFormat:@"Here's some good news for a change: %@  via @goodnewsapp http://bit.ly/goodnewsapp", self.article.urlString];
    NSArray *activityItems = @[texttoshare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView.scrollView setContentSize: CGSizeMake(webView.frame.size.width, webView.scrollView.contentSize.height)];
}

@end
