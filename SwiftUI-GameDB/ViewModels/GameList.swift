//
//  GameList.swift
//  SwiftUI-GameDB
//
//  Created by Alfian Losari on 09/08/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI

class GameList: ObservableObject {
    
    @Published var games: [Game] = []
    @Published var isLoading = false
    
    var gameService = GameStore.shared
    
    func reload(platform: Platform = .ps4) {
        self.games = []
        self.isLoading = true
        
        gameService.fetchPopularGames(for: platform) { [weak self]  (result) in
            self?.isLoading = false
            
            switch result {
            case .success(let games):
                self?.games = games
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
