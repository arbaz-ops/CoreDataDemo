//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Mac on 28/09/2020.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items: [Person]?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchPeople()
    }
    
    func relationshipDemo() {
        let family = Family(context: context)
        family.name = "ABC family"
        
        let person = Person(context: context)
        person.name = "Maggie"
        
        
        
        family.addToPeople(person)
        
        do {
       try self.context.save()
        }catch let error {
            print(error.localizedDescription)
        }
    }
    
    func fetchPeople() {
        
        
        do {
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            
            let sort = NSSortDescriptor(key: "name", ascending: true)
            
            request.sortDescriptors = [sort]
            
            self.items = try context.fetch(request)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
        }catch let error {
            print(error.localizedDescription)
        }
    }

    
    @IBAction func addTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add Person", message: "What's the person name?", preferredStyle: .alert)
        
        alert.addTextField()
        
        let submit = UIAlertAction(title: "Add", style: .default) { (action) in
            let textField = alert.textFields![0]
            
            let newPerson = Person(context: self.context)
            newPerson.name = textField.text
            newPerson.age = 20
            newPerson.gender = "Male"
            
            do {
           try self.context.save()
            }catch let error {
                print(error.localizedDescription)
            }
            self.fetchPeople()
        }
        
        alert.addAction(submit)
        self.present(alert, animated: true, completion: nil)
    }
    

}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let person = items![indexPath.row]
        cell.textLabel?.text = person.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = self.items![indexPath.row]
        
        let alert = UIAlertController(title: "Edit Person", message: "Edit Name", preferredStyle: .alert)
        
        alert.addTextField()
        
        let textField = alert.textFields![0]
        
        textField.text = person.name
        
        let submit = UIAlertAction(title: "Edit", style: .default) { (action) in
            let textField = alert.textFields![0]
            
            person.name = textField.text
            
            do {
           try self.context.save()
            }catch let error {
                print(error.localizedDescription)
            }
            self.fetchPeople()
            
            
        }
        alert.addAction(submit)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            let personToRemove = self.items![indexPath.row]
            
            self.context.delete(personToRemove)
            
            do {
           try self.context.save()
            }catch let error {
                print(error.localizedDescription)
            }
            self.fetchPeople()
            
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}

