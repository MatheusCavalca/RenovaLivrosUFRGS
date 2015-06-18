//
//  RenewBooksViewController.swift
//  RenovaLivrosUFRGS
//
//  Created by Matheus Cavalca on 6/16/15.
//  Copyright (c) 2015 Matheus Cavalca. All rights reserved.
//

import UIKit

class RenewBooksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tvBookContent: UITableView!
    let heightForSectionsHeader = 50 as CGFloat
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tvBookContent.delegate = self
        self.tvBookContent.dataSource = self
        
        
        self.tvBookContent.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return 5
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
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
        label.font = UIFont(name: "Avenir-Book", size: 17)
        label.textColor =  UIColor(white: 0.5, alpha: 1.0)
        if section==0{
            label.text = "Retirados"
            customView.addSubview(label)
        }
        else{
            label.text = "Devolvidos"
            customView.addSubview(label)
        }
        
        return customView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellBookContent") as! BookContentTableViewCell
        cell.lblBookName.text = "Teste do livro nome"
        cell.lblBuilding.text = "DIR"
        cell.lblExpirationDate.text = "02/02/2000"
        cell.imgFlagSituation.image = UIImage(named: "flag_penalty")
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
