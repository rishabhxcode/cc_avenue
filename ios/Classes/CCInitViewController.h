//
//  CCInitViewController.h
//  CCIntegrationKit
//
//  Created by test on 7/14/14.
//  Copyright (c) 2014 Avenues. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCInitViewController : UIViewController< UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic)IBOutlet UITextField *accessCode;

@property (strong, nonatomic) IBOutlet UIView *contentview;

@property (strong, nonatomic) IBOutlet UIScrollView *Scrollview;


    @property (strong, nonatomic) IBOutlet UITextField *merchantId;
    @property (strong, nonatomic) IBOutlet UITextField *currency;
    @property (strong, nonatomic) IBOutlet UITextField *amount;
    @property (strong, nonatomic) IBOutlet UITextField *orderId;
    @property (strong, nonatomic) IBOutlet UITextField *redirectUrl;
    @property (strong, nonatomic) IBOutlet UITextField *cancelUrl;
    @property (strong, nonatomic) IBOutlet UITextField *rsaKeyUrl;

@property (weak, nonatomic) IBOutlet UIButton *nextbttn;


@end
