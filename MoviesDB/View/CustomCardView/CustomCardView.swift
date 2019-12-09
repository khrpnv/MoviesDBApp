//
//  CustomCardView.swift
//  MoviesDB
//
//  Created by Illia Khrypunov on 12/09/19.
//  Copyright © 2019 Illia Khrypunov. All rights reserved.
//

import UIKit
import SDWebImage

class CustomCardView: UIView {
    
    @IBOutlet private var ibContentView: UIView!
    @IBOutlet private weak var ibPosterImageView: UIImageView!
    @IBOutlet private weak var ibFilmTitleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("CustomCardView", owner: self, options: nil)
        addSubview(ibContentView)
        ibContentView.frame = self.bounds
        ibContentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func update(imageURL: URL, title: String){
        ibPosterImageView.sd_imageIndicator = SDWebImageActivityIndicator.white
        ibPosterImageView.sd_setImage(with: imageURL, completed: nil)
        ibFilmTitleLabel.text = title
    }
}
