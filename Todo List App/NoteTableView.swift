//
//  NotesTableView.swift
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

import UIKit
import CoreData

var noteList = [Note]()

class NoteTableView: UITableViewController
{
    var firstLoad = true
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func nonDeletedNotes() -> [Note]
    {
        var noDeleteNoteList = [Note]()
        for note in noteList
        {
            if(note.deletedDate == nil)
            {
                noDeleteNoteList.append(note)
            }
        }
        return noDeleteNoteList
    }
    
    override func viewDidLoad()
    {
        if(firstLoad)
        {
            firstLoad = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results
                {
                    let note = result as! Note
                    noteList.append(note)
                }
            }
            catch
            {
                print("Fetch Failed")
            }
        }
    }
    
    //Function for displaying notes on screen
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let noteCell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteCell
        
        let thisNote: Note!
        thisNote = noteList[indexPath.row]
        
        noteCell.lblTitle.text = thisNote.title
        noteCell.lblDescription.text = thisNote.desc
        noteCell.lblDate.text = thisNote.dueDate
        
        if (thisNote.isCompleted == true) {
            let attributedString = NSMutableAttributedString(string: noteCell.lblTitle.text!)
            attributedString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length-1))
            noteCell.lblTitle.attributedText = attributedString
            
            
        }
        
        return noteCell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return noteList.count
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        tableView.reloadData()
    }
    
    //Edit function
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "editNote", sender: self)
    }
    
    //Go to Detail and Edit function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier == "editNote")
        {
            let indexPath = tableView.indexPathForSelectedRow!
            
            let noteDetail = segue.destination as? ViewController
            
            let selectedNote : Note!
            selectedNote = noteList[indexPath.row]
            noteDetail!.selectedNote = selectedNote
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completionHandler) in
            // delete the item here
            
            noteList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
            
            completionHandler(true)
        }
        
        let editaction = UIContextualAction(style: .normal, title: "Edit") { (_, _, completion) in
            
            
                
            let Main = UIStoryboard(name: "Main", bundle: Bundle.main)
                                            guard let Edit = Main.instantiateViewController(withIdentifier: "Edit") as? ViewController else {
                                                return
                                            }
                                            self.navigationController?.pushViewController(Edit, animated: true)
            
            
        }
            deleteAction.image = UIImage(systemName: "trash")
            deleteAction.backgroundColor = .systemRed
            editaction.image = UIImage(systemName: "note.text")
            editaction.backgroundColor = .systemBlue
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
                
        
                do {
                    try context.save()
                } catch {
                    
                }
                
            let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editaction])
            return configuration
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath:
                            IndexPath) -> UISwipeActionsConfiguration? {
        let actionisCompleted = UIContextualAction(style: .destructive, title: "isComplete") { _, _, _ in
            
            let noteCell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteCell
            
            let thisNote: Note!
            thisNote = noteList[indexPath.row]
            
            noteCell.lblTitle.text = thisNote.title
            noteCell.lblDescription.text = thisNote.desc
            noteCell.lblDate.text = thisNote.dueDate
            
            if (thisNote.isCompleted == true) {
                let attributedString = NSMutableAttributedString(string: noteCell.lblTitle.text!)
                attributedString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length-1))
                noteCell.lblTitle.attributedText = attributedString
                
            }
        }
        
        actionisCompleted.backgroundColor = .systemYellow
        
        return UISwipeActionsConfiguration(actions: [actionisCompleted])
    }
    
}
