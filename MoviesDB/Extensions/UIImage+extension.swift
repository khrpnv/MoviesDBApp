//
//  UIImage+extension.swift
//  MoviesDB
//
//  Created by student on 8/27/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func toString() -> String {
        let data: Data? = self.pngData()
        guard let strBase64 = data?.base64EncodedString(options: .endLineWithLineFeed) else{
            fatalError("Error: Convert image to string failed")
        }
        return strBase64
    }
}
