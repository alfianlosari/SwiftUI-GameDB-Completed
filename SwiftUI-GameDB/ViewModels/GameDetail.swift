//
//  GameDetai.swift
//  SwiftUI-GameDB
//
//  Created by Alfian Losari on 09/08/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI
 
class GameDetail: ObservableObject {
    
    @Published var game: Game? = nil
    @Published var isLoading = false
    
    var gameService: GameService = GameStore.shared
    
    func reload(id: Int) {
        self.isLoading = true
        
        self.gameService.fetchGame(id: id) {[weak self] (result) in
            self?.isLoading = false
            
            switch result {
            case .success(let game):
                self?.game = game
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
