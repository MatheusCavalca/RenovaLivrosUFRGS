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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "CellBookContent")
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
