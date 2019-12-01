//
//  FavouritesViewController.swift
//  MoviesDB
//
//  Created by Illia Khrypunov on 11/23/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import Toast_Swift

class FavouritesViewController: UIViewController {
  
  @IBOutlet private weak var tableView: UITableView!
  private var dataSource: [Film] = []{
    didSet{
      tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupDelegates()
    setupTableView()
    setupDataSource()
    styleUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    styleUI()
  }
  
  //MARK: - Private funcs
  private func styleUI(){
    self.title = "Favourites"
    if dataSource.count == 0{
      tableView.isHidden = true
    } else {
      tableView.isHidden = false
    }
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    navigationController?.navigationBar.tintColor = .white
    navigationController?.navigationBar.barStyle = .black
  }
  
  private func setupTableView(){
    let nib = UINib(nibName: "MovieTableViewCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: "MovieCell")
  }
  
  private func setupDelegates(){
    tableView.delegate = self
    tableView.dataSource = self
    DataManager.instance.setFavouritesControllerDelegate(delegate: self)
  }
  
  private func setupDataSource(){
    dataSource = DataManager.instance.getFavouriteFilms()
  }
  
  private func showToast() {
    var style = ToastStyle()
    style.messageColor = .white
    style.backgroundColor = .black
    style.messageAlignment = .center
    self.view.makeToast("Movie has been removed from your favourites list.", duration: 3.0, position: .bottom, style: style)
    ToastManager.shared.isTapToDismissEnabled = true
  }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieTableViewCell else {
      fatalError("Error: no such cell")
    }
    let film = dataSource[indexPath.row]
    cell.update(name: film.name, date: film.releaseDate, genreIds: film.genresId, imageURL: film.imageURL, averageVote: film.voteAverage)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
  }
  
  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let removeFilmAction = UITableViewRowAction(style: .normal, title: "Remove") { [weak self](action, indexPath) in
      guard let film = self?.dataSource[indexPath.row] else {
        fatalError("Erro: no such film")
      }
      DataManager.instance.removeFilm(movie: film)
      self?.showToast()
      self?.setupDataSource()
    }
    removeFilmAction.backgroundColor = .red
    return [removeFilmAction]
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let film = dataSource[indexPath.row]
    let detailsVC = DetailsViewController(nibName: "DetailsViewController", bundle: nil)
    detailsVC.film = film
    self.navigationController?.pushViewController(detailsVC, animated: true)
  }
}

//MARK: - FavouritesViewControllerDelegate
extension FavouritesViewController: FavouritesControllerDelegate{
  func didAddFilm() {
    setupDataSource()
  }
}
