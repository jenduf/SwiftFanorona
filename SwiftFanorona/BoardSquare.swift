//
//  BoardSquare.swift
//  SwiftFanorona
//
//  Created by Jennifer Duffey on 3/11/15.
//  Copyright (c) 2015 razeware. All rights reserved.
//

import UIKit

class BoardSquare: UIView, BoardDelegate
{
	private let board: FanoronaBoard
	private let blackView: UIButton
	private let whiteView: UIButton
	
	var location: BoardLocation
	
	var squareState: BoardCellState = BoardCellState.Empty
	var isSelected: Bool = false
	
	required init(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	init(frame: CGRect, location: BoardLocation, board: FanoronaBoard)
	{
		self.location = location
		self.board = board
		
		let blackImage = UIImage(named: "fanorona_dark_chip")
		let blackImageSelected = UIImage(named: "fanorona_dark_chip_selected")
		
		blackView = UIButton.buttonWithType(.Custom) as! UIButton
		blackView.setImage(blackImage, forState: UIControlState.Normal)
		blackView.setImage(blackImageSelected, forState: UIControlState.Selected)
		blackView.alpha = 0
		blackView.userInteractionEnabled = false
		
		let whiteImage = UIImage(named: "fanorona_white_chip")
		let whiteImageSelected = UIImage(named: "fanorona_white_chip_selected")

		whiteView = UIButton.buttonWithType(.Custom) as! UIButton
		whiteView.setImage(whiteImage, forState: UIControlState.Normal)
		whiteView.setImage(whiteImageSelected, forState: UIControlState.Selected)
		whiteView.alpha = 0
		whiteView.userInteractionEnabled = false
		
		super.init(frame: frame)
		
		backgroundColor = UIColor.clearColor()
		
		addSubview(blackView)
		addSubview(whiteView)
		
		update()
		
		board.addDelegate(self)
		
		let tapRecognizer = UITapGestureRecognizer(target: self, action: "cellTapped")
		addGestureRecognizer(tapRecognizer)
	}
	
	override func layoutSubviews()
	{
		super.layoutSubviews()
		
		self.whiteView.frame = self.bounds
		self.blackView.frame = self.bounds
	}
	
	private func update()
	{
		self.squareState = self.board[self.location]
		
		UIView.animateWithDuration(0.2, animations:
		{
			switch self.squareState
			{
				case .White:
					self.whiteView.alpha = 1.0
					self.blackView.alpha = 0.0
					self.whiteView.transform = CGAffineTransformIdentity
					self.blackView.transform = CGAffineTransformMakeTranslation(0, 20)
				
				case .Black:
					self.whiteView.alpha = 0.0
					self.blackView.alpha = 1.0
					self.whiteView.transform = CGAffineTransformMakeTranslation(0, -20)
					self.blackView.transform = CGAffineTransformIdentity
				
				case .Empty:
					self.whiteView.alpha = 0.0
					self.blackView.alpha = 0.0
					
			}
			
		})
		
		//whiteView.alpha = state == BoardCellState.White ? 1.0 : 0.0
		//blackView.alpha = state == BoardCellState.Black ? 1.0 : 0.0
	}
	
	func cellStateChanged(location: BoardLocation)
	{
		if self.location == location
		{
			update()
		}
	}
	
	func cellTapped()
	{
		if board.isValidMove(location)
		{
			board.makeMove(location)
		}
		else
		{
			if board.nextMove == self.squareState
			{
				board.deselectBoard()
				
				self.isSelected = true
				
				if(self.squareState == BoardCellState.White)
				{
					self.whiteView.selected = true
				}
				else
				{
					self.blackView.selected = true
				}
			}
			else
			{
				println("Not your turn")
			}
		}
	}
	
	func cellSelectionCleared()
	{
		self.whiteView.selected = false
		self.blackView.selected = false
	}
}
