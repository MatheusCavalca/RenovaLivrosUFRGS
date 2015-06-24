//
//  URLSabiParser.swift
//  RenovaLivrosUFRGS
//
//  Created by Matheus Cavalca on 6/17/15.
//  Copyright (c) 2015 Matheus Cavalca. All rights reserved.
//

import UIKit

class URLSabiParser: NSObject {
    
    static func getCorrectUrl(strReturned:String)->String{
        var fields = strReturned.componentsSeparatedByString("\n");
        for (index, element) in enumerate(fields) {
            if element.rangeOfString("action") != nil{
                var fieldsAction = element.componentsSeparatedByString("\"")
                return fieldsAction[1]
            }
        }
        return ""
    }

    static func getIdentificationFailure(strReturned:String)->Bool{
        var fields = strReturned.componentsSeparatedByString("\n")
        for (index, element) in enumerate(fields) {
            if element.rangeOfString("o ou senha incorreta") != nil{
                return true;
            }
        }
        return false;
    }
    
    static func getUrlRenewAll(strReturned:String)->String{
        var fields = strReturned.componentsSeparatedByString("\n")
        for (index, element) in enumerate(fields) {
            if element.rangeOfString("func=bor-loan-renew") != nil{
                var remPrefix = element.componentsSeparatedByString("href=\"")
                var remSufix = remPrefix[1].componentsSeparatedByString("\"")
                return remSufix[0]
            }
        }
        return "";
    }
    
    static func getBookTitles(strReturned:String)->NSMutableArray{
        var titleBooks = NSMutableArray()
        var fields = strReturned.componentsSeparatedByString("\n")
        for (index, element) in enumerate(fields) {
            if element.rangeOfString("titulo") != nil{
                var remPrefix = element.componentsSeparatedByString("td class=td1 valign=top>")
                var remSufix = remPrefix[1].componentsSeparatedByString("</td> <!--  titulo -->")
                titleBooks.addObject(remSufix[0])
            }
        }
        return titleBooks
    }
    
    static func getAuthors(strReturned:String)->NSMutableArray{
        var authorsBooks = NSMutableArray()
        var fields = strReturned.componentsSeparatedByString("\n")
        for (index, element) in enumerate(fields) {
            if element.rangeOfString("autor") != nil{
                var remPrefix = element.componentsSeparatedByString("<td class=td1 valign=top width=\"25%\">")
                var remSufix = remPrefix[1].componentsSeparatedByString("</td> <!-- autor --> ")
                authorsBooks.addObject(remSufix[0])
            }
        }
        return authorsBooks
    }

    static func getReturnDate(strReturned:String)->NSMutableArray{
        var returnDateBooks = NSMutableArray()
        var fields = strReturned.componentsSeparatedByString("\n")
        for (index, element) in enumerate(fields) {
            if element.rangeOfString("devolver em") != nil{
                var remPrefix = element.componentsSeparatedByString("<td class=td1 align=center width=\"15%\" valign=top>")
                var remSufix = remPrefix[1].componentsSeparatedByString("</td> <!-- devolver em --> ")
                returnDateBooks.addObject(remSufix[0])
            }
        }
        return returnDateBooks
    }

    static func getPenalties(strReturned:String)->NSMutableArray{
        var penaltyBooks = NSMutableArray()
        var fields = strReturned.componentsSeparatedByString("\n")
        for (index, element) in enumerate(fields) {
            if element.rangeOfString("multa") != nil{
                var remPrefix = element.componentsSeparatedByString("<td class=td1 style=\"text-align: right; padding-right: 5px;\" valign=top width=\"7%\">")
                var remSufix = remPrefix[1].componentsSeparatedByString("</td> <!-- multa -->")
                if(remSufix[0] == "<br>"){
                    penaltyBooks.addObject("Sem multa")
                }
                else{
                    penaltyBooks.addObject(remSufix[0])
                }
            }
        }
        return penaltyBooks
    }

    static func getBuilding(strReturned:String)->NSMutableArray{
        var buildings = NSMutableArray()
        var fields = strReturned.componentsSeparatedByString("\n")
        for (index, element) in enumerate(fields) {
            if element.rangeOfString("<!-- biblioteca") != nil{
                var remPrefix = element.componentsSeparatedByString("<td class=td1 valign=top width=\"10%\">")
                var remSufix = remPrefix[1].componentsSeparatedByString("</td> <!-- biblioteca --> ")
                buildings.addObject(remSufix[0])
            }
        }
        return buildings
    }
    
    static func getAllBooks(strReturned:String)->NSMutableArray{
        var books = NSMutableArray()
        
        var titles = self.getBookTitles(strReturned)
        var authors = self.getAuthors(strReturned)
        var returnDates = self.getReturnDate(strReturned)
        var penalties = self.getPenalties(strReturned)
        var buildings = self.getBuilding(strReturned)
        
        for var i=0; i<titles.count; i++ {
            let currentBook = Book(title: titles[i] as! String, author: authors[i] as! String, returnDate: returnDates[i] as! String, penalty: penalties[i] as! String, building: buildings[i] as! String)
            books.addObject(currentBook)
        }
        
//        let currentBook = Book(title:"Introdução ao direito civil",author:"Matheus Cavalca", returnDate: "15/06/2015", penalty: "R$2,99", building: "DIR")
//        books.addObject(currentBook)
        
        return books
    }
    
    static func getRenewOperationStatus(strReturned:String)->Bool{
        var buildings = NSMutableArray()
        var fields = strReturned.componentsSeparatedByString("\n")
        for (index, element) in enumerate(fields) {
            if element.rangeOfString("Empréstimo não pode ser renovado") != nil{
                return false;
            }
        }
        return true;
    }
    
}
