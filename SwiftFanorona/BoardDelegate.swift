
//
//  BoardDelegate.swift
//  SwiftFanorona
//
//  Created by Jennifer Duffey on 3/11/15.
//  Copyright (c) 2015 razeware. All rights reserved.
//

import Foundation

protocol BoardDelegate
{
	func cellStateChanged(location: BoardLocation)
	
	func cellSelectionCleared()
}
