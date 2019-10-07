//
//  MoviesControllerDelegate.swift
//  MoviesDB
//
//  Created by student on 8/29/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation

protocol MoviesControllerDelegate: class {
    func didFinishDownloading(array: [Film])
}
