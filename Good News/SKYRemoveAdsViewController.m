//
//  SKYRemoveAdsViewController.m
//  Good News
//
//  Created by Alan Scarpa on 10/12/15.
//  Copyright © 2015 Skytop Designs. All rights reserved.
//

#import "SKYRemoveAdsViewController.h"
#import <StoreKit/StoreKit.h>

NSString *const kRemoveAdsProductIdentifier = @"com.skytopdesigns.goodnews.removeads";

@interface SKYRemoveAdsViewController () <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@end

@implementation SKYRemoveAdsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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


- (IBAction)upgradeButtonTapped:(id)sender {
    if([SKPaymentQueue canMakePayments]){
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kRemoveAdsProductIdentifier]];
        productsRequest.delegate = self;
        [productsRequest start];
    }
    else{
        NSLog(@"User cannot make payments due to parental controls");
        //this is called the user cannot make payments, most likely due to parental controls
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *validProduct = nil;
    int count = [response.products count];
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        [self purchase:validProduct];
    }
    else if(!validProduct){
        NSLog(@"No products available");
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
}

- (void)purchase:(SKProduct *)product{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}


- (IBAction)restorePurchasesButtonTapped:(id)sender {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %i", queue.transactions.count);
    for(SKPaymentTransaction *transaction in queue.transactions){
        if(transaction.transactionState == SKPaymentTransactionStateRestored){
            //called when the user successfully restores a purchase
            NSLog(@"Transaction state -> Restored");
            
            [self doRemoveAds];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for(SKPaymentTransaction *transaction in transactions){
        switch(transaction.transactionState){
            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
                //called when the user is in the process of purchasing, do not add any of your own code here.
                break;
            case SKPaymentTransactionStatePurchased:
                //this is called when the user has successfully purchased the package (Cha-Ching!)
                [self doRemoveAds]; //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transaction state -> Purchased");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finish
                if(transaction.error.code == SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    //the user cancelled the payment ;(
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    }
}

- (void)doRemoveAds{
    BOOL areAdsRemoved = YES;
    [[NSUserDefaults standardUserDefaults] setBool:areAdsRemoved forKey:@"areAdsRemoved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
