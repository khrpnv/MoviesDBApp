//
//  DataManager.swift
//  MoviesDB
//
//  Created by student on 8/23/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation
import UIKit

final class DataManager{
  static let instance = DataManager()
  
  //MARK: - Storage arrays
  private var popularFilms: [Film] = []
  private var topRatedFilms: [Film] = []
  private var upcomingFilms: [Film] = []
  private var favourites: [Film] = []
  private var genres: [Genre] = []
  
  //MARK: - Page Counters
  private var popularPageCounter: Int = 2
  private var topRatedPageCounter: Int = 2
  private var upcomingPageCounter: Int = 2
  
  //MARK: - Delegates
  private weak var favouritesControllerDelegate: FavouritesControllerDelegate?
  private init(){}
  
  //MARK: - Setters
  private func setPopularFilmsArray(array: [Film], isInitial: Bool){
    if isInitial{
      popularFilms = array
    } else {
      popularFilms.append(contentsOf: array)
    }
  }
  
  private func setTopRatedFilmsArray(array: [Film], isInitial: Bool){
    if isInitial{
      topRatedFilms = array
    } else {
      topRatedFilms.append(contentsOf: array)
    }
  }
  
  private func setUpcomingFilmsArray(array: [Film], isInitial: Bool){
    if isInitial{
      upcomingFilms = array
    } else {
      upcomingFilms.append(contentsOf: array)
    }
  }
  
  func setDataArray(array: [Film], isInitial: Bool, list: ListType){
    switch list {
    case .popular:
      setPopularFilmsArray(array: array, isInitial: isInitial)
    case .topRated:
      setTopRatedFilmsArray(array: array, isInitial: isInitial)
    case .upcoming:
      setUpcomingFilmsArray(array: array, isInitial: isInitial)
    }
  }
  
  func setFavouriteFilmsArray(array: [Film]){
    favourites = array
  }
  
  func setFavouritesControllerDelegate(delegate: FavouritesControllerDelegate){
    favouritesControllerDelegate = delegate
  }
  
  func setPageCounter(list: ListType){
    switch list {
    case .popular:
      popularPageCounter += 1
    case .topRated:
      topRatedPageCounter += 1
    case .upcoming:
      upcomingPageCounter += 1
    }
  }
  
  func initGenresArray(array: [Genre]){
    let genresFromDB = DatabaseManager.instance.getGenres()
    if genresFromDB.count == 0{
      for genre in array{
        DatabaseManager.instance.addGenre(genre: genre)
        genres.append(genre)
      }
    } else {
      genres = genresFromDB
    }
  }
  
  //MARK: - Getters
  func getFilmsArray(list: ListType) -> [Film]{
    switch list {
    case .popular:
      return popularFilms
    case .topRated:
      return topRatedFilms
    case .upcoming:
      return upcomingFilms
    }
  }
  
  func getFavouriteFilms() -> [Film]{
    return favourites
  }
  
  func getGenresArray() -> [Genre]{
    return genres
  }
  
  func getPageCounter(list: ListType) -> Int{
    switch list {
    case .popular:
      return popularPageCounter
    case .topRated:
      return topRatedPageCounter
    case .upcoming:
      return upcomingPageCounter
    }
  }
  
  //MARK: - Helpers
  func indexOf(film movie: Film) -> Int{
    for index in 0..<favourites.count{
      if favourites[index].name == movie.name && favourites[index].releaseDate == movie.releaseDate{
        return index
      }
    }
    return -1
  }
  
  func getGenreName(by id: Int) -> String{
    for genre in genres{
      if genre.id == id{
        return genre.name
      }
    }
    return ""
  }
  
  //MARK: - Funcs to control favourites list
  func addFilm(movie film: Film){
    if indexOf(film: film) < 0{
      favourites.append(film)
      DatabaseManager.instance.addFilm(film: film)
      favouritesControllerDelegate?.didAddFilm()
    }
  }
  
  func removeFilm(movie film: Film){
    let index = indexOf(film: film)
    if index >= 0{
      favourites.remove(at: index)
      DatabaseManager.instance.removeFilm(film: film)
    } else {
      return
    }
  }
  
  //MARK: - Random film generator
  private func getRandomFilm(from array: [Film]) -> Film{
    let index = Int.random(in: 0..<array.count)
    return array[index]
  }
  
  func getRandomFilm() -> Film{
    let arrayIndex = Int.random(in: 0..<3)
    switch arrayIndex {
    case 0:
      return getRandomFilm(from: popularFilms)
    case 1:
      return getRandomFilm(from: topRatedFilms)
    case 2:
      return getRandomFilm(from: upcomingFilms)
    default:
      fatalError("Error: arrayIndex is out of range")
    }
  }
  
  func getRandomFilmsArray() -> [Film]{
    var array: [Film] = []
    for _ in 0..<10{
      array.append(getRandomFilm())
    }
    return array
  }
}
