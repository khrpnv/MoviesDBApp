//
//  DatabaseManager.swift
//  MoviesDB
//
//  Created by Illia Khrypunov on 12/1/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation
import SQLite
import UIKit

final class DatabaseManager {
  static let instance = DatabaseManager()
  private var dataBase: Connection?
  
  //MARK: - Tables
  private let filmsTable = Table("Films")
  private let genresTable = Table("Genres")
  
  
  //MARK: - Genres table columns
  private let genreId = Expression<Int>("id")
  private let genreName = Expression<String>("name")
  
  //MARK: - Films table columns
  private let filmId = Expression<String>("id")
  private let title = Expression<String>("title")
  private let voteAverage = Expression<Double>("voteAverage")
  private let overview = Expression<String>("overview")
  private let releaseDate = Expression<String>("releaseDate")
  private let encodedImage = Expression<String>("image")
  private let genresId = Expression<String>("genresId")
  private let movieId = Expression<Int>("movieId")
  
  private init(){}
  
  //MARK: - Database control functions
  func openDatabase(){
    let path = NSSearchPathForDirectoriesInDomains( .documentDirectory, .userDomainMask, true).first!
    do {
      dataBase = try Connection("\(path)/Films.sqlite3")
    } catch {
      dataBase = nil
      print ("Unable to open database")
    }
  }
  
  func createTables(){
    do {
      try dataBase!.run(filmsTable.create(ifNotExists: true) { table in
        table.column(filmId, primaryKey: true)
        table.column(title)
        table.column(voteAverage)
        table.column(overview)
        table.column(releaseDate)
        table.column(encodedImage)
        table.column(genresId)
        table.column(movieId)
      })
      try dataBase!.run(genresTable.create(ifNotExists: true) { table in
        table.column(genreId, primaryKey: true)
        table.column(genreName)
      })
    } catch {
      print("Unable to create table")
    }
  }
  
  //MARK: - CRUD functions
  func removeFilm(film: Film){
    do {
      let film = filmsTable.filter(self.filmId == film.id)
      try dataBase!.run(film.delete())
    } catch {
      print("Delete failed")
    }
  }
  
  func addFilm(film: Film){
    do {
      let insert = filmsTable.insert(
        self.filmId <- film.id,
        self.title <- film.name,
        self.voteAverage <- film.voteAverage,
        self.overview <- film.overview,
        self.releaseDate <- film.releaseDate,
        self.encodedImage <- film.imageURL.absoluteString,
        self.genresId <- film.genresToString(),
        self.movieId <- film.filmId
      )
      try dataBase!.run(insert)
    } catch {
      print("Insert failed")
    }
  }
  
  func addGenre(genre: Genre){
    do {
      let insert = genresTable.insert(self.genreId <- genre.id, self.genreName <- genre.name)
      try dataBase!.run(insert)
    } catch {
      print("Insert failed")
    }
  }
  
  func getGenres() -> [Genre]{
    var genres: [Genre] = []
    do {
      for genre in try dataBase!.prepare(self.genresTable) {
        genres.append(Genre(id: genre[genreId], name: genre[genreName]))
      }
    } catch {
      print("Selection failed")
    }
    return genres
  }
  
  func getFilms() -> [Film]{
    var films: [Film] = []
    do{
      for filmData in try dataBase!.prepare(self.filmsTable){
        let filmImageURL = URL(string: filmData[encodedImage])!
        let film = Film(name: filmData[title],
                        imageURL: filmImageURL,
                        voteAverage: filmData[voteAverage],
                        overview: filmData[overview],
                        releaseDate: filmData[releaseDate],
                        genresId: stringToIntArray(string: filmData[genresId]),
                        id: filmData[filmId],
                        filmId: filmData[movieId]
        )
        films.append(film)
      }
    } catch{
      print("Selection failed")
    }
    return films
  }
  
  //MARK: - Helpers
  private func stringToIntArray(string: String) -> [Int]{
    let stringArray = string.components(separatedBy: " ")
    var resultArray: [Int] = []
    for stringId in stringArray{
      let id = Int(stringId) ?? 0
      resultArray.append(id)
    }
    return resultArray
  }
}

