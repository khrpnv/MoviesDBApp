//
//  UINavigationBar+extension.swift
//  MoviesDB
//
//  Created by student on 8/23/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
  
  func showBorderLine() {
    findBorderLine().isHidden = false
  }
  
  func hideBorderLine() {
    findBorderLine().isHidden = true
  }
  
  private func findBorderLine() -> UIImageView! {
    return self.subviews
      .flatMap { $0.subviews }
      .compactMap { $0 as? UIImageView }
      .filter { $0.bounds.size.width == self.bounds.size.width }
      .filter { $0.bounds.size.height <= 2 }
      .first
  }
}
