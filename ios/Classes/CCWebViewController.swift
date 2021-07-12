//
//  CCWebViewController.swift
//  CCIntegrationKit_Swift
//
//  Created by Ram Mhapasekar on 7/4/17.
//  Copyright © 2017 Ram Mhapasekar. All rights reserved.
//

import UIKit
import Foundation

/**
 * class: CCWebViewController
 * CCWebViewController is responsible for to take all the values from the merchant and process futher for the payment
 * We will generate the RSA Key for this transaction first by using access code of the merchant and the unique order id for this transaction
 * After generating Successful RSA Key we will use that key for encrypting amount and currency and the encrypted details will use for intiate the transaction
 * Once the transaction is done  we will pass the transaction result to the next page (ie CCResultViewController here)
 */

class CCWebViewController: UIViewController,UIWebViewDelegate {
    
    var accessCode = String()
    var merchantId = String()
    var orderId = String()
    var amount = String()
    var transUrl = String()
    var currency = String()
    var redirectUrl = String()
    var cancelUrl = String()
    var rsaKeyUrl = String()
    var rsaKeyDataStr = String()
    var rsaKey = String()
    static var statusCode = 0//zero means success or else error in encrption with rsa
    var encVal = String()
    var isHere = false
    
    private var notification: NSObjectProtocol?
    
    lazy var viewWeb: UIWebView = {
        let webView = UIWebView()
        webView.backgroundColor = .white
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.delegate = self
        webView.scalesPageToFit = true
        webView.contentMode = UIView.ContentMode.scaleAspectFill
        webView.tag = 1011
        return webView
    }()
    
    var request: NSMutableURLRequest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewWeb.delegate = self
        setupWebView()
    }
    
    
    deinit {
        if let notification = notification {
            NotificationCenter.default.removeObserver(notification)
        }
    }
    
    fileprivate func checkResponseUrl(){
        let string = (viewWeb.request?.url?.absoluteString)!
        print("String :: \(string)")
        
        if(string.contains(redirectUrl))
        {
            print(viewWeb.isLoading)
            guard let htmlTemp:NSString = viewWeb.stringByEvaluatingJavaScript(from: "document.documentElement.outerHTML") as NSString? else{
                print("failed to evaluate javaScript")
                return
            }
            
            let html = htmlTemp
            print("html :: ",html)
            var transStatus = "Not Known"
            
            if ((html ).range(of: "tracking_id").location != NSNotFound) && ((html ).range(of: "bin_country").location != NSNotFound) {
                if ((html ).range(of: "Aborted").location != NSNotFound) || ((html ).range(of: "Cancel").location != NSNotFound) {
                    transStatus = "Transaction Cancelled"
                    let controller: CCResultViewController = CCResultViewController()
                    controller.transStatus = transStatus
                    self.present(controller, animated: true, completion: nil)
                }
                else if ((html ).range(of: "Success").location != NSNotFound) {
                    transStatus = "Transaction Successful"
                    let controller: CCResultViewController = CCResultViewController()
                    controller.transStatus = transStatus
                    self.present(controller, animated: true, completion: nil)
                }
                else if ((html ).range(of: "Fail").location != NSNotFound) {
                    transStatus = "Transaction Failed"
                    let controller: CCResultViewController = CCResultViewController()
                    controller.transStatus = transStatus
                    self.present(controller, animated: true, completion: nil)
                }
            }
            else{
                print("html does not contain any related data")
                displayAlert(msg: "html does not contain any related data for this transaction.")
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = .white
        viewWeb.delegate = self
        setupWebView()
        super.viewWillAppear(animated)
        /**
         * In viewWillAppear we will call gettingRsaKey method to generate RSA Key for the transaction and use the same to encrypt data
         */
        
        if !isHere {
            isHere = true
            self.gettingRsaKey(){
                (success, object) -> () in
                DispatchQueue.main.sync {
                    if success {
                        self.encyptCardDetails(data: object as! Data)
                    }
                    else{
                        self.displayAlert(msg: object as! String)
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        LoadingOverlay.shared.showOverlay(view: self.view)
    }
    
    //MARK:
    //MARK: setupWebView
    
    private func setupWebView(){
        //setup webview
        view.addSubview(viewWeb)
        if #available(iOS 11.0, *) {
            viewWeb.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            viewWeb.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            // Fallback on earlier versions
            viewWeb.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            viewWeb.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        
        viewWeb.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        viewWeb.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        _ = [viewWeb .setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.vertical)]
    }
    
    
    //MARK:
    //MARK: Get RsaKey & encrypt card details
    
    /**
     * In this method we will generate RSA Key from the URL for this we will pass order id and the access code as the request parameter
     * after the successful key generation we'll pass the data to the request handler using complition block
     */
    
    private func gettingRsaKey(completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()){
        DispatchQueue.main.async {
            self.rsaKeyDataStr = "access_code=\(self.accessCode)&order_id=\(self.orderId)"
            
            let requestData = self.rsaKeyDataStr.data(using: String.Encoding.utf8)
            
            guard let urlFromString = URL(string: self.rsaKeyUrl) else{
                return
            }
            
            var urlRequest = URLRequest(url: urlFromString)
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = requestData
            
            let session = URLSession(configuration: URLSessionConfiguration.default)
            print("session",session)
            
            session.dataTask(with: urlRequest as URLRequest) {
                (data, response, error) -> Void in
                if let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode{
                    guard let responseData = data else{
                        print("No value for data")
                        completion(false, "Not proper data for RSA Key" as AnyObject?)
                        return
                    }
                    print("data :: ",responseData)
                    completion(true, responseData as AnyObject?)
                }
                else{
                    completion(false, "Unable to generate RSA Key please check" as AnyObject?)                }
                }.resume()
        }
    }
    
    /**
     * encyptCardDetails method we will use the rsa key to encrypt amount and currency and onece the encryption is done we will pass this encrypted data to the initTrans to initiate payment
     */
    
    private func encyptCardDetails(data: Data){
        guard let rsaKeytemp = String(bytes: data, encoding: String.Encoding.ascii) else{
            print("No value for rsaKeyTemp")
            return
        }
        rsaKey = rsaKeytemp
        rsaKey = self.rsaKey.trimmingCharacters(in: CharacterSet.newlines)
        rsaKey =  "-----BEGIN PUBLIC KEY-----\n\(self.rsaKey)\n-----END PUBLIC KEY-----\n"
        print("rsaKey :: ",rsaKey)
        
        let myRequestString = "amount=\(amount)&currency=\(currency)"
        
        do{
            let encodedData = try RSAUtils.encryptWithRSAPublicKey(str: myRequestString, pubkeyBase64: rsaKey)
            var encodedStr = encodedData?.base64EncodedString(options: [])
            let validCharSet = CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]").inverted
            encodedStr = encodedStr?.addingPercentEncoding(withAllowedCharacters: validCharSet)
            CCWebViewController.statusCode = 0
            
            //Preparing for webview call
            if CCWebViewController.statusCode == 0{
                CCWebViewController.statusCode = 1
                let urlAsString = transUrl
                let encryptedStr = "merchant_id=\(merchantId)&order_id=\(orderId)&redirect_url=\(redirectUrl)&cancel_url=\(cancelUrl)&enc_val=\(encodedStr!)&access_code=\(accessCode)"
                let myRequestData = encryptedStr.data(using: String.Encoding.utf8)
                
                request  = NSMutableURLRequest(url: URL(string: urlAsString)! as URL, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30)
                request?.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
                request?.setValue(urlAsString, forHTTPHeaderField: "Referer")
                request?.httpMethod = "POST"
                request?.httpBody = myRequestData
                self.viewWeb.loadRequest(self.request! as URLRequest)
            }
            else{
                print("Unable to create requestURL")
                displayAlert(msg: "Unable to create requestURL")
            }
        }
        catch let err {
            print(err)
        }
    }
    
    func displayAlert(msg: String){
        let alert: UIAlertController = UIAlertController(title: "ERROR", message: msg, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            UIAlertAction in
            LoadingOverlay.shared.hideOverlayView()
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK:
    //MARK: WebviewDelegate Methods
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("Failed to load  webview")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        LoadingOverlay.shared.hideOverlayView()
        
        //covert the response url to the string and check for that the response url contains the redirect/cancel url if true then chceck for the transaction status and pass the response to the result controller(ie. CCResultViewController)
        let string = (webView.request?.url?.absoluteString)!
        print("String :: \(string)")
        
        if(string.contains(redirectUrl)) //("http://122.182.6.216/merchant/ccavResponseHandler.jsp"))//
        {
            print(viewWeb.isLoading)
            guard let htmlTemp:NSString = webView.stringByEvaluatingJavaScript(from: "document.documentElement.outerHTML") as NSString? else{
                print("failed to evaluate javaScript")
                return
            }
            
            let html = htmlTemp
            print("html :: ",html)
            var transStatus = "Not Known"
            
            if ((html ).range(of: "tracking_id").location != NSNotFound) && ((html ).range(of: "bin_country").location != NSNotFound) {
                if ((html ).range(of: "Aborted").location != NSNotFound) || ((html ).range(of: "Cancel").location != NSNotFound) {
                    transStatus = "Transaction Cancelled"
                    let controller: CCResultViewController = CCResultViewController()
                    controller.transStatus = transStatus
                    self.present(controller, animated: true, completion: nil)
                }
                else if ((html ).range(of: "Success").location != NSNotFound) {
                    transStatus = "Transaction Successful"
                    let controller: CCResultViewController = CCResultViewController()
                    controller.transStatus = transStatus
                    self.present(controller, animated: true, completion: nil)
                }
                else if ((html ).range(of: "Fail").location != NSNotFound) {
                    transStatus = "Transaction Failed"
                    let controller: CCResultViewController = CCResultViewController()
                    controller.transStatus = transStatus
                    self.present(controller, animated: true, completion: nil)
                }
            }
            else{
                print("html does not contain any related data")
                displayAlert(msg: "html does not contain any related data for this transaction.")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

