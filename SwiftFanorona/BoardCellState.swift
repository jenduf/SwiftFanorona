
//
//  BoardCellState.swift
//  SwiftFanorona
//
//  Created by Jennifer Duffey on 3/11/15.
//  Copyright (c) 2015 razeware. All rights reserved.
//

import Foundation

enum BoardCellState: Int
{
	case Empty, Black, White
	
	func invert() -> BoardCellState
	{
		if self == Black
		{
			return White
		}
		else if self == White
		{
			return Black
		}
		
		assert(self != Empty, "cannot invert the empty state")
		
		return Empty
	}
	
	var stringValue: String
	{
		let states = ["Empty", "Black", "White"]
		
		return states[self.rawValue]
	}
}
