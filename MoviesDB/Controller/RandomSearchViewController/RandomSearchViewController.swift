//
//  DiscoverViewController.swift
//  MoviesDB
//
//  Created by student on 8/23/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import SDWebImage
import Koloda

class RandomSearchViewController: UIViewController {
  
  @IBOutlet private weak var ibIgnoreButton: UIButton!
  @IBOutlet private weak var kolodaView: KolodaView!
  @IBOutlet private weak var ibAddButton: UIButton!
  
  private var dataSource: [Film] = []
  private var wasReloaded: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    styleUI()
    setupDelegates()
    dataSource = DataManager.instance.getRandomFilmsArray()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    self.title = "Random"
    if !wasReloaded{
      kolodaView.reloadData()
      wasReloaded = true
    }
  }
  
  //MARK: - Private funcs
  private func styleUI(){
    ibIgnoreButton.roundedBorders()
    ibAddButton.roundedBorders()
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    navigationController?.navigationBar.tintColor = .white
    navigationController?.navigationBar.barStyle = .black
    self.title = "Random"
  }
  
  private func setupDelegates(){
    kolodaView.delegate = self
    kolodaView.dataSource = self
  }
  
  private func setupDataSource(){
    dataSource = DataManager.instance.getRandomFilmsArray()
    kolodaView.reloadData()
  }
  
  //MARK: - Action handlers
  @IBAction func addButtonPressed(_ sender: Any) {
    kolodaView.swipe(.right)
  }
  
  @IBAction func ignoreButtonPressed(_ sender: Any) {
    kolodaView.swipe(.left)
  }
}

//MARK: - KolodaViewDelegate, KolodaViewDataSource
extension RandomSearchViewController: KolodaViewDelegate, KolodaViewDataSource{
  
  func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
    let position = kolodaView.currentCardIndex
    for _ in 1...10 {
      dataSource.append(DataManager.instance.getRandomFilm())
    }
    kolodaView.insertCardAtIndexRange(position..<position + 10, animated: true)
  }
  
  func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
    return dataSource.count
  }
  
  func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
    let view = CustomCardView()
    let randomFilm = dataSource[index]
    view.update(imageURL: randomFilm.imageURL, title: randomFilm.name)
    view.layer.cornerRadius = 20
    view.layer.borderWidth = 1
    view.layer.borderColor = UIColor(red: 251/255, green: 140/255, blue: 0, alpha: 1).cgColor
    view.clipsToBounds = true
    return view
  }
  
  func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
    return false
  }
  
  func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
    if direction == .right{
      DataManager.instance.addFilm(movie: dataSource[index])
    } else {
      return
    }
  }
  
  func koloda(_ koloda: KolodaView, draggedCardWithPercentage finishPercentage: CGFloat, in direction: SwipeResultDirection) {
    if direction == .up{
      return
    }
  }
  
  func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
    let film = dataSource[index]
    let detailsVC = DetailsViewController(nibName: "DetailsViewController", bundle: nil)
    detailsVC.film = film
    self.navigationController?.pushViewController(detailsVC, animated: true)
  }
}
