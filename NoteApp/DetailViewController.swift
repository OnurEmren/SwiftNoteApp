//
//  DetailViewController.swift
//  NoteApp
//
//  Created by Severus Snape on 4.03.2023.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var selectedTitle = ""
    var selectedId : UUID?
    let dataPicker = UIDatePicker()
    let pickerViewData = ["Acil!", "Önemli", "Orta", "Sonraya Kalsın"]
    private var pickerColor = UIColor()
    

    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateTextView: UITextView!
    @IBOutlet weak var descTextView: UITextView!

    
    @IBOutlet weak var myPickerView: UIPickerView!
    @IBOutlet weak var pickerLabel: UILabel!
  
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        titleLabel?.layer.cornerRadius = 10.0
        titleLabel?.layer.masksToBounds = true
        
        pickerLabel.setCornerRadius()
        descTextView.setCornerRadius()
        titleTextField.setCornerRadius()
        titleLabel.setCornerRadius()
        dateTextView.setCornerRadius()
        
        fetchData()
        createDatePicker()
        
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerViewData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerViewData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let itemSelected = pickerViewData[row]
        
        pickerLabel.text = itemSelected
        

        if row == 0{
            pickerLabel.backgroundColor = .red
        }
        if row == 1{
            pickerLabel.backgroundColor = .orange
        }
        if row == 2{
            pickerLabel.backgroundColor = .yellow
        }

        if row == 3{
            pickerLabel.backgroundColor = .green
        }
        
    }
    
    
    
    
    
    
    func fetchData(){
        if selectedTitle != "" {
            
            if let uuidString  = selectedId?.uuidString{
                
                myPickerView.isHidden = true
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
                fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
                
                fetchRequest.returnsObjectsAsFaults = false
                
                do{
                    let savedData = try context.fetch(fetchRequest)
                    
                    if savedData.count > 0 {
                        for saved in savedData as! [NSManagedObject]{
                            if let title = saved.value(forKey: "title") as? String{
                                titleTextField.text = title
                            }
                            
                            if let desc = saved.value(forKey: "desc") as? String{
                                descTextView.text = desc
                                
                            }
                            
                            if let date = saved.value(forKey: "date") as? String{
                                dateTextView.text = date
                                
                            }
                            
                            if let picker = saved.value(forKey: "picker") as? String{
                                pickerLabel.text =  picker
                            }
                            
                            
                            
                        }
                    }
                    
                } catch{
                    print("Hata var")
                }
                
            }
            
        } else{
            titleTextField.text = ""
            descTextView.text = ""
            dateTextView.text = ""
            pickerLabel.text = "Ne Kadar Önemli?"
            
            
        }
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    //Date Logic
    func createToolbar() -> UIToolbar{
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(selectDoneButton))
        toolbar.setItems([doneButton], animated: true)
        
        return toolbar
    }
    
    @objc func selectDoneButton(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateTextView.textAlignment = .center
        self.dateTextView.text = dateFormatter.string(from: dataPicker.date)
        self.view.endEditing(true)
    }
    
    func createDatePicker(){
        dataPicker.preferredDatePickerStyle = .wheels
        dataPicker.datePickerMode = .date
        dateTextView?.inputView = dataPicker
        dateTextView.inputAccessoryView = createToolbar()
        
    }
    
    //Save Logic
    
    @IBAction func saveButton(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context)
        note.setValue(titleTextField.text!, forKey: "title")
        note.setValue(descTextView.text!, forKey: "desc")
        note.setValue(UUID(), forKey: "id")
        note.setValue(dateTextView.text!, forKey: "date")
        note.setValue(pickerLabel.text, forKey: "picker")
        
        
        do{
            try context.save()
            print("Kaydedildi")
        } catch{
            print("HATA!")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("Save"), object: nil)
        self.navigationController?.popViewController(animated: true )
    }
    
  
    
   
    
}
extension UIView {
    func setCornerRadius() {
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
    }
}


