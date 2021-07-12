import Flutter
import UIKit

class CcAvenueViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
}

class FLNativeView: NSObject, FlutterPlatformView, UIWebViewDelegate {
    private var _view: UIView
    var args: NSDictionary?
    //
    var request: NSMutableURLRequest?
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
    //
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView()
        super.init()
        self.args = args as? NSDictionary
        createNativeView(view: _view)
    }
    
    func view() -> UIView {
        return _view
    }
    
    func createNativeView(view _view: UIView){
        let arguments = args as? Dictionary<String, Any>
        let transUrlarg = arguments?["transUrl"] as? String
        let rsaKeyUrlarg = arguments?["rsaKeyUrl"] as? String
        let accessCodearg = arguments?["accessCode"] as? String
        let merchantIdarg = arguments?["merchantId"] as? String
        let orderIdarg = arguments?["orderId"] as? String
        let currencyTypearg = arguments?["currencyType"] as? String
        let amountarg = arguments?["amount"] as? String
        let cancelUrlarg = arguments?["cancelUrl"] as? String
        let redirectUrlarg = arguments?["redirectUrl"] as? String
        let width = arguments?["width"] as? String
        let height = arguments?["height"] as? String
        transUrl = (transUrlarg)!
        rsaKeyUrl = (rsaKeyUrlarg)!
        accessCode = (accessCodearg)!
        merchantId = (merchantIdarg)!
        orderId = (orderIdarg)!
        currency = (currencyTypearg)!
        amount = (amountarg)!
        cancelUrl = (cancelUrlarg)!
        redirectUrl = (redirectUrlarg)!
        
        NSLog(transUrl)
        
        let widthInt = Int(width!)
        let heightInt = Int(height!)
        
        let viewWeb: UIWebView = {
                    let webView = UIWebView()
                    webView.backgroundColor = .white
                    webView.translatesAutoresizingMaskIntoConstraints = false
                    webView.delegate = self
                    webView.scalesPageToFit = true
                    webView.contentMode = UIView.ContentMode.scaleAspectFill
            webView.frame = CGRect(x: 0, y: 0, width: widthInt!, height: heightInt!)
                    webView.tag = 1011
                    return webView
                }()
        
        setupWebView(view: _view, viewWeb: viewWeb)
        gettingRsaKey(){
                        (success, object) -> () in
                        DispatchQueue.main.sync {
                            if success {
                                self.encyptCardDetails(data: object as! Data, viewWeb: viewWeb)
                            }
                            else{
                                NSLog("Hello Here is the ERRor in RSAkey")
                            }
                        }
        }

    }
    
     func gettingRsaKey(completion: @escaping (_ success: Bool, _ object: AnyObject?) -> ()){
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
        
    func encyptCardDetails(data: Data, viewWeb:UIWebView){
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
                    viewWeb.loadRequest(self.request! as URLRequest)
                }
                else{
                    print("Unable to create requestURL")
                   // displayAlert(msg: "Unable to create requestURL")
                }
            }
            catch let err {
                print(err)
            }
        }
    func setupWebView(view: UIView, viewWeb:UIWebView){
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
           
    }


