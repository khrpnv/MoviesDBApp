//
//  TrailerControllerDelegate.swift
//  MoviesDB
//
//  Created by student on 8/29/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation
protocol TrailerControllerDelegate: class {
  func didFinishGettingVideoKey(key: String)
  func trailerIsNotAvailable()
}
