//
//  DataManager.swift
//  MoviesDB
//
//  Created by Илья on 10/9/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation

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
  private weak var favouritesControllerDelegate: FavouritesViewControllerDelegate?
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
  
  func setFavouritesControllerDelegate(delegate: FavouritesViewControllerDelegate){
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
}
