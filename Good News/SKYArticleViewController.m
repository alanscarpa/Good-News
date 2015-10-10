//
//  SKYArticleViewController.m
//  Good News
//
//  Created by Alan Scarpa on 10/6/15.
//  Copyright © 2015 Skytop Designs. All rights reserved.
//

#import "SKYArticleViewController.h"

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
