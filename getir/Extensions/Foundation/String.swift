//
//  String+Extensions.swift
//  getir
//
//  Created by omer kantar on 17.02.2018.
//  Copyright © 2018 cool. All rights reserved.
//
import UIKit

extension String {
    var imageURL: URL? {
        return URL(string: self)
    }
    
    var dateText: String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: self) {
            return date.string
        }
        return ""
    }
}
