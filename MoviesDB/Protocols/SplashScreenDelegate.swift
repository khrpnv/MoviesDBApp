//
//  LaunchScreenDelegate.swift
//  MoviesDB
//
//  Created by student on 8/27/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation

protocol SplashScreenDelegate: class {
    func didFinishDownloadingData(array: [Film], list: ListType)
    func didFinishDownloadingGenres(array: [Genre])
}
