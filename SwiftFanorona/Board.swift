
//
//  Board.swift
//  SwiftFanorona
//
//  Created by Jennifer Duffey on 3/11/15.
//  Copyright (c) 2015 razeware. All rights reserved.
//

import Foundation

class Board
{
	private var cells: [BoardCellState]
	
	private let boardDelegates = DelegateMulticast<BoardDelegate>()
	
	let boardColumns = 9
	let boardRows = 5
	
	init()
	{
		cells = Array(count: boardColumns * boardRows, repeatedValue: BoardCellState.Empty)
	}
	
	init(board: Board)
	{
		cells = board.cells
	}
	
	subscript(location: BoardLocation) -> BoardCellState
	{
		get
		{
			assert(isWithinBounds(location), "row or column index is out of bounds")
			
			return cells[location.row * boardColumns + location.column]
		}
		
		set
		{
			assert(isWithinBounds(location), "row or column index out of bounds")
			
			cells[location.row * boardColumns + location.column] = newValue
			
			boardDelegates.invokeDelegates
			{
				$0.cellStateChanged(location)
			}
		}
	}
	
	subscript(row: Int, column: Int) -> BoardCellState
	{
		get
		{
			return self[BoardLocation(row: row, column: column)]
		}
		
		set
		{
			self[BoardLocation(row: row, column: column)] = newValue
		}
	}
	
	func isWithinBounds(location: BoardLocation) -> Bool
	{
		return location.row >= 0 && location.row < boardRows && location.column >= 0 && location.column < boardColumns
	}
	
	func cellVisitor(fn: (BoardLocation) -> ())
	{
		for column in 0..<boardColumns
		{
			for row in 0..<boardRows
			{
				let location = BoardLocation(row: row, column: column)
				fn(location)
			}
		}
	}
	
	func clearBoard()
	{
		cellVisitor
		{
			self[$0] = BoardCellState.Empty
		}
	}
	
	func deselectBoard()
	{
		boardDelegates.invokeDelegates
		{
			$0.cellSelectionCleared()
		}
	}
	
	func addDelegate(delegate: BoardDelegate)
	{
		boardDelegates.addDelegate(delegate)
	}
	
	func countMatches(fn: (BoardLocation) -> Bool) -> Int
	{
		var count = 0
		cellVisitor
		{
			if fn($0)
			{
				count++
			}
		}
		
		return count
	}
	
	func anyCellsMatchCondition(fn: (BoardLocation) -> Bool) -> Bool
	{
		for column in 0..<boardColumns
		{
			for row in 0..<boardRows
			{
				if fn(BoardLocation(row: row, column: column))
				{
					return true
				}
			}
		}
		
		return false
	}
}
