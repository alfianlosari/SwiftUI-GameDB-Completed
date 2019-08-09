//
//  ContentView.swift
//  SwiftUI-GameDB
//
//  Created by Alfian Losari on 05/08/19.
//  Copyright © 2019 Alfian Losari. All rights reserved.
//

import SwiftUI

struct GameListView: View {
    
    @ObservedObject var gameList: GameList = GameList()
    var platform: Platform = .ps4
    
    var body: some View {
        NavigationView {
            Group {
                if gameList.isLoading {
                    LoadingView()
                } else {
                    List(self.gameList.games) { (game: Game) in
                        NavigationLink(destination: GameDetailView(gameId: game.id)) {
                            GameRowView(game: game)
                        }
                    }
                }
            }
            .navigationBarTitle(self.platform.description)
        }
        .onAppear {
            if self.gameList.games.isEmpty {
                self.gameList.reload(platform: self.platform)
            }
        }
    }
}
