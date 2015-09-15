//
//  Game.swift
//  WatchTacToe
//
//  Created by Steven Thompson on 2015-09-05.
//  Copyright © 2015 stevethomp. All rights reserved.
//

import UIKit
import GameplayKit

typealias Row = [TileStatus]
typealias GameBoard = [Row]

class Game: NSObject, GKGameModel {
    private var board: GameBoard = [[.Empty, .Empty, .Empty], [.Empty, .Empty, .Empty], [.Empty, .Empty, .Empty]]
    var currentPlayer = Player.allPlayers.first!
    
    var players: [GKGameModelPlayer]? {
        return Player.allPlayers
    }
    
    var activePlayer: GKGameModelPlayer? {
        return currentPlayer
    }

    func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = Game()
        copy.setGameModel(self)
        board = copy.board
        return copy
    }
    
    func setGameModel(gameModel: GKGameModel) {
        if let game = gameModel as? Game {
            currentPlayer = game.currentPlayer
            board = game.board
        }
    }
    
    func gameModelUpdatesForPlayer(player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        if let playerObject = player as? Player {
            // 2
            if isWinForPlayer(playerObject) || isWinForPlayer(playerObject.opponent) {
                return nil
            }
            
            // 3
            var moves = [Move]()
            
            let tiles = board.flatten()
            for var tile = 0; tile < tiles.count; tile++ {
                let rowAndColumn = rowAndColumnForIndexPath(NSIndexPath(forRow: tile, inSection: 0))
                if board[rowAndColumn.row][rowAndColumn.column] == TileStatus.Empty {
                    moves.append(Move(row: rowAndColumn.row, column: rowAndColumn.column))
                }
            }
            
            // 6
            return moves;
        }
        
        return nil
    }
    
    func applyGameModelUpdate(gameModelUpdate: GKGameModelUpdate) {
        if let move = gameModelUpdate as? Move {
            playRow(move.row, column: move.column, player: currentPlayer)
            currentPlayer = currentPlayer.opponent
        }
    }

    func scoreForPlayer(player: GKGameModelPlayer) -> Int {
        if let playerObject = player as? Player {
            if isWinForPlayer(playerObject) {
                return 1000
            } else if isWinForPlayer(playerObject.opponent) {
                return -1000
            }
        }
        return 0
    }
    
    func playRow(row: Int, column: Int, player: Player) {
        board[row][column] = player.tileStatus
    }
    
    func playIndexPath(indexPath: NSIndexPath, player: Player) {
        let tile = indexPath.row
        switch tile {
        case 0:
            board[0][0] = player.tileStatus
        case 1:
            board[0][1] = player.tileStatus
        case 2:
            board[0][2] = player.tileStatus
        case 3:
            board[1][0] = player.tileStatus
        case 4:
            board[1][1] = player.tileStatus
        case 5:
            board[1][2] = player.tileStatus
        case 6:
            board[2][0] = player.tileStatus
        case 7:
            board[2][1] = player.tileStatus
        case 8:
            board[2][2] = player.tileStatus

        default:
            print("Can't have bad index!")
        }
    }
    
    func isFull() -> Bool {
        for row: Row in board {
            for tile: TileStatus in row {
                if tile == .Empty {
                    return false
                }
            }
        }
        return true
    }
    
    func isWinForPlayer(player: GKGameModelPlayer) -> Bool {
        if let playerObject = player as? Player {
            return checkGameWonForPlayer(playerObject)
        }
        return false
    }
    
    func isLossForPlayer(player: GKGameModelPlayer) -> Bool {
        if let playerObject = player as? Player {
            return checkGameWonForPlayer(playerObject.opponent)
        }
        return false
    }
    
    func checkGameWonForPlayer(player: Player) -> Bool {
        //check row win
        if checkRowWonForPlayer(player) {
            return true
        }
        
        if checkColumnWonForPlayer(player) {
            return true
        }
        
        if checkDiagWonForPlayer(player) {
            return true
        }
        
        return false
    }

    private func checkRowWonForPlayer(player: Player) -> Bool {
        for row: Row in board {
            if row[0] == player.tileStatus && row[1] == player.tileStatus && row[2] == player.tileStatus {
                return true
            }
        }
        return false
    }
    
    private func checkColumnWonForPlayer(player: Player) -> Bool {
        for var column = 0; column < 3; column++ {
            if (board[0][column] == player.tileStatus && board[1][column] == player.tileStatus && board[2][column] == player.tileStatus){
                return true
            }
        }
        return false
    }
    
    private func checkDiagWonForPlayer(player: Player) -> Bool {
        if (board[0][0] == player.tileStatus && board[1][1] == player.tileStatus && board[2][2] == player.tileStatus) || (board[0][2] == player.tileStatus && board[1][1] == player.tileStatus && board[2][0] == player.tileStatus) {
            return true
        }
        return false
    }
    
    func rowAndColumnForIndexPath(indexPath: NSIndexPath) -> (row: Int, column: Int) {
        switch indexPath.row {
        case 0:
            return (0, 0)
        case 1:
            return (0, 1)
        case 2:
            return (0, 2)
        case 3:
            return (1, 0)
        case 4:
            return (1, 1)
        case 5:
            return (1, 2)
        case 6:
            return (2, 0)
        case 7:
            return (2, 1)
        case 8:
            return (2, 2)
        default:
            return (0, 0)
        }
    }
    
    func indexPathForMove(move: Move) -> NSIndexPath {
        switch (move.row, move.column) {
        case (0,0):
            return NSIndexPath(forRow: 0, inSection: 0)
        case (0,1):
            return NSIndexPath(forRow: 1, inSection: 0)
        case (0,2):
            return NSIndexPath(forRow: 2, inSection: 0)
        case (1,0):
            return NSIndexPath(forRow: 3, inSection: 0)
        case (1,1):
            return NSIndexPath(forRow: 4, inSection: 0)
        case (1,2):
            return NSIndexPath(forRow: 5, inSection: 0)
        case (2,0):
            return NSIndexPath(forRow: 6, inSection: 0)
        case (2,1):
            return NSIndexPath(forRow: 7, inSection: 0)
        case (2,2):
            return NSIndexPath(forRow: 8, inSection: 0)
        default:
            return NSIndexPath(forRow: 0, inSection: 0)
        }
    }
}
