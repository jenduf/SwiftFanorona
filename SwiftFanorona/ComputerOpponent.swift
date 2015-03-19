
//
//  ComputerOpponent.swift
//  SwiftFanorona
//
//  Created by Jennifer Duffey on 3/11/15.
//  Copyright (c) 2015 razeware. All rights reserved.
//

import Foundation

func delay(delay: Double, closure: ()->())
{
	let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
	
	dispatch_after(time, dispatch_get_main_queue(), closure)
}

class ComputerOpponent: FanoronaBoardDelegate
{
	private let board: FanoronaBoard
	private let color: BoardCellState
	private let maxDepth: Int
	
	init(board: FanoronaBoard, color: BoardCellState, maxDepth: Int)
	{
		self.board = board
		self.color = color
		self.maxDepth = maxDepth
		
		board.addDelegate(self)
	}
	
	func boardStateChanged()
	{
		if board.nextMove == color
		{
			delay(1.0)
			{
				self.makeNextMove()
			}
		}
	}
	
	private func makeNextMove()
	{
		var bestScore = Int.min
		var bestLocation: BoardLocation?
		
		// check every valid move for this particular board, then select the one with the best score
		for move in validMovesForBoard(self.board)
		{
			var nextLocation: BoardLocation?
			
			let score = self.scoreForBoard(self.board, depth: 1)
					
			if score > bestScore
			{
				bestScore = score
				bestLocation = move
			}
			
		}
		
		if bestScore > Int.min
		{
			board.makeMove(bestLocation!)
		}
	}
	
	private func scoreForBoard(board: FanoronaBoard, depth: Int = 0) -> Int
	{
		// if we have reached the maximum search depth, then just compute the score of the current board state
		if(depth >= self.maxDepth)
		{
			return color == BoardCellState.White ? board.whiteScore - board.blackScore : board.blackScore - board.whiteScore
		}
		
		var minMax = Int.min
		
		for move in validMovesForBoard(board)
		{
			// clone the board and take the move
			let testBoard = FanoronaBoard(board: board)
			
			// compute the score
			let score = scoreForBoard(testBoard, depth: depth + 1)
			
			// pick the best score
			if depth % 2 == 0
			{
				if score > minMax || minMax == Int.min
				{
					minMax = score
				}
			}
			else
			{
				if score < minMax || minMax == Int.min
				{
					minMax = score
				}
			}
		}
		
		return minMax
	}
	
	private func validMovesForBoard(board: FanoronaBoard) -> [BoardLocation]
	{
		var moves = [BoardLocation]()
		
		board.cellVisitor
		{
			if board.isValidMove($0)
			{
				moves += [$0]
			}
		}
		
		return moves
	}
}
