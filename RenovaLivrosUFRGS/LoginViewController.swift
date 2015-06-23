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
        
        self.lblFailureOperation.hidden = true
        Alamofire.request(.GET, "http://sabi.ufrgs.br/F?func=bor-loan&adm_library=URS50").responseString(encoding: NSUTF8StringEncoding) { (_, _, strReponse, error) in
            var strUrl = URLSabiParser.getCorrectUrl(strReponse!)
            if(strUrl==""){
                self.lblFailureOperation.text = "OCORREU UMA FALHA, TENTE NOVAMENTE MAIS TARDE"
                self.lblFailureOperation.hidden = false
                return
            }
            var dicParameters = ["ssl_flag": "Y", "func": "login_session","login_source":"bor_loan","bor_library":"URS50","bor_id":self.txtUser.text,"bor_verification":self.txtPassword.text];
            Alamofire.request(.POST, strUrl, parameters: dicParameters).responseString(encoding: NSUTF8StringEncoding) { (_, _, strData, error) in
                if(URLSabiParser.getIdentificationFailure(strData!)){
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
}