//
//  ViewController.swift
//  SwiftFanorona
//
//  Created by Colin Eberhardt on 07/06/2014.
//  Copyright (c) 2014 razeware. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FanoronaBoardDelegate
{
                            
	@IBOutlet var blackScore : UILabel!
	@IBOutlet var whiteScore : UILabel!
	@IBOutlet var restartButton : UIButton!
	
	private let board: FanoronaBoard
	
	//	private let computer: ComputerOpponent
	
	required init(coder aDecoder: NSCoder)
	{
		board = FanoronaBoard()
		board.setInitialState()
		
		//computer = ComputerOpponent(board: board, color: BoardCellState.Black, maxDepth: 5)
		
		super.init(coder: aDecoder)
		
		board.addDelegate(self)
	}
  
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		let boardFrame = CGRect(x: 3.5, y: 101.5, width: 1017, height: 567.5)
		let boardView = FanoronaBoardView(frame: boardFrame, board: board)
		
		view.addSubview(boardView)
		
		boardStateChanged()
		
		restartButton.addTarget(self, action: "restartTapped", forControlEvents: UIControlEvents.TouchUpInside)
	}
	
	func boardStateChanged()
	{
		blackScore.text = "\(board.blackScore)"
		whiteScore.text = "\(board.whiteScore)"
		
		restartButton.hidden = !board.gameHasFinished
	}
	
	func restartTapped()
	{
		if board.gameHasFinished
		{
			board.setInitialState()
			boardStateChanged()
		}
	}
}

