//
//  TabBarViewController.swift
//  MoviesDB
//
//  Created by student on 8/23/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.modalPresentationStyle = .fullScreen
    
    let moviesVC = UINavigationController(rootViewController: MovieDBViewController(nibName: "MovieDBViewController", bundle: nil))
    moviesVC.title = "MovieDB"
    moviesVC.tabBarItem = UITabBarItem(title: "Movies", image: #imageLiteral(resourceName: "listIcon"), tag: 0)
    moviesVC.modalPresentationStyle = .fullScreen
    
    let favouritesVC = UINavigationController(rootViewController: FavouritesViewController(nibName: "FavouritesViewController", bundle: nil))
    favouritesVC.title = "Favourites"
    favouritesVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
    favouritesVC.modalPresentationStyle = .fullScreen
    
    self.tabBar.barStyle = .black
    self.tabBar.isTranslucent = false
    self.tabBar.tintColor = #colorLiteral(red: 0.9843137255, green: 0.5490196078, blue: 0, alpha: 1)
    
    self.viewControllers = [moviesVC]
  }
  
}
