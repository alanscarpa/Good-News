//
//  SKYRemoveAdsViewController.m
//  Good News
//
//  Created by Alan Scarpa on 10/12/15.
//  Copyright © 2015 Skytop Designs. All rights reserved.
//

#import "SKYRemoveAdsViewController.h"

@interface SKYRemoveAdsViewController ()

@end

@implementation SKYRemoveAdsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{
       NSFontAttributeName:[UIFont fontWithName:@"Ostrich Sans Inline" size:18.0]
       }
     forState:UIControlStateNormal];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
