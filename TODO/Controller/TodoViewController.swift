//
//  ViewController.swift
//  TODO
//
//  Created by Ace on 2019/2/8.
//  Copyright © 2019年 Ace. All rights reserved.
//

import UIKit
import CoreData

class TodoViewController: UITableViewController {
    var itemArray :[Item] = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
            let item = Item(context: self.context)
            item.title = textField.text!
            item.done = false
            self.itemArray.append(item)
            self.saveItem()
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
        do{
            try context.save()
        }catch{
            print("save error\(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest()) {
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("读取错误:\(error)")
        }
        tableView.reloadData()
    }
}
extension TodoViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()

        request.predicate = NSPredicate(format: "tiele CONTAINS[c] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            searchBar.resignFirstResponder()
        }
    }
}
