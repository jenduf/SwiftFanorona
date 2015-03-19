
//
//  MoveDirection.swift
//  SwiftFanorona
//
//  Created by Jennifer Duffey on 3/11/15.
//  Copyright (c) 2015 razeware. All rights reserved.
//

enum MoveDirection: Int
{
	case North, South, East, West, NorthEast, NorthWest, SouthEast, SouthWest, None
	
	func invert() -> MoveDirection
	{
		switch self
		{
			case .North:
				return .South
			
			case .South:
				return .North
				
			case .East:
				return .West
				
			case .West:
				return .East
				
			case .NorthEast:
				return .SouthWest
				
			case .NorthWest:
				return .SouthEast
				
			case .SouthEast:
				return .NorthWest
				
			case .SouthWest:
				return .NorthEast
				
			case .None:
				return .None
		}
	}

	func move(loc: BoardLocation) -> BoardLocation
	{
		switch self
		{
			case .North:
				return BoardLocation(row: loc.row - 1, column: loc.column)
			
			case .South:
				return BoardLocation(row: loc.row + 1, column: loc.column)
			
			case .East:
				return BoardLocation(row: loc.row, column: loc.column + 1)
			
			case .West:
				return BoardLocation(row: loc.row, column: loc.column - 1)
			
			case .NorthEast:
				return BoardLocation(row: loc.row - 1, column: loc.column + 1)
			
			case .NorthWest:
				return BoardLocation(row: loc.row - 1, column: loc.column - 1)
			
			case .SouthEast:
				return BoardLocation(row: loc.row + 1, column: loc.column + 1)
			
			case .SouthWest:
				return BoardLocation(row: loc.row + 1, column: loc.column - 1)
			
			case .None:
				return BoardLocation(row: 0, column: 0)
		}
	}
	
	func canMoveDirection(fromLocation: BoardLocation) -> Bool
	{
		if(self == .NorthEast || self == .NorthWest || self == .SouthEast || self == .SouthWest)
		{
			if fromLocation.column % 2 == 0
			{
				if fromLocation.row % 2 == 0
				{
					return true
				}
			}
			else
			{
				if fromLocation.row % 2 != 0
				{
					return true
				}
			}
		}
		else
		{
			return true
		}
		
		return false
	}
	
	static func getDirectionForMove(fromLocation: BoardLocation, toLocation: BoardLocation) -> MoveDirection
	{
		if fromLocation.column == toLocation.column
		{
			if toLocation.row > fromLocation.row
			{
				return .South
			}
			else
			{
				return .North
			}
		}
		else if fromLocation.row == toLocation.row
		{
			if toLocation.column > fromLocation.column
			{
				return .East
			}
			else
			{
				return .West
			}
		}
		else if fromLocation.row > toLocation.row
		{
			if toLocation.column < fromLocation.column
			{
				return .NorthWest
			}
			else
			{
				return .NorthEast
			}
		}
		else if fromLocation.row < toLocation.row
		{
			if toLocation.column < fromLocation.column
			{
				return .SouthWest
			}
			else
			{
				return .SouthEast
			}
		}
		
		return .None
	}
	
	static let directions: [MoveDirection] = [
		.North, .South, .East, .West, .NorthEast, .NorthWest, .SouthWest, .SouthEast
	]
}

