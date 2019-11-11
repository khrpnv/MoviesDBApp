//
//  TrailerViewController.swift
//  MoviesDB
//
//  Created by student on 8/29/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView
import PopupDialog

class TrailerViewController: UIViewController {
  
  var film: Film?
  
  @IBOutlet weak var ibTrailerPlayerView: WKYTPlayerView!
  @IBOutlet weak var ibActivityIndicator: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Trailer"
    getTrailerKey()
  }
  
  private func getTrailerKey(){
    let networkManager = NetworkManager()
    networkManager.trailerControllerDelegate = self
    guard let movie = film else { return }
    networkManager.getMovieTrailerKey(movieId: movie.filmId)
  }
}

//MARK: - TrailerControlelrDelegate
extension TrailerViewController: TrailerControllerDelegate{
  func trailerIsNotAvailable() {
    popUp()
  }
  
  func didFinishGettingVideoKey(key: String) {
    ibActivityIndicator.stopAnimating()
    ibTrailerPlayerView.load(withVideoId: key)
  }
}

// MARK: - PopUp
extension TrailerViewController {
  private func setupDarkModeToPopUp(){
    let pv = PopupDialogDefaultView.appearance()
    pv.titleFont    = UIFont(name: "HelveticaNeue-Light", size: 20)!
    pv.titleColor   = .white
    pv.messageFont  = UIFont(name: "HelveticaNeue", size: 17)!
    pv.messageColor = UIColor(white: 0.8, alpha: 1)
    pv.messageTextAlignment = .center
    
    let pcv = PopupDialogContainerView.appearance()
    pcv.backgroundColor = UIColor(red: 37/255, green: 37/255, blue: 37/255, alpha: 1.0)
    pcv.cornerRadius    = 10
    pcv.shadowEnabled   = true
    pcv.shadowColor     = .black
    
    let ov = PopupDialogOverlayView.appearance()
    ov.blurEnabled     = true
    ov.blurRadius      = 30
    ov.liveBlurEnabled = true
    ov.opacity         = 0.7
    ov.color           = .black
    
    let cb = DefaultButton.appearance()
    cb.titleFont      = UIFont(name: "HelveticaNeue-Medium", size: 14)!
    cb.titleColor     = UIColor(white: 0.6, alpha: 1)
    cb.buttonColor    = UIColor(red: 37/255, green: 37/255, blue: 37/255, alpha: 1.0)
    cb.separatorColor = UIColor(red: 251/255, green: 140/255, blue: 0, alpha: 1)
  }
  
  private func popUp(){
    setupDarkModeToPopUp()
    let title = "Oops!"
    let message = "Trailer is not available for the movie."
    let popup = PopupDialog(title: title, message: message)
    let buttonOne = DefaultButton(title: "Back") { [weak self] in
      self?.navigationController?.popViewController(animated: true)
    }
    popup.addButtons([buttonOne])
    self.present(popup, animated: true, completion: nil)
  }
}
