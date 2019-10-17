//
//  SplashViewController.swift
//  MoviesDB
//
//  Created by student on 8/27/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let networkManager = NetworkManager()
    networkManager.splashScreenDelegate = self
    networkManager.getFilmData(requsetString: "popular", listType: .popular, isInitial: true, page: 1)
    networkManager.getFilmData(requsetString: "top_rated", listType: .topRated, isInitial: true, page: 1)
    networkManager.getFilmData(requsetString: "upcoming", listType: .upcoming, isInitial: true, page: 1)
  }
}

//MARK: - SplashScreenDelegate
extension SplashViewController: SplashScreenDelegate{
  func didFinishDownloadingGenres(array: [Genre]) {
  }
  
  func didFinishDownloadingData(array: [Film], list: ListType) {
    DataManager.instance.setDataArray(array: array, isInitial: true, list: list)
    if list == .upcoming{
      self.dismiss(animated: true, completion: nil)
      self.present(TabBarViewController(), animated: true, completion: nil)
    }
  }
}
