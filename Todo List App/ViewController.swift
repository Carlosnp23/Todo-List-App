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
    
    var selectedNote: Notes? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(selectedNote != nil)
        {
            txtTitle.text = selectedNote?.title
            txtDescription.text = selectedNote?.desc
        }
    }
        
    
    @IBAction func saveAction(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        if(selectedNote == nil)
        {
            let entity = NSEntityDescription.entity(forEntityName: "Notes", in: context)
            let newNote = Notes(entity: entity!, insertInto: context)
            newNote.id = todoList.count as NSNumber
            newNote.title = txtTitle.text
            newNote.desc = txtDescription.text
            do
            {
                try context.save()
                todoList.append(newNote)
                navigationController?.popViewController(animated: true)
            }
            catch
            {
                print("context save error")
            }
        }
        else //edit
                {
                    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
                    do {
                        let results:NSArray = try context.fetch(request) as NSArray
                        for result in results
                        {
                            let note = result as! Notes
                            if(note == selectedNote)
                            {
                                note.title = txtTitle.text
                                note.desc = txtDescription.text
                                try context.save()
                                navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                    catch
                    {
                        print("Fetch Failed")
                    }
                }
    }
    
    @IBAction func btnSwitchDate(_ sender: UISwitch) {
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    @IBAction func btnSwitchCompleted(_ sender: UISwitch) {
    }
    
    @IBAction func btnCancel(_ sender: UIButton) {
    }
    
    
}

