//
//  Notes.swift
//  Todo List App
//
//  Created by Carlos Norambuena on 2022-11-29.
//
//  File name: Todo List App
//  Author's name: Carlos Norambuena Perez
//  Student ID: 301265667
//  Date: 2022-12-03
//  App Description: Todo List App (Assignment 5)
//  Version of Xcode: Version 14.1 (14B47b)

import CoreData

@objc(Note)
class Note: NSManagedObject
{
    @NSManaged var id: NSNumber!
    @NSManaged var title: String!
    @NSManaged var desc: String!
    @NSManaged var deletedDate: Date?
    @NSManaged var dueDate: String?
    @NSManaged var isCompleted: Bool
}
