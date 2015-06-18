//
//  ViewController.swift
//  RenovaLivrosUFRGS
//
//  Created by Matheus Cavalca on 6/16/15.
//  Copyright (c) 2015 Matheus Cavalca. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var txtUser: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var btEnter: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btEnter_TouchUpInside(sender: AnyObject) {
        
    }
    
    func corrigeZero(){
        let strUser = self.txtUser.text as String
        if count(strUser) < 7 {
            for (var i = count(strUser); i<8; i++) {
                var newText = "0" + self.txtUser.text
                self.txtUser.text = newText
            }
        }
    }
}