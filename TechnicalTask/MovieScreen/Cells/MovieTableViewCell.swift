//
//  MovieTableViewCell.swift
//  TechnicalTask
//
//  Created by Viacheslav Markov on 10.04.2021.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    
    static var identifier: String {
        return "MovieTableViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        mainImageView.image = nil
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
        if movie.posterPath.isEmpty {
            mainImageView.isHidden = true
        } else {
            mainImageView.isHidden = false
            
            if let url = URL(string: "https://image.tmdb.org/t/p/w500/\(movie.posterPath)") {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        DispatchQueue.main.async {
                            let image = UIImage(data: data)
                            self.mainImageView.image = image
                        }
                    }
                }
            }
        }
    }
    
}


