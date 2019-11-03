//
//  DetailsViewController.swift
//  MoviesDB
//
//  Created by Illia Khrypunov on 11/3/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
  //MARK: - Variables
  var film: Film?
  var startPosterPosition: CGPoint?
  var isScaled: Bool = false
  var wasAdded: Bool = false
  
  //MARK: - Outlets
  @IBOutlet private weak var ibNameLabel: UILabel!
  @IBOutlet private weak var ibFilmNameLabel: UILabel!
  @IBOutlet private weak var ibReleaseDateLabel: UILabel!
  @IBOutlet private weak var ibGenreNameLabel: UILabel!
  @IBOutlet private weak var ibFilmRateLabel: UILabel!
  @IBOutlet private weak var ibFilmPosterView: UIImageView!
  @IBOutlet private weak var ibFilmOverview: UITextView!
  @IBOutlet private weak var ibLabelParentView: UIView!
  @IBOutlet private weak var ibBlurView: UIView!
  @IBOutlet private weak var ibTrailerButton: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    styleUI()
    getFilmData()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)
    self.tabBarController?.tabBar.isHidden = false
  }
  
  //MARK: - Private funcs
  private func styleUI(){
    navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    navigationController?.navigationBar.tintColor = .white
    navigationController?.navigationBar.barStyle = .black
    ibLabelParentView.layer.cornerRadius = 10
    ibLabelParentView.layer.borderWidth = 1
    ibLabelParentView.layer.borderColor = UIColor(red: 251/255, green: 140/255, blue: 0, alpha: 1).cgColor
    ibBlurView.backgroundColor = .clear
    if getFilmGenreName().count == 0{
      ibTrailerButton.isHidden = true
    }
  }
  
  private func getFilmData(){
    ibFilmNameLabel.text = film?.name
    ibReleaseDateLabel.text = film?.releaseDate
    ibGenreNameLabel.text = "Genre"
    let voteAvarage = film!.voteAverage
    ibFilmRateLabel.text = String(voteAvarage)
    ibFilmOverview.text = film?.overview
    ibFilmPosterView.sd_setImage(with: film?.imageURL, completed: nil)
  }
  
  private func getFilmGenreName() -> String {
    var genresString = ""
    for genreId in film?.genresId ?? []{
      genresString += DataManager.instance.getGenreName(by: genreId) + "/"
    }
    return String(genresString.dropLast())
  }
  
  //MARK: - Action handlers
  @IBAction func watchTrailerPressed(_ sender: Any) {
    // TODO:
  }
}

//MARK: - Tap Gesture Handler
extension DetailsViewController{
  @objc func tapActionHandler(){
    // TODO:
  }
}

//MARK: - Bar button Handler
extension DetailsViewController{
  @objc func addToFavourites(sender: UIBarButtonItem){
    // TODO:
  }
}
