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
        UIAlertView *alertBox = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to make payments with current Apple ID." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertBox show];
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *validProduct = nil;
    NSUInteger count = [response.products count];
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
    if([SKPaymentQueue canMakePayments]){
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    } else {
        NSLog(@"User cannot make payments due to parental controls");
        UIAlertView *alertBox = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Unable to restore purchase with current Apple ID." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertBox show];
    }
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{

}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    NSLog(@"%@", error);
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for(SKPaymentTransaction *transaction in transactions){
        switch(transaction.transactionState){
            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
                //called when the user is in the process of purchasing, do not add any of your own code here.
                break;
            case SKPaymentTransactionStatePurchased:
                //this is called when the user has successfully purchased the package (Cha-Ching!)
                 //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self doRemoveAds];
                NSLog(@"Transaction state -> Purchased");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self doRemoveAds];
                break;
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finish
                if(transaction.error.code == SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    //the user cancelled the payment ;(
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateDeferred:
                //called when the transaction is deferred
                [self transactionDeferred];
                break;
        }
    }
}

- (void)doRemoveAds{
    BOOL areAdsRemoved = YES;
    [[NSUserDefaults standardUserDefaults] setBool:areAdsRemoved forKey:@"areAdsRemoved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)transactionDeferred {
    UIAlertView *alertBox = [[UIAlertView alloc]initWithTitle:@"Request Deferred" message:@"Request to purchase has been sent to parent phone.  Thank you!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertBox show];
    
}

@end
