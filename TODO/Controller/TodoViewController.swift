//
//  ViewController.swift
//  TODO
//
//  Created by Ace on 2019/2/8.
//  Copyright © 2019年 Ace. All rights reserved.
//

import UIKit

class TodoViewController: UITableViewController {
    var itemArray :[ItemDataModel] = [ItemDataModel]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
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
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
        saveItem()
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
            self.saveItem()
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
    
    func saveItem() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch {
            print("错误代码\(error)")
        }
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([ItemDataModel].self, from: data)
            }catch{
                print("解码Item错误\(error)")
            }
        }
        
    }
}

