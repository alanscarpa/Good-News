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
#import "SKYArticleViewController.h"
#import <UIScrollView+InfiniteScroll.h>
#import <SVProgressHUD/SVProgressHUD.h>

NSString *const kArticleSourceUrlString = @"https://www.reddit.com/r/UpliftingNews";

@interface SKYNewsFeedTableViewController ()

@property (nonatomic, strong) NSMutableArray *articles;
@property (nonatomic, strong) NSMutableArray *backAndNextButtonURLStrings;
@property (nonatomic, strong) UIRefreshControl *pullDownRefreshControl;

@end

@implementation SKYNewsFeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD show];
    [self prepareDataSource];
    [self loadNewestArticles];
    [self setUpInfiniteScroller];
    [self setUpRefreshScroller];
    [self setUpUI];
}

- (void)prepareDataSource {
    self.articles = [[NSMutableArray alloc] init];
    self.backAndNextButtonURLStrings = [[NSMutableArray alloc] init];
}

- (void)loadNewestArticles{
    [SKYNetworkHandler getNewestArticlesForArticleList:self.articles FromSource:kArticleSourceUrlString withCompletionHandler:^(NSMutableArray *articles, NSMutableArray *backAndNextButtonURLStrings, NSError *error) {
        if (!error){
            [self updateDataSourceWithArticles:articles
                      andBackAndNextURLStrings:backAndNextButtonURLStrings];
            [SVProgressHUD dismiss];
            [self.tableView reloadData];
            [self.pullDownRefreshControl endRefreshing];
        } else {
            NSLog(@"Error getting latest articlets: %@", error);
        }
    }];
}

- (void)loadNextPageArticlesFromSource:(NSString *)urlString {
    [SKYNetworkHandler getNextPageArticlesForArticleList:self.articles FromSource:urlString withCompletionHandler:^(NSMutableArray *articles, NSMutableArray *backAndNextButtonURLStrings, NSError *error) {
        if (!error){
            [self updateDataSourceWithArticles:articles
                      andBackAndNextURLStrings:backAndNextButtonURLStrings];
            [self.tableView reloadData];
        } else {
            NSLog(@"Error getting latest articlets: %@", error);
        }
    }];
}

- (void)updateDataSourceWithArticles:(NSMutableArray *)articles
            andBackAndNextURLStrings:(NSMutableArray *)backAndNextURLStrings {
    self.articles = articles;
    self.backAndNextButtonURLStrings = backAndNextURLStrings;
}

- (void)setUpInfiniteScroller {
    self.tableView.infiniteScrollIndicatorStyle = UIActivityIndicatorViewStyleGray;
    
    __weak typeof(self) weakSelf = self;

    [self.tableView addInfiniteScrollWithHandler:^(UITableView* tableView) {
        [weakSelf loadNextPageArticlesFromSource:weakSelf.backAndNextButtonURLStrings[1]];
        [tableView reloadData];
        [tableView finishInfiniteScroll];
    }];
}

- (void)setUpRefreshScroller {
    self.pullDownRefreshControl = [[UIRefreshControl alloc] init];
    [self.pullDownRefreshControl addTarget:self action:@selector(loadNewestArticles) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.pullDownRefreshControl];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SKYArticleViewController *destinationVC = [segue destinationViewController];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    destinationVC.article = self.articles[indexPath.row];
}

@end
