//
//  RenewBooksViewController.swift
//  RenovaLivrosUFRGS
//
//  Created by Matheus Cavalca on 6/16/15.
//  Copyright (c) 2015 Matheus Cavalca. All rights reserved.
//

import UIKit
import Alamofire

class RenewBooksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tvBookContent: UITableView!
    @IBOutlet var btLogout: UIButton!
    @IBOutlet var btRefresh: UIButton!
    @IBOutlet var btRenew: UIButton!
    @IBOutlet var viewMenuButtons: UIView!
    
    let heightForSectionsHeader = 50 as CGFloat
    var arrayBooks = NSArray()
    var urlRenewBooks:String!
    
    var loadingIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 37, 37)) as UIActivityIndicatorView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tvBookContent.delegate = self
        self.tvBookContent.dataSource = self
        
        
        self.tvBookContent.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return arrayBooks.count
//        return 10
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if arrayBooks.count > 0 {
            return 1
        }
        else{
            let labelSize = 20 as CGFloat
            var label = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            label.textAlignment = NSTextAlignment.Center
            label.font = UIFont(name: "Avenir-Book", size: 14)
            label.textColor =  UIColor(white: 0.8, alpha: 1.0)
            label.text = "NENHUM LIVRO ENCONTRADO"
            label.sizeToFit()
            self.tvBookContent.backgroundView = label
            return 0;
        }
       }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForSectionsHeader
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let imageName = "flag_returned"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width/64, height: 50)
        
        var customView = UIView()
        customView.addSubview(imageView)
        customView.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
        
        let labelSize = 20 as CGFloat
        var label = UILabel(frame: CGRectMake(self.view.frame.size.width/12, heightForSectionsHeader/2-labelSize/2, 200, labelSize))
        label.textAlignment = NSTextAlignment.Left
        label.font = UIFont(name: "Avenir-Book", size: 14)
        label.textColor =  UIColor(white: 0.5, alpha: 1.0)
        label.text = "RETIRADOS"
        customView.addSubview(label)
    
        return customView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellBookContent") as! BookContentTableViewCell

        cell.lblBookName.text = (self.arrayBooks[indexPath.row] as! Book).title
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        var returnDate = (self.arrayBooks[indexPath.row] as! Book).returnDate
        cell.lblExpirationDate.text = dateFormatter.stringFromDate(returnDate)
        cell.lblBuilding.text = (self.arrayBooks[indexPath.row] as! Book).building
        
        let bookPenalty = (self.arrayBooks[indexPath.row] as! Book).penalty
        if bookPenalty == "Sem multa" {
            cell.lblPenalty.hidden = true
        }
        else {
            cell.lblPenalty.text = (self.arrayBooks[indexPath.row] as! Book).penalty
        }
        
        let currentDate = NSDate()
        //ADD one day to get correct approach when user has to return book in the same day as currentDate(Today)
        returnDate = returnDate.dateByAddingTimeInterval(60*60*24)
        var dateComparisionResult:NSComparisonResult = returnDate.compare(currentDate)
        if dateComparisionResult == NSComparisonResult.OrderedAscending {
            cell.imgFlagSituation.image = UIImage(named: "flag_penalty")
        }
        else{
            cell.imgFlagSituation.image = UIImage(named: "flag_onTime")
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    @IBAction func btLogout_TouchUpInside(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btRefresh_TouchUpInside(sender: AnyObject) {
        self.presentActivityIndicator(sender, disableScreen: true)
        self.refreshBooks(sender)
    }
    
    @IBAction func btRenew_TouchUpInside(sender: AnyObject) {
        if arrayBooks.count > 0 {
            self.presentActivityIndicator(sender, disableScreen: true)
            Alamofire.request(.GET, self.urlRenewBooks).responseString(encoding: NSUTF8StringEncoding) { (_, _, strReponse, error) in
                if error == nil {
                    //get all books for the next view controller
                    if !URLSabiParser.getRenewOperationStatus(strReponse!) {
                        //pelo menos um deu problema
                        var alert = UIAlertController(title: "Renovação parcial", message: "Ao menos um livro não pode ser renovado.", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    self.refreshBooks(self.btRefresh)
                }
                else {
                    var alert = UIAlertController(title: "Ocorreu uma falha", message: "Tente novamente mais tarde", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                self.dismissActivityIndicator(sender, viewTitle: "RENOVAR TODOS")
            }
        }
    }
    
    func presentActivityIndicator(desiredView: AnyObject?, disableScreen:Bool){
        if desiredView!.isKindOfClass(UIButton) {
            (desiredView as! UIButton).setTitle("", forState: UIControlState.Normal)
            (desiredView as! UIButton).alpha = 0.0
        }
        
        loadingIndicator.center = desiredView!.center;
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating()
        self.viewMenuButtons.addSubview(loadingIndicator)
        self.view.userInteractionEnabled = !disableScreen
    }
    
    func dismissActivityIndicator(desiredView: AnyObject?, viewTitle:String?){
        if desiredView!.isKindOfClass(UIButton) {
            (desiredView as! UIButton).setTitle(viewTitle, forState: UIControlState.Normal)
            (desiredView as! UIButton).alpha = 1
        }
        self.view.userInteractionEnabled = true
        loadingIndicator.stopAnimating()
        loadingIndicator.removeFromSuperview()
    }
    
    func refreshBooks(sender: AnyObject){
        let hasLogin = NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey")
        var strUser:String!
        var strPassword:String!
        
        if hasLogin {
            let MyKeychainWrapper = KeychainWrapper()
            strPassword = MyKeychainWrapper.myObjectForKey("v_Data") as! String
            strUser = NSUserDefaults.standardUserDefaults().objectForKey("username") as! String
            
            Alamofire.request(.GET, "http://sabi.ufrgs.br/F?func=bor-loan&adm_library=URS50").responseString(encoding: NSUTF8StringEncoding) { (_, _, strResponse, error) in
                var strUrl = ""
                if (strResponse != nil) {
                    strUrl = URLSabiParser.getCorrectUrl(strResponse!)
                }
                if(strUrl=="" || error != nil){
                    var alert = UIAlertController(title: "Ocorreu uma falha", message: "Tente novamente mais tarde", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    self.dismissActivityIndicator(sender, viewTitle: "ATUALIZAR")
                    return
                }
                var dicParameters = ["ssl_flag": "Y", "func": "login_session","login_source":"bor_loan","bor_library":"URS50","bor_id":strUser,"bor_verification":strPassword];
                Alamofire.request(.POST, strUrl, parameters: dicParameters).responseString(encoding: NSUTF8StringEncoding) { (_, _, strData, error) in
                    if(error != nil){
                        var alert = UIAlertController(title: "Ocorreu uma falha", message: "Tente novamente mais tarde", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                        self.dismissActivityIndicator(sender, viewTitle: "ATUALIZAR")
                    }
                    else if(URLSabiParser.getIdentificationFailure(strData!)){
                        var alert = UIAlertController(title: "Ocorreu uma falha", message: "Não foi possível validar a identificação.", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                        self.dismissActivityIndicator(sender, viewTitle: "ATUALIZAR")
                        self.btLogout_TouchUpInside(self.btLogout)
                    }
                    else{
                        //get all books for the next view controller
                        self.arrayBooks = URLSabiParser.getAllBooks(strData!)
                        self.urlRenewBooks = URLSabiParser.getUrlRenewAll(strData!)
                        self.tvBookContent.reloadData()
                        self.dismissActivityIndicator(sender, viewTitle: "ATUALIZAR")
                    }
                }
            }
        }
    }

}
