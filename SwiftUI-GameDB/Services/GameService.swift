//
//  MovieService.swift
//  DependencyInjection
//
//  Created by Alfian Losari on 28/06/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import Foundation

protocol GameService {    
    func fetchPopularGames(for platform: Platform, completion: @escaping (Result<[Game], Error>) -> Void)
    func fetchGame(id: Int, completion: @escaping (Result<Game, Error>) -> Void)
}
