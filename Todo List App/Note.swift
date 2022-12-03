//
//  Notes.swift
//  Todo List App
//
//  Created by Carlos Norambuena on 2022-11-29.
//

import CoreData

@objc(Note)
class Note: NSManagedObject
{
    @NSManaged var id: NSNumber!
    @NSManaged var title: String!
    @NSManaged var desc: String!
    @NSManaged var deletedDate: Date?
    @NSManaged var date: String?

}
