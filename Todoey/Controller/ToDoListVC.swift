//
//  ViewController.swift
//  Todoey
//
//  Created by Amanda Ramirez on 6/20/18.
//  Copyright © 2018 Amanda Ramirez. All rights reserved.
//

import UIKit

class ToDoListVC: UITableViewController {

    var itemArray : [Item]()
    
    //data persistence ~ Using User Defaults (which gets saved in a .plist file) 
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Buy milk"
        itemArray.append(newItem)
        
        //In order to retrieve our data from the User Defaults .plist, must set itemArray as the array inside User Defaults
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
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
        
        //intereting to see how many times this method is called, every time an accessory checkmark is changed ~ recalls every cell for each item in the array at startup and when the tableview is reloaded
        //print("cellForRowAtIndexPath Called")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //will display the proper accessory checkmark for the item being populated in the cell
       
        //if item.done == true {
        //    cell.accessoryType = .checkmark
        //} else {
        //    cell.accessoryType = .none
        //}
        
        //NOTE: the longer version of this is written above ~ we've "refactored" our code to make it better
        // this uses a ternary operator
        //cell.accessoryType = item.done == true ? .checkmark : .none
        cell.accessoryType = item.done ? .checkmark : .none
        
    
        return cell
    }

    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        /*this will associate the checkmark with the specific item title ~ so that the checkmark only marks this item's cell when the cell is reused */
        
        // if itemArray[indexPath.row].done == false {
        //      itemArray[indexPath.row].done = true
        // } else {
        //      itemArray[indexPath.row].done = false
        // }
        
        //NOTE: the longer version of this code is written above ~ we've "refactored" our code to make it better
        // the ! (not) operator sets the done boolean variable opposite of what it currently is
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
        //force call the datasource methods again so that it reloads the data that is meant to be inside ~ i.e. to view the changed accessory checkmark
        tableView.reloadData()
        
        
        //this will deselect the selected cell, no longer shows the highlighted gray 
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARk - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //what will happen once the user clicks the Add Item button on UIAlert
            let newItem = Item()
            newItem.title = textfield.text!
            self.itemArray.append(newItem)
            
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

