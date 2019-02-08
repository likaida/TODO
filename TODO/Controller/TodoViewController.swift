//
//  ViewController.swift
//  TODO
//
//  Created by Ace on 2019/2/8.
//  Copyright © 2019年 Ace. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {
    var itemArray = [ItemDataModel]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let newItem = ItemDataModel()
        newItem.title = "111"
        itemArray.append(newItem)
        
        let newItem2 = ItemDataModel()
        newItem2.title = "222"
        itemArray.append(newItem2)
        
        let newItem3 = ItemDataModel()
        newItem3.title = "333"
        itemArray.append(newItem3)
        for index in 4...100 {
            let newItem = ItemDataModel()
            newItem.title = "第条\(index)事物"
            itemArray.append(newItem)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell",for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if itemArray[indexPath.row].done==false{
            itemArray[indexPath.row].done = true
        }else{
            itemArray[indexPath.row].done = false
        }
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "添加一个新的TODO项目", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "添加项目", style: .default){
            action in
            let item = ItemDataModel()
            item.title = textField.text!
            self.itemArray.append(item)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
        }
        alert.addTextField{
            alertTextField in
            alertTextField.placeholder = "创建一个项目..."
            textField = alertTextField
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        
    }
}

