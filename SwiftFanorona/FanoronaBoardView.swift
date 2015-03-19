//
//  FanoronaBoardView.swift
//  SwiftFanorona
//
//  Created by Jennifer Duffey on 3/11/15.
//  Copyright (c) 2015 razeware. All rights reserved.
//

import UIKit

class FanoronaBoardView: UIView
{
	
	required init(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	init(frame: CGRect, board: FanoronaBoard)
	{
		super.init(frame: frame)
		
		let rowHeight = frame.size.height / CGFloat(board.boardRows)
		let columnWidth = frame.size.width / CGFloat(board.boardColumns)
		
		board.cellVisitor
		{
			(location: BoardLocation) in
			let left = CGFloat(location.column) * columnWidth
			let top = CGFloat(location.row) * rowHeight
			let squareFrame = CGRect(x: left, y: top, width: columnWidth, height: rowHeight)
			
			let square = BoardSquare(frame: squareFrame, location: location, board: board)
			self.addSubview(square)
			
			board.addSquare(square)
				
		}
	}

}
