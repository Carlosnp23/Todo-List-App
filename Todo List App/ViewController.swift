//
//  ViewController.swift
//  Todo List App
//
//  Created by Carlos Norambuena on 2022-11-29.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    
    var selectedNote: Note? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if(selectedNote != nil)
        {
            txtTitle.text = selectedNote?.title
            txtDescription.text = selectedNote?.desc
        }
    }


    @IBAction func saveAction(_ sender: Any)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

            let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
            let newNote = Note(entity: entity!, insertInto: context)
            newNote.id = noteList.count as NSNumber
            newNote.title = txtTitle.text
            newNote.desc = txtDescription.text
            do
            {
                try context.save()
                noteList.append(newNote)
                
                let alertController = UIAlertController(title: "Note Created", message: "", preferredStyle: .alert)
                // Create OK button
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    
                    // Code in this block will trigger when OK button tapped.
                    self.navigationController?.popViewController(animated: true)

                    print("Ok button (Created)");
                    
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)

            }
            catch
            {
                print("context save error")
            }
    }
    
    @IBAction func btnUpdate(_ sender: Any) {
        
        
        let alertController = UIAlertController(title: "Update", message: "Are you sure you want to Update this Note?", preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results
                {
                    let note = result as! Note
                    if(note == self.selectedNote)
                    {
                        note.title = self.txtTitle.text
                        note.desc = self.txtDescription.text
                        try context.save()
                        
                        let alertController = UIAlertController(title: "Updated Note", message: "", preferredStyle: .alert)
                        // Create OK button
                        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                            
                            // Code in this block will trigger when OK button tapped.
                            self.navigationController?.popViewController(animated: true)

                            print("Ok button tapped");
                            
                        }
                        alertController.addAction(OKAction)
                        self.present(alertController, animated: true, completion:nil)
                        
                    }
                }
            }
            catch
            {
                print("Fetch Failed")
            }
            
            print("Ok button (Updated)");
            
        }
        alertController.addAction(OKAction)
        
        // Create Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button (Updated)");
        }
        alertController.addAction(cancelAction)
        
        // Present Dialog message
        self.present(alertController, animated: true, completion:nil)
        
    }
    
    
    @IBAction func DeleteNote(_ sender: Any)
    {
        let alertController = UIAlertController(title: "Delete", message: "Are you sure you want to delete this Note?", preferredStyle: .alert)
        
        // Create OK button
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            
            // Code in this block will trigger when OK button tapped.
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results
                {
                    let note = result as! Note
                    if(note == self.selectedNote)
                    {
                        note.deletedDate = Date()
                        try context.save()
                        
                        let alertController = UIAlertController(title: "Note Deleted", message: "", preferredStyle: .alert)
                        // Create OK button
                        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                            
                            // Code in this block will trigger when OK button tapped.
                            self.navigationController?.popViewController(animated: true)
                            
                            print("Ok button tapped");
                            
                        }
                        alertController.addAction(OKAction)
                        self.present(alertController, animated: true, completion:nil)
                        
                    }
                }
            }
            catch
            {
                print("Fetch Failed")
            }
            
            print("Ok button (Delete)");
            
        }
        alertController.addAction(OKAction)
        
        // Create Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("Cancel button (Delete))");
        }
        alertController.addAction(cancelAction)
        
        // Present Dialog message
        self.present(alertController, animated: true, completion:nil)
    
    }
    
    
    @IBAction func btnCancel(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)

    }
    
    
}
