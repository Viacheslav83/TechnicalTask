//
//  MovieResponce.swift
//  TechnicalTask
//
//  Created by Viacheslav Markov on 11.04.2021.
//

import Foundation

struct MoviesResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    var title: String
    let posterPath: String
    let releaseDate: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case title
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}
