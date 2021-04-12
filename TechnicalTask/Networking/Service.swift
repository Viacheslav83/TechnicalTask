//
//  Service.swift
//  TechnicalTask
//
//  Created by Viacheslav Markov on 11.04.2021.
//

import Foundation

class Service {
    private static let apiKey = "f910e2224b142497cc05444043cc8aa4"
    private static let baseUrlString = "https://api.themoviedb.org/3/movie/"
    static let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    
    private static var stringURL: String = ""
    
    static func setURL(partUrl: String) {
        stringURL = "https://api.themoviedb.org/3/movie/\(partUrl)?api_key=\(apiKey)"
    }

    static func getToRated(_ completion: @escaping (ServiceResult<MoviesResponse, Error>) -> Void) {
        let session = URLSession.shared
        guard let topRatedURL = URL(string: stringURL) else { return }
        session.dataTask(with: topRatedURL) { data, response, error in
            
            guard let topRatedData = data else { return }
            
            do {
                let topRated = try JSONDecoder().decode(MoviesResponse.self, from: topRatedData)
                completion(.success(topRated))
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
}
