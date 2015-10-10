//
//  SKYNewsFeedTableViewController.m
//  Good News
//
//  Created by Alan Scarpa on 10/6/15.
//  Copyright © 2015 Skytop Designs. All rights reserved.
//

#import "SKYNewsFeedTableViewController.h"
#import "SKYNewsFeedTableViewCell.h"
#import "SKYNetworkHandler.h"
#import "SKYNewsFeedTableViewCell+Customization.h"

NSString *const kArticleSourceUrlString = @"https://www.reddit.com/r/UpliftingNews";

@interface SKYNewsFeedTableViewController ()

@property (nonatomic, strong) NSMutableArray *articles;

@end

@implementation SKYNewsFeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareDataSource];
    [self loadArticles];
    [self setUpUI];
}

- (void)prepareDataSource {
    self.articles = [[NSMutableArray alloc] init];
}

- (void)loadArticles {
    [SKYNetworkHandler getNewestArticlesForArticleList:self.articles FromSource:kArticleSourceUrlString withCompletionHandler:^(NSMutableArray *articles, NSError *error) {
        if (!error){
            [self updateDataSourceWithArticles:articles];
            [self.tableView reloadData];
        } else {
            NSLog(@"Error getting latest articlets: %@", error);
        }
    }];
}

- (void)updateDataSourceWithArticles:(NSMutableArray *)articles {
    self.articles = articles;
}

- (void)setUpUI {
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:255.0/255 green:231.0/255 blue:186.0/255 alpha:1]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:@"Ostrich Sans Inline" size:36.0]};
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SKYNewsFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell customizeWithArticle:self.articles[indexPath.row]];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
