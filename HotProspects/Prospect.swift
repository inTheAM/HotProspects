//
//  Contact.swift
//  HotProspects
//
//  Created by Ahmed Mgua on 9/21/20.
//

import Foundation

class Prospect:	Identifiable,	Codable	{
	let id	=	UUID()
	var name	=	"Anonymous"
	var emailAddress	=	""
	fileprivate(set)	var isContacted	=	false
	
}

class Prospects:	ObservableObject	{
	@Published private(set) var people:	[Prospect]
	static let saveKey	=	"SavedData"
	
	init()	{
		if let data	=	UserDefaults.standard.data(forKey: Self.saveKey)	{
			if let decoded	=	try?	JSONDecoder().decode([Prospect].self, from: data)	{
				self.people	=	decoded
				return
			}
		}
		self.people	=	[]
	}
	
	func toggle(_	prospect:	Prospect)	{
		objectWillChange.send()
		prospect.isContacted.toggle()
		save()
	}
	
	private func save()	{
		if let encoded	=	try?	JSONEncoder().encode(people)	{
			UserDefaults.standard.setValue(encoded, forKey: Self.saveKey)
		}
	}
	
	func add(_	prospect:	Prospect)	{
		people.append(prospect)
		save()
	}
}
