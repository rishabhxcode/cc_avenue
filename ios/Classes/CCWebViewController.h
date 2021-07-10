//
//  CCPOViewController.h
//  CCIntegrationKit
//
//  Created by test on 5/12/14.
//  Copyright (c) 2014 Avenues. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCWebViewController : UIViewController <UIWebViewDelegate>

    @property (strong, nonatomic) IBOutlet UIWebView *viewWeb;

    @property (strong, nonatomic) NSString *accessCode;
    @property (strong, nonatomic) NSString *merchantId;
    @property (strong, nonatomic) NSString *orderId;
    @property (strong, nonatomic) NSString *amount;
    @property (strong, nonatomic) NSString *currency;
    @property (strong, nonatomic) NSString *redirectUrl;
    @property (strong, nonatomic) NSString *cancelUrl;
    @property (strong, nonatomic) NSString *rsaKeyUrl;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;



@end
