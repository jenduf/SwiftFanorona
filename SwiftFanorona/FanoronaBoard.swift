//
//  ReversiBoard.swift
//  SwiftFanorona
//
//  Created by Jennifer Duffey on 3/11/15.
//  Copyright (c) 2015 razeware. All rights reserved.
//

import Foundation

class FanoronaBoard: Board
{
	private (set) var blackScore = 0, whiteScore = 0
	
	private (set) var nextMove = BoardCellState.White
	
	private (set) var gameHasFinished = false
	
	private var boardSquares: [BoardSquare] = []
	
	private let fanoronaBoardDelegates = DelegateMulticast<FanoronaBoardDelegate>()
	
	override init()
	{
		super.init()
	}
	
	init(board: FanoronaBoard)
	{
		super.init(board: board)
		
		nextMove = board.nextMove
		blackScore = board.blackScore
		whiteScore = board.whiteScore
	}
	
	func addSquare(square: BoardSquare)
	{
		boardSquares.append(square)
	}
	
	func setInitialState()
	{
		self.clearBoard()
		
		//var numWhites: Int = 0
		//var numBlacks:Int = 0
		//var numEmpties: Int = 0
		
		self.cellVisitor
		{
			(location: BoardLocation) in
			
			var boardState: BoardCellState = .Empty
			
				switch(location.row)
				{
					case 0...1:
						boardState = .Black
					//numBlacks++
					
					case 2:
						if location.column == 0 || location.column == 2 || location.column == 5 || location.column == 7
						{
							boardState = .Black
						}
						else if location.column != 4
						{
							boardState = .White
						}
						else
						{
							boardState = .Empty
						}
					
					
					case 3...4:
						boardState = .White
					//	numWhites++
					
					default:
						boardState = .Empty
					//	numEmpties++
				}
			
			//println("\(location.row), \(location.column), \(boardState.stringValue), Whites: \(numWhites), Blacks: \(numBlacks), Empties: \(numEmpties)")
			
			self[location.row, location.column] = boardState
		}
		
		/*super[0,0] = .Black
		super[1,4] = .Black
		super[0,8] = .Black
		super[4,4] = .White
		super[3,4] = .White
		super[4,3] = .White
		*/
		
		blackScore = 2
		whiteScore = 2
	}
	
	func addDelegate(delegate: FanoronaBoardDelegate)
	{
		fanoronaBoardDelegates.addDelegate(delegate)
	}
	
	func isValidMove(location: BoardLocation) -> Bool
	{
		return self[location] == BoardCellState.Empty
	}
	
	private func isValidMove(location: BoardLocation, toState: BoardCellState) -> Bool
	{
		// check the cell is empty
		if self[location] != BoardCellState.Empty
		{
			return false
		}
		
		// test whether the move surrounds any of the opponent's pieces
		for direction in MoveDirection.directions
		{
			//if moveSurroundsCounters(location, direction: direction, toState: toState)
			//{
			//	return true
			//}
		}
		
		return false
	}
	
	func makeMove(location: BoardLocation)
	{
		var moveDirection: MoveDirection?
		
		var selSquare = self.getSquare() as BoardSquare!
		
		moveDirection = MoveDirection.getDirectionForMove(selSquare.location, toLocation: location) as MoveDirection!
		
		if moveDirection!.canMoveDirection(selSquare.location)
		{
			self[location] = nextMove
			
			self[selSquare.location] = BoardCellState.Empty
		
			clearCaptures(location, direction: moveDirection!, toState: self.nextMove)
		
			selSquare.isSelected = false
		
			checkIfNeedSwitchTurns(location, moveDirection: moveDirection!)
		
			gameHasFinished = checkIfGameHasFinished()
		
			whiteScore = countMatches
			{
				self[$0] == BoardCellState.White
			}
			
			blackScore = countMatches
			{
				self[$0] == BoardCellState.Black
			}
			
			fanoronaBoardDelegates.invokeDelegates
			{
				$0.boardStateChanged()
			}
		}
	}
	
	private func clearCaptures(location: BoardLocation, direction: MoveDirection, toState: BoardCellState)
	{
		var moveDirection = direction as MoveDirection
		
		// are there captures?
		if !checkForCaptures(location, direction: moveDirection, toState: toState)
		{
			moveDirection = moveDirection.invert()
			var newLocation = moveDirection.move(location)
			
			if !checkForCaptures(newLocation, direction: moveDirection, toState: toState)
			{
				return
			}
		}
		
		let opponentState = toState.invert()
		var currentState = opponentState
		var currentLocation = moveDirection.move(location)
		
		// clear captures until the current state is reached
		
		while (isWithinBounds(currentLocation) && currentState == opponentState)
		{
			self[currentLocation] = BoardCellState.Empty
			currentLocation = moveDirection.move(currentLocation)
			
			if isWithinBounds(currentLocation)
			{
				currentState = self[currentLocation]
			}
		}
	}
	
	func checkForCaptures(location: BoardLocation, direction: MoveDirection, toState: BoardCellState) -> Bool
	{
		var currentLocation = direction.move(location)
		
		if isWithinBounds(currentLocation)
		{
			let currentState = self[currentLocation]
		
			// check if immediate neighbor exists, which means capture
			if currentState == toState.invert()
			{
				return true
			}
		}
		
		return false
	}
	
	func checkForAvailableCaptures(location: BoardLocation, direction: MoveDirection, toState: BoardCellState) -> Bool
	{
		var currentLocation = direction.move(location)
		
		if isWithinBounds(currentLocation)
		{
			let currentState = self[currentLocation]
			
			if currentState == toState.invert()
			{
				var inverseDirection = direction.invert()
				currentLocation = inverseDirection.move(location)
				
				if isWithinBounds(currentLocation)
				{
					var inverseState = self[currentLocation]
					
					// check if empty space to move piece
					if inverseState == BoardCellState.Empty
					{
						return true
					}
				}
			}
			else if currentState == BoardCellState.Empty
			{
				currentLocation = direction.move(currentLocation)
				
				if isWithinBounds(currentLocation)
				{
					var forwardState = self[currentLocation]
					
					if forwardState == toState.invert()
					{
						return true
					}
				}
			}
		}
		
		return false
	}
	
	func checkIfNeedSwitchTurns(location: BoardLocation, moveDirection: MoveDirection)
	{
		for direction in MoveDirection.directions
		{
			if direction != moveDirection && direction != moveDirection.invert()
			{
				if direction.canMoveDirection(location)
				{
					if checkForAvailableCaptures(location, direction: direction, toState: self.nextMove)
					{
						return
					}
				}
			}
		}
		
		switchTurns()
	}
	
	func switchTurns()
	{
		var intendedNextMove = nextMove.invert()
		
		// only switch turns if the player can make a move
			//if canPlayerMakeMove(intendedNextMove)
		//{
			nextMove = intendedNextMove
		//}
	}
	
	private func checkIfGameHasFinished() -> Bool
	{
		return !canPlayerMakeMove(BoardCellState.Black) && !canPlayerMakeMove(BoardCellState.White)
	}
	
	private func canPlayerMakeMove(toState: BoardCellState) -> Bool
	{
		return anyCellsMatchCondition
		{
			self.isValidMove($0, toState: toState)
		}
	}
	
	func getSquare() -> BoardSquare?
	{
		for square in self.boardSquares
		{
			if square.isSelected
			{
				return square as BoardSquare
			}
		}
		
		return nil
	}
	
	func squareVisitor(fn: (BoardSquare) -> ())
	{
		for square in self.boardSquares
		{
			fn(square)
		}
	}
}