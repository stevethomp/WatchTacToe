//
//  ViewController.swift
//  TVTacToe
//
//  Created by Steven Thompson on 2015-09-11.
//  Copyright © 2015 stevethomp. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var gameLabel: UILabel!

    var game = Game()
    var strategist: GKMinmaxStrategist!
    
    var player1Color = UIColor.redColor()
    var player2Color = UIColor.blueColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.registerClass(GameCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        playAgainButton.hidden = true
        
        if game.currentPlayer.playerColor == .Blue {
            gameLabel.text = "Your turn"
        } else {
            gameLabel.text = "AI turn"
        }
        
        strategist = GKMinmaxStrategist()
        strategist.maxLookAheadDepth = 2
        strategist.randomSource = GKARC4RandomSource()
        
        resetGame()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        cell.backgroundColor = .whiteColor()
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! GameCollectionViewCell
        
        cell.playCell(game.currentPlayer.color)
        let rowColumn = game.rowAndColumnForIndexPath(indexPath)
        
        game.playRow(rowColumn.row, column: rowColumn.column, player: game.currentPlayer)
        
        nextTurn()
    }
    
    func moveForAIStrategy() -> Move? {
        if let aiMove = strategist.bestMoveForPlayer(game.currentPlayer) as? Move {
            return aiMove
        }
        return nil
    }
    
    func makeAIMove(move: Move) {
        let cell = collectionView.cellForItemAtIndexPath(game.indexPathForMove(move)) as! GameCollectionViewCell
        cell.playCell(game.currentPlayer.color)
        game.playRow(move.row, column: move.column, player: game.currentPlayer)
        
        nextTurn()
    }
    
    func startAIMove() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { [unowned self] in
            let strategistTime = CFAbsoluteTimeGetCurrent()
            let move = self.moveForAIStrategy()!
            let delta = CFAbsoluteTimeGetCurrent() - strategistTime
            
            let aiTimeCeiling = 1.0
            let delay = min(aiTimeCeiling - delta, aiTimeCeiling)
            
            self.runAfterDelay(delay) {
                self.makeAIMove(move)
            }
        }
    }
    
    func runAfterDelay(delay: NSTimeInterval, block: dispatch_block_t) {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), block)
    }
    
    func nextTurn() {
        if game.isFull() {
            showDraw()
            return
        }
        
        if game.checkGameWonForPlayer(game.currentPlayer) || game.checkGameWonForPlayer(game.currentPlayer.opponent) {
            showWin()
            return
        }
        
        game.currentPlayer = game.currentPlayer.opponent
        
        if game.currentPlayer.playerColor == .Red {
            collectionView.userInteractionEnabled = false
            startAIMove()
        } else {
            collectionView.userInteractionEnabled = true
            
            setNeedsFocusUpdate()
            updateFocusIfNeeded()
        }
        
        if game.currentPlayer.playerColor == .Blue {
            gameLabel.text = "Your turn"
        } else {
            gameLabel.text = "AI turn"
        }
    }
    
    func showWin() {
        if game.currentPlayer.playerColor == .Blue {
            gameLabel.text = "You win!"
        } else {
            gameLabel.text = "AI won :("
        }
        
        playAgainButton.hidden = false
        
        collectionView.userInteractionEnabled = false
        
        setNeedsFocusUpdate()
        updateFocusIfNeeded()
    }
    
    func showDraw() {
        gameLabel.text = "Draw :("
        
        playAgainButton.hidden = false
        
        collectionView.userInteractionEnabled = false
        
        setNeedsFocusUpdate()
        updateFocusIfNeeded()
    }
    
    @IBAction func resetGame() {
        game = Game()
        strategist.gameModel = game
        
        if game.currentPlayer.playerColor == .Blue {
            gameLabel.text = "Your turn"
        } else {
            gameLabel.text = "AI turn"
        }
        playAgainButton.hidden = true
        
        collectionView.reloadData()
        collectionView.userInteractionEnabled = true
        
        setNeedsFocusUpdate()
        updateFocusIfNeeded()
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocusInContext(context, withAnimationCoordinator: coordinator)
        if let cell = context.nextFocusedView as? GameCollectionViewCell {
            cell.layer.borderColor = UIColor.blueColor().CGColor
            cell.layer.borderWidth = 3.0
        }
        
        if let cell = context.previouslyFocusedView as? GameCollectionViewCell {
            cell.layer.borderColor = UIColor.clearColor().CGColor
            cell.layer.borderWidth = 0.0
        }
        
    }
}

