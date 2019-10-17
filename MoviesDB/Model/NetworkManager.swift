//
//  NetworkManager.swift
//  MoviesDB
//
//  Created by student on 8/27/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkManager{
    
    private let requestFirstPart = "https://api.themoviedb.org/3/movie/"
    private let requestThirdPart = "?api_key=fa5905777c03fe7ddd03c1fecb07b824&page="
    
    weak var splashScreenDelegate: SplashScreenDelegate?
    weak var moviesViewControllerDelegate: MoviesControllerDelegate?
    weak var trailerControllerDelegate: TrailerControllerDelegate?
    
    func getFilmData(requsetString requestSecondPart: String, listType: ListType, isInitial: Bool, page: Int){
        let requestStr = requestFirstPart + requestSecondPart + requestThirdPart + "\(page)"
        let imageUrl = "https://image.tmdb.org/t/p/w1280"
        var films: [Film] = []
        Alamofire.request(requestStr).responseJSON{ response in
            guard let value = response.result.value else {return}
            let jsonObject = JSON(value)
            let jsonArray = jsonObject["results"].arrayValue
            for object in jsonArray{
                let title = object["title"].stringValue
                let voteAverage = object["vote_average"].doubleValue
                let overview = object["overview"].stringValue
                let releaseDate = object["release_date"].stringValue
                let imagePath = object["poster_path"].stringValue
                let genresIdJSON = object["genre_ids"].arrayValue
                var genereIds: [Int] = []
                let filmId = object["id"].intValue
                for id in genresIdJSON{
                    genereIds.append(id.intValue)
                }
                let imageFullPath = imageUrl + imagePath
                guard let remoteURL = URL(string: imageFullPath) else { return }
                let film = Film(name: title, imageURL: remoteURL, voteAverage: voteAverage, overview: overview, releaseDate: releaseDate, genresId: genereIds, id: nil, filmId: filmId)
                films.append(film)
            }
            if isInitial{
                self.splashScreenDelegate?.didFinishDownloadingData(array: films, list: listType)
            } else {
                self.moviesViewControllerDelegate?.didFinishDownloading(array: films)
            }
        }.resume()
    }
    
    func getGenresData(){
        let requestString = "https://api.themoviedb.org/3/genre/movie/list?api_key=fa5905777c03fe7ddd03c1fecb07b824"
        var genres: [Genre] = []
        Alamofire.request(requestString).responseJSON { (response) in
            guard let value = response.result.value else {return}
            let jsonObject = JSON(value)
            let jsonArray = jsonObject["genres"].arrayValue
            for object in jsonArray{
                let genreId = object["id"].intValue
                let genreName = object["name"].stringValue
                genres.append(Genre(id: genreId, name: genreName))
            }
            self.splashScreenDelegate?.didFinishDownloadingGenres(array: genres)
        }.resume()
    }
    
    func getMovieTrailerKey(movieId: Int){
        let requestString = "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=fa5905777c03fe7ddd03c1fecb07b824"
        var result = ""
        Alamofire.request(requestString).responseJSON { (response) in
            guard let value = response.result.value else {return}
            let jsonObject = JSON(value)
            let jsonArray = jsonObject["results"].arrayValue
            let key = jsonArray[0]["key"].stringValue
            result = key
            self.trailerControllerDelegate?.didFinishGettingVideoKey(key: result)
        }.resume()
    }
}
