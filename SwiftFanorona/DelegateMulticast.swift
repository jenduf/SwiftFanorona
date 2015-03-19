
//
//  DelegateMulticast.swift
//  SwiftFanorona
//
//  Created by Jennifer Duffey on 3/11/15.
//  Copyright (c) 2015 razeware. All rights reserved.
//

class DelegateMulticast<T>
{
	private var delegates = [T]()
	
	func addDelegate(delegate: T)
	{
		delegates.append(delegate)
	}
	
	func invokeDelegates(invocation: (T) -> ())
	{
		for delegate in delegates
		{
			invocation(delegate)
		}
	}
}
