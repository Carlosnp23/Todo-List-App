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
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var switchIsCompleted: UISwitch!
    
    @IBOutlet weak var lblTitleError: UILabel!
    @IBOutlet weak var lblDescriptionError: UILabel!
    @IBOutlet weak var lblDateError: UILabel!

    
    var selectedNote: Note? = nil
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        datePicker.isHidden = true
        datePicker.isEnabled = false
        
        if(selectedNote != nil)
        {
            txtTitle.text = selectedNote?.title
            txtDescription.text = selectedNote?.desc
            datePicker.isHidden = false
            datePicker.isEnabled = true
        }
    }


    @IBAction func saveAction(_ sender: Any)
    {
        // Creates Dates to save in coredata
        var myDate = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd / MMM / yyyy  h:mm a"
        myDate = dateFormatter.string(from: datePicker.date)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext

            let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
            let newNote = Note(entity: entity!, insertInto: context)
            
        newNote.id = noteList.count as NSNumber
        
        if (txtTitle.text!.isEmpty) {
            lblTitleError.text = "The Title should not be empty"
        }
        else if (txtDescription.text!.isEmpty) {
            lblTitleError.text = "Correct"
            lblDescriptionError.text = "The Description should not be empty"
        }
        else if (datePicker.isHidden == true || datePicker.isEnabled == false) {
            lblTitleError.text = "Correct"
            lblDescriptionError.text = "Correct"
            lblDateError.text = "The Date should not be empty"
        }
        else {
            lblTitleError.text = "Correct"
            lblDescriptionError.text = "Correct"
            lblDateError.text = "Correct"


            newNote.title = txtTitle.text
            newNote.desc = txtDescription.text
            newNote.date = myDate
            newNote.isCompleted = false
            
            
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
        
    }
    
    @IBAction func btnUpdate(_ sender: Any) {
        
        var isCompleted = NSString(string: "true")
        
        // Update Dates to save in coredata
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd / MMM / yyyy  h:mm a"
        var myDate = dateFormatter.string(from: self.datePicker.date)
        
        if (self.txtTitle.text!.isEmpty) {
            self.lblTitleError.text = "The Title should not be empty"
        }
        else if (self.txtDescription.text!.isEmpty) {
            self.lblTitleError.text = "Correct"
            self.txtDescription.text = "The Description should not be empty"
        }
        else if (self.datePicker.isHidden == true || self.datePicker.isEnabled == false) {
            self.lblTitleError.text = "Correct"
            self.lblDescriptionError.text = "Correct"
            self.lblDateError.text = "The Date should not be empty"
        }
        else if (switchIsCompleted.isEnabled == false) {
            isCompleted = NSString(string: "false")
        }
        else {
            self.lblTitleError.text = "Correct"
            self.lblDescriptionError.text = "Correct"
            self.lblDateError.text = "Correct"
            
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
                            note.date = myDate
                            note.isCompleted = isCompleted.boolValue
                            
                            try context.save()
                            
                            let alertController = UIAlertController(title: "Updated Note", message: "", preferredStyle: .alert)
                            // Create OK button
                            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                                
                                func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                                    let pass = segue.destination as! NoteTableView
                                    pass.compl = String(isCompleted)
                                }
                                
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
    
    
    @IBAction func switchDate(_ sender: UISwitch) {
        
        if (sender.isOn) {
            datePicker.isEnabled = true
            datePicker.isHidden = false
        }
        else {
            datePicker.isEnabled = false
            datePicker.isHidden = true
        }
    }
    
    
    @IBAction func switchIsCompleted(_ sender: UISwitch) {
        
        let attributedString = NSMutableAttributedString(string: txtTitle.text!)

        if (sender.isOn) {
            attributedString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length-1))
        }
        else {
            let attributedString = NSMutableAttributedString(string: txtTitle.text!)
            attributedString.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, attributedString.length-1))
        }
        txtTitle.attributedText = attributedString
    }
    
}
