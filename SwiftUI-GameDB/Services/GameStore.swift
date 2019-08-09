//
//  GameStore.swift
//  DependencyInjection
//
//  Created by Alfian Losari on 27/06/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Foundation
import IGDB_SWIFT_API

class GameStore: GameService {
    
    static let shared = GameStore()
    
    private init() {}
    
    lazy var iGDB: IGDBWrapper = {
        $0.userKey = "APIKEY"
        return $0
    }(IGDBWrapper())
    
    func fetchPopularGames(for platform: Platform, completion: @escaping (Result<[Game], Error>) -> Void) {
        iGDB.apiRequest(endpoint: .GAMES, apicalypseQuery: "fields name, first_release_date, id, popularity, rating, involved_companies.company.name, cover.image_id; where (platforms = (\(platform.rawValue)) & popularity >= 85 & themes != 42); sort first_release_date desc; limit 50;", dataResponse: { bytes in
            guard let gameResults = try? Proto_GameResult(serializedData: bytes) else {
                return
            }
            let games = gameResults.games.map { Game(game: $0) }
            DispatchQueue.main.async {
              completion(.success(games))
            }
        }, errorResponse: { error in
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        })
    }
    
    func fetchGame(id: Int, completion: @escaping (Result<Game, Error>) -> Void) {
        iGDB.apiRequest(endpoint: .GAMES, apicalypseQuery: "fields name, summary, genres.name, storyline, first_release_date, screenshots.image_id, id, popularity, rating, cover.image_id, involved_companies.company.name; where id = \(id);", dataResponse: { (bytes) -> (Void) in
            guard let protoGame = try? Proto_GameResult(serializedData: bytes).games.first else {
                return
            }
            DispatchQueue.main.async {
                completion(.success(Game(game: protoGame, coverSize: .COVER_BIG)))
            }
        }) { error  in
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
}


fileprivate extension Game {
    
    init(game: Proto_Game, coverSize: ImageSize = .COVER_BIG) {
        let coverURL = imageBuilder(imageID: game.cover.imageID, size: coverSize, imageType: .PNG)
        
        let screenshotURLs = game.screenshots.map { (scr) -> String in
            let url = imageBuilder(imageID: scr.imageID, size: .SCREENSHOT_MEDIUM, imageType: .JPEG)
            return url
        }
        
        let company = game.involvedCompanies.first?.company.name ?? ""
        let genres = game.genres.map { $0.name }
        self.init(id: Int(game.id),
                  name: game.name,
                  storyline: game.storyline,
                  summary: game.summary,
                  releaseDate: game.firstReleaseDate.date,
                  popularity: game.popularity,
                  rating: game.rating,
                  coverURLString: coverURL, screenshotURLsString: screenshotURLs, genres: genres, company: company)
        
    }
    
}
