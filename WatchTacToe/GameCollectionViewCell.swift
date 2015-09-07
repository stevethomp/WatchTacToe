//
//  GameCollectionViewCell.swift
//  WatchTacToe
//
//  Created by Steven Thompson on 2015-09-06.
//  Copyright © 2015 stevethomp. All rights reserved.
//

import UIKit

class GameCollectionViewCell: UICollectionViewCell {
    var played = false
    
    func playCell(color: UIColor) {
        self.played = true
        self.backgroundColor = color
        self.userInteractionEnabled = false
    }
    
    override func prepareForReuse() {
        self.played = false
        self.userInteractionEnabled = true
    }
}
