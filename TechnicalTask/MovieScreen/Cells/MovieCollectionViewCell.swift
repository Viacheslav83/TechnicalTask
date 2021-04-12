//
//  MovieCollectionViewCell.swift
//  TechnicalTask
//
//  Created by Viacheslav Markov on 10.04.2021.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    static var identifier: String {
        return "MovieCollectionViewCell"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
        titleLabel.text = nil
        releaseDateLabel.text = nil
        voteAverageLabel.text = nil
    }
    
    static func nib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    func configure(with movie: Movie) {
        
        titleLabel.text = movie.title
        voteAverageLabel.text = String(movie.voteAverage)
        releaseDateLabel.text = movie.releaseDate
        
        if let url = URL(string: "https://image.tmdb.org/t/p/w500/\(movie.posterPath)") {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self.imageView.image = image
                    }
                }
            }
        }
    }
}
