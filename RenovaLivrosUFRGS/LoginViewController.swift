//
//  ViewController.swift
//  RenovaLivrosUFRGS
//
//  Created by Matheus Cavalca on 6/16/15.
//  Copyright (c) 2015 Matheus Cavalca. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var imgLogoUFRGS: UIImageView!
    @IBOutlet var txtUser: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var btEnter: UIButton!
    @IBOutlet var lblFailureOperation: UILabel!
    
    var arrayBooks = NSArray()
    var urlRenewBooks:String!
    var showingKeyboard = false
    var loadingIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 37, 37)) as UIActivityIndicatorView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        let hasLogin = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
        if hasLogin {
            let MyKeychainWrapper = KeychainWrapper()
            let strPassword = MyKeychainWrapper.myObjectForKey("v_Data") as! String
            self.txtUser.text = NSUserDefaults.standardUserDefaults().objectForKey("username") as! String
            self.txtPassword.text = strPassword
        }
    }
    
    @IBAction func btEnter_TouchUpInside(sender: AnyObject) {
        self.fixZeros()
        
        self.presentActivityIndicator(sender, disableScreen: true)
        self.lblFailureOperation.hidden = true
        Alamofire.request(.GET, "http://sabi.ufrgs.br/F?func=bor-loan&adm_library=URS50").responseString(encoding: NSUTF8StringEncoding) { (_, _, strResponse, error) in
            var strUrl = String()
            if (strResponse != nil) {
                strUrl = URLSabiParser.getCorrectUrl(strResponse!)
            }
            if(strUrl=="" || error != nil){
                self.lblFailureOperation.text = "OCORREU UMA FALHA, TENTE NOVAMENTE MAIS TARDE"
                self.lblFailureOperation.hidden = false
                self.dismissActivityIndicator(sender, viewTitle: "Entrar")
                return
            }
            var dicParameters = ["ssl_flag": "Y", "func": "login_session","login_source":"bor_loan","bor_library":"URS50","bor_id":self.txtUser.text,"bor_verification":self.txtPassword.text];
            
            Alamofire.request(.POST, strUrl, parameters: dicParameters).responseString(encoding: NSUTF8StringEncoding) { (_, _, strData, error) in
                if(error != nil){
                    self.lblFailureOperation.text = "OCORREU UMA FALHA, TENTE NOVAMENTE MAIS TARDE"
                    self.lblFailureOperation.hidden = false
                }
                else if(URLSabiParser.getIdentificationFailure(strData!)){
                    self.lblFailureOperation.text = "IDENTIFICAÇÃO OU SENHA INCORRETA"
                    self.lblFailureOperation.hidden = false
                }
                else{
                    //get all books for the next view controller
                    self.arrayBooks = URLSabiParser.getAllBooks(strData!)
                    self.urlRenewBooks = URLSabiParser.getUrlRenewAll(strData!)
                    
                    NSUserDefaults.standardUserDefaults().setValue(self.txtUser.text, forKey: "username")
                    let MyKeychainWrapper = KeychainWrapper()
                    MyKeychainWrapper.mySetObject(self.txtPassword.text, forKey:kSecValueData)
                    MyKeychainWrapper.writeToKeychain()
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasLoginKey")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    self.performSegueWithIdentifier("segueRenewBooks", sender: self)
                }
                
                self.dismissActivityIndicator(sender, viewTitle: "Entrar")
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyboardWillShow(sender: NSNotification) {
        if(!showingKeyboard){
            self.view.frame.origin.y -= 210
            self.imgLogoUFRGS.hidden = true
            showingKeyboard = true
        }
    }
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 210
        self.imgLogoUFRGS.hidden = false
        showingKeyboard = false
    }
    
    func fixZeros(){
        let strUser = self.txtUser.text as String
        if count(strUser) < 7 {
            for (var i = count(strUser); i<8; i++) {
                var newText = "0" + self.txtUser.text
                self.txtUser.text = newText
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "segueRenewBooks") {
            var nextViewController = (segue.destinationViewController as! RenewBooksViewController)
            nextViewController.arrayBooks = self.arrayBooks
            nextViewController.urlRenewBooks = self.urlRenewBooks
        }
    }
    
    func presentActivityIndicator(desiredView: AnyObject?, disableScreen:Bool){
        if desiredView!.isKindOfClass(UIButton) {
            (desiredView as! UIButton).setTitle("", forState: UIControlState.Normal)
        }
        
        loadingIndicator.center = desiredView!.center;
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        loadingIndicator.startAnimating()
        self.view.addSubview(loadingIndicator)
        
        self.view.userInteractionEnabled = disableScreen
    }
    
    func dismissActivityIndicator(desiredView: AnyObject?, viewTitle:String?){
        if desiredView!.isKindOfClass(UIButton) {
            (desiredView as! UIButton).setTitle(viewTitle, forState: UIControlState.Normal)
        }
        self.view.userInteractionEnabled = true
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
    }
}