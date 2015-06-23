//
//  Book.swift
//  RenovaLivrosUFRGS
//
//  Created by Matheus Cavalca on 6/18/15.
//  Copyright (c) 2015 Matheus Cavalca. All rights reserved.
//

import UIKit

class Book: NSObject {
    var title:String
    var author:String
    var returnDate:NSDate
    var penalty:String
    var building:String
    
    init(title : String, author : String, returnDate : String, penalty : String, building : String) {
        self.title = title
        self.author = author
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.dateFromString(returnDate)
        self.returnDate = date!
        
        self.penalty = penalty
        self.building = building
    }
    
}
