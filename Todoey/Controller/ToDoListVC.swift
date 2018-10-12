//
//  ViewController.swift
//  Todoey
//
//  Created by Amanda Ramirez on 6/20/18.
//  Copyright © 2018 Amanda Ramirez. All rights reserved.
//

import UIKit
import CoreData

class ToDoListVC: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    //we need the object of the class AppDelegate, in order to grab the .viewContext of the .persistentContainer
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK - Tableview Datasource Methods
    //NoteToSelf RE ^: this is called a pragma mark
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
    
        return cell
    }

    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        // force call the datasource methods again so that it reloads the data that is meant to be inside ~ i.e. to view the changed accessory checkmark
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textfield.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
           
            self.saveItems()
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create new item"
            textfield = alertTextfield
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Model Manipulation Methods
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("error saving context \(error)")
        }
        
        tableView.reloadData()
    }
    
    // has default value Item.fetchRequest() in cases where request parameter isn't passed in
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        //to make sure predicate is not nil
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//
//        request.predicate = compoundPredicate
        
        //let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
           itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
}

//MARK: - Search bar methods

extension ToDoListVC : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //[cd] ignores case and diacritic sensitivies when doing string comparisons
        //let predicate = NSPredicate(format: "title CONTAINS[cd] @%", searchBar.text!)
        //request.predicate = predicate
        // below is code refactored
        
        let searchPredicate = NSPredicate(format: "title CONTAINS[cd] @%", searchBar.text!)
        
        //let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        //request.sortDescriptors = [sortDescriptor]
        // below is code refactored
        request.sortDescriptors = [NSSortDescriptor(key: "title CONTAINS[cd] @%", ascending: true)]
        
        //  do {
        //    itemArray = try context.fetch(request)
        // } catch {
        //      print("Error fetching data from context \(error)")
        // }
        // tableView.reloadData()
        
        loadItems(with: request, predicate: searchPredicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            // where you should update user interface elements
            // this code is being run in the foreground
            DispatchQueue.main.async {
                // hides keyboard and searchBar cursor by establishing that searchbar is no longer selected
                // e.i. return to the original state before being activated
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

















