//
//  Film.swift
//  MoviesDB
//
//  Created by student on 8/23/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation
import UIKit

struct Film{
    let id: String
    let name: String
    let imageURL: URL
    let voteAverage: Double
    let overview: String
    let releaseDate: String
    let genresId: [Int]
    let filmId: Int
    
    init(name: String, imageURL: URL, voteAverage: Double, overview: String, releaseDate: String, genresId: [Int], id: String?, filmId: Int) {
        self.name = name
        self.imageURL = imageURL
        self.voteAverage = voteAverage
        self.overview = overview
        self.releaseDate = releaseDate
        self.genresId = genresId
        if id == nil{
            self.id = UUID().uuidString
        } else {
            self.id = id ?? ""
        }
        self.filmId = filmId
    }
    
    func genresToString() -> String{
        var resultString = ""
        for index in 0..<genresId.count{
            if index == genresId.count - 1{
                resultString += "\(genresId[index])"
            } else {
                resultString += "\(genresId[index]) "
            }
        }
        return resultString
    }
}
