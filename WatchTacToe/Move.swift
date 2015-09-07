//
//  Move.swift
//  WatchTacToe
//
//  Created by Steven Thompson on 2015-09-07.
//  Copyright © 2015 stevethomp. All rights reserved.
//

import UIKit
import GameplayKit

class Move: NSObject, GKGameModelUpdate {
    var value: Int = 0
    var column: Int
    var row: Int
    
    init(row: Int, column: Int) {
        self.column = column
        self.row = row
    }
}
