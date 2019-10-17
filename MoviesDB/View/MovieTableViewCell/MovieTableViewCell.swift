//
//  MovieTableViewCell.swift
//  MoviesDB
//
//  Created by student on 8/23/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import SDWebImage

class MovieTableViewCell: UITableViewCell {

    @IBOutlet private weak var ibImageView: UIImageView!
    @IBOutlet private weak var ibMovieNameLabel: UILabel!
    @IBOutlet private weak var ibDateLabel: UILabel!
    @IBOutlet private weak var ibGenreLabel: UILabel!
    @IBOutlet private weak var ibAverageVoteLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI(){
        ibDateLabel.adjustsFontSizeToFitWidth = true
        ibDateLabel.minimumScaleFactor = 0.2
        ibMovieNameLabel.adjustsFontSizeToFitWidth = true
        ibMovieNameLabel.minimumScaleFactor = 0.2
    }
    
    func update(name: String, date: String, genreIds: [Int], imageURL: URL, averageVote: Double){
        ibImageView.sd_imageIndicator = SDWebImageActivityIndicator.white
        ibImageView.sd_setImage(with: imageURL, completed: nil)
        ibMovieNameLabel.text = name
        ibDateLabel.text = date
        if genreIds.count == 0 {
            ibGenreLabel.text = "Movie"
        } else {
            ibGenreLabel.text = DataManager.instance.getGenreName(by: genreIds[0])
        }
        ibAverageVoteLabel.text = "\(averageVote)"
    }
    
}
