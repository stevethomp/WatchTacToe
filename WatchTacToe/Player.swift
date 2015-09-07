//
//  Player.swift
//  WatchTacToe
//
//  Created by Steven Thompson on 2015-09-07.
//  Copyright © 2015 stevethomp. All rights reserved.
//

import UIKit
import GameplayKit

enum TileStatus: String {
    case Player1, Player2
    case Empty
}

class Player: NSObject, GKGameModelPlayer {
    var playerColor: PlayerColor
    var color: UIColor
    var name: String
    var playerId: Int
    
    static var allPlayers = [Player(color: .Blue), Player(color: .Red)]

    init(color: PlayerColor) {
        self.playerColor = color
        self.playerId = color.rawValue
        
        if playerColor == .Red {
            self.color = .redColor()
            self.name = "Red"
        } else {
            self.color = .blueColor()
            self.name = "Blue"
        }
        
        super.init()
    }
    
    var opponent: Player {
        if playerColor == .Red {
            return Player.allPlayers[0]
        } else {
            return Player.allPlayers[1]
        }
    }
    
    var tileStatus: TileStatus {
        if playerColor == .Blue {
            return .Player1
        } else {
            return .Player2
        }
    }
}
