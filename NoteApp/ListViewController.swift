//
//  ViewController.swift
//  NoteApp
//
//  Created by Severus Snape on 4.03.2023.
//

import UIKit
import CoreData

class ListViewController: UIViewController, UIColorPickerViewControllerDelegate {
    
    
    
    @IBOutlet weak var noteListTableView : UITableView!
    private var titleArray = [String]()
    private var idArray = [UUID]()
    private var dateArray = [String]()
    private var pickerArray = [String]()
    
    var selectedTitle = ""
    var selectedId : UUID?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        
        let customColor = UIColor(red: 248.0/255.0, green: 234.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        view.backgroundColor = customColor
        
        noteListTableView.delegate = self
        noteListTableView.dataSource = self
        
        
        self.noteListTableView.backgroundColor = UIColor.systemGray6
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(toDetailVS))
        
        fetchData()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(fetchData),
                                               name: NSNotification.Name(rawValue: "Save"),
                                               object: nil)
    }
    
    @objc func toDetailVS(){
        selectedTitle = ""
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
    
    
    @objc func fetchData(){
        
        titleArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        dateArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let noteRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        noteRequest.returnsObjectsAsFaults = false
        
        
        do{
            let savedData = try context.fetch(noteRequest)
            
            if savedData.count > 0 {
                for saved in savedData as! [NSManagedObject]{
                    if let title = saved.value(forKey: "title") as? String{
                        titleArray.append(title)
                    }
                    
                    if let id = saved.value(forKey: "id") as? UUID {
                        idArray.append(id)
                    }
                    
                    if let date = saved.value(forKey: "date") as? String {
                        dateArray.append(date)
                    }
                    
                    if let picker = saved.value(forKey: "picker") as? String{
                        pickerArray.append(picker)
                    }
                    
                }
                
                noteListTableView.reloadData()
            } else{
                
            }
            
            
            
        } catch{
            
            print("Hata")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            let destination = segue.destination as! DetailViewController
            destination.selectedTitle = selectedTitle
            destination.selectedId = selectedId
            
        }
    }
}

extension UIViewController {
    
    func ahmet() {
        
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titleArray.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  UITableViewCell()
        
        
        
        cell.textLabel?.text = titleArray[indexPath.row]
        let customColor = UIColor(red: 248.0/255.0, green: 234.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        cell.backgroundColor = customColor
        
        
        let backgroundView = UIView(frame: tableView.bounds)
        backgroundView.backgroundColor = UIColor(red: 248.0/255.0, green: 234.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        
        
        tableView.backgroundView = backgroundView
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedTitle = titleArray[indexPath.row]
        selectedId = idArray[indexPath.row]
        
        let customColor = UIColor(red: 248.0/255.0, green: 234.0/255.0, blue: 238.0/255.0, alpha: 1.0)
        view.backgroundColor = customColor
        
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        
        if editingStyle == .delete{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            let uuidString = idArray[indexPath.row].uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
                let datas = try context.fetch(fetchRequest)
                if datas.count > 0 {
                    for deletedData in datas as! [NSManagedObject]{
                        if let id = deletedData.value(forKey: "id") as? UUID{
                            if id == idArray[indexPath.row]{
                                
                                context.delete(deletedData)
                                titleArray.remove(at: indexPath.row)
                                idArray.remove(at: indexPath.row)
                                self.noteListTableView.reloadData()
                                
                                do{
                                    try context.save()
                                }catch{
                                    print("Hata")
                                }
                                break
                            }
                        }
                    }
                }
                
            }catch{
                print("Silme işleminde Hata!")
            }
            
            
        }
    }
}
