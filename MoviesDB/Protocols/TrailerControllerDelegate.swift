//
//  TrailerControllerDelegate.swift
//  MoviesDB
//
//  Created by Илья on 10/8/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation
protocol TrailerControllerDelegate: class {
    func didFinishGettingVideoKey(key: String)
}
