//
//  ViewController.swift
//  Todoey
//
//  Created by Amanda Ramirez on 6/20/18.
//  Copyright © 2018 Amanda Ramirez. All rights reserved.
//

import UIKit

class ToDoListVC: UITableViewController {

    var itemArray = ["Study", "Do Laundry", "Buy Groceries"]
    
    //data persistence ~ Using User Defaults (which gets saved in a .plist file) 
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //In order to retrieve our data from the User Defaults .plist, must set itemArray as the array inside User Defaults
        if let items = defaults.array(forKey: "TodoListArray") as! [String] {
            itemArray = items
        }
        // Do any additional setup after loading the view, typically from a nib.
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
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }

    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        //add/remove accessory checkmark when cell is selected/unselected
        if tableView.cellForRow(at: indexPath)?.accessoryType == .none {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        
        //this will deselect the selected cell, no longer shows the highlighted gray 
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARk - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //what will happen once the user clicks the Add Item button on UIAlert
            self.itemArray.append(textfield.text!)
            
            //this saves the itemArray in the User Defaults .plist file as "TodoListArray"
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.tableView.reloadData()
        }
        
        //adds an alert textfield so that the user can type in their todo
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create new item"
            textfield = alertTextfield
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

