//
//  UIButton+extension.swift
//  MoviesDB
//
//  Created by student on 8/23/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
    func roundedBorders(){
        self.layer.cornerRadius = 15
    }
    
    func selectedButton(title:String, iconName: String){
        self.backgroundColor = UIColor(red: 251/255, green: 140/255, blue: 0, alpha: 1)
        self.setTitle(title, for: .normal)
        self.setTitle(title, for: .highlighted)
        self.setTitleColor(UIColor.white, for: .normal)
        self.setTitleColor(UIColor.white, for: .highlighted)
        self.setImage(UIImage(named: iconName), for: .normal)
        self.setImage(UIImage(named: iconName), for: .highlighted)
        self.layoutIfNeeded()
    }
}
