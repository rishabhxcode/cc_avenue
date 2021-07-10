//
//  CCPOViewController.m
//  CCIntegrationKit
//
//  Created by test on 5/12/14.
//  Copyright (c) 2014 Avenues. All rights reserved.
//

#import "CCWebViewController.h"
#import "CCResultViewController.h"
#import "RSA.h"

@interface CCWebViewController ()

@end

@implementation CCWebViewController

@synthesize rsaKeyUrl;@synthesize accessCode;@synthesize merchantId;@synthesize orderId;
@synthesize amount;@synthesize currency;@synthesize redirectUrl;@synthesize cancelUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.viewWeb.delegate = self;
    
    //Getting RSA Key
    NSString *rsaKeyDataStr = [NSString stringWithFormat:@"access_code=%@&order_id=%@",accessCode,orderId];
    
    NSData *requestData = [NSData dataWithBytes: [rsaKeyDataStr UTF8String] length: [rsaKeyDataStr length]];
    
    NSMutableURLRequest *rsaRequest = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: rsaKeyUrl]];
    
    [rsaRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    [rsaRequest setHTTPMethod: @"POST"];
    
    [rsaRequest setHTTPBody: requestData];
    
    NSData *rsaKeyData = [NSURLConnection sendSynchronousRequest: rsaRequest returningResponse: nil error: nil];
    
    NSString *rsaKey = [[NSString alloc] initWithData:rsaKeyData encoding:NSASCIIStringEncoding];
    
    rsaKey = [rsaKey stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    rsaKey = [NSString stringWithFormat:@"-----BEGIN PUBLIC KEY-----\n%@\n-----END PUBLIC KEY-----\n",rsaKey];
    NSLog(@"%@",rsaKey);
    
    //Encrypting Card Details
    
    NSString *myRequestString = [NSString stringWithFormat:@"amount=%@&currency=%@",amount,currency];

    
    NSString *encVal = [RSA encryptString:myRequestString publicKey:rsaKey];
    
    encVal = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                   (CFStringRef)encVal,
                                                                                   NULL,
                                                                                   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                   kCFStringEncodingUTF8 ));
    
    //Preparing for a webview call
    
    NSString *urlAsString = [NSString stringWithFormat:@"https://secure.ccavenue.com/transaction/initTrans"];
    
    NSString *encryptedStr = [NSString stringWithFormat:@"merchant_id=%@&order_id=%@&redirect_url=%@&cancel_url=%@&enc_val=%@&access_code=%@",merchantId,orderId,redirectUrl,cancelUrl,encVal,accessCode];
    
    NSData *myRequestData = [NSData dataWithBytes: [encryptedStr UTF8String] length: [encryptedStr length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: urlAsString]];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    [request setValue:urlAsString forHTTPHeaderField:@"Referer"];
    
    [request setHTTPMethod: @"POST"];
    
    [request setHTTPBody: myRequestData];
    
    [_viewWeb loadRequest:request];
}


-(void)webViewDidStartLoad:(UIWebView *)webView
{
    _indicator.startAnimating;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    _indicator.stopAnimating;
    _indicator.hidden = true;
    
    NSString *string = webView.request.URL.absoluteString;

    if ([string isEqualToString:@"https://secure.ccavenue.com/transaction/initTrans"])
    {
        // Autofill billing data all data replace dummy values with the user data
        
        [_viewWeb stringByEvaluatingJavaScriptFromString:@"document.getElementById('orderBillName').value = \"UserName\""];
        
        [_viewWeb stringByEvaluatingJavaScriptFromString:@"document.getElementById('orderBillAddress').value = \"CCAvenue Santacruz\""];
        
        [_viewWeb stringByEvaluatingJavaScriptFromString:@"document.getElementById('orderBillZip').value = \"400054\""];
        
        [_viewWeb stringByEvaluatingJavaScriptFromString:@"document.getElementById('orderBillCity').value = \"Mumbai\""];
        
        [_viewWeb stringByEvaluatingJavaScriptFromString:@"document.getElementById('orderBillState').value = \"MH\""];
        
        [_viewWeb stringByEvaluatingJavaScriptFromString:@"document.getElementById('orderBillCountry').value = \"India\""];
        
        [_viewWeb stringByEvaluatingJavaScriptFromString:@"document.getElementById('orderBillTel').value = \"9876543210\""];
        
        [_viewWeb stringByEvaluatingJavaScriptFromString:@"document.getElementById('orderBillEmail').value = \"test@gmail.com\""];
        
        [_viewWeb stringByEvaluatingJavaScriptFromString:@"document.getElementById('orderNotes').value = \"Tution Fees\""];
        
        [_viewWeb stringByEvaluatingJavaScriptFromString:@"document.getElementById('finalTotal').value = \"100.00\""];
    }
    
    if ([string rangeOfString:redirectUrl].location != NSNotFound)
    {
        NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
        
        NSString *transStatus = @"Not Known";
 
        if(([html rangeOfString:@"tracking_id"].location != NSNotFound) &&  ([html rangeOfString:@"bin_country"].location != NSNotFound))
        {
            if (([html rangeOfString:@"Aborted"].location != NSNotFound) ||
                ([html rangeOfString:@"Cancel"].location != NSNotFound))
            {
                transStatus = @"Transaction Cancelled";
            }
            else if (([html rangeOfString:@"Success"].location != NSNotFound))
            {
                transStatus = @"Transaction Successful";
            }
            else if (([html rangeOfString:@"Fail"].location != NSNotFound))
            {
                transStatus = @"Transaction Failed";
            }
            
            CCResultViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CCResultViewController"];
            
            controller.transStatus = transStatus;
            
            controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            
            [self presentViewController:controller animated:YES completion:nil];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
