//
//  ToDoTableViewController.swift
//  SimpleTodoApp
//
//  Created by Yumi Machino on 2021/01/09.
//

import UIKit

class ToDoTableViewController: UITableViewController, AddEditToDoTVCDelegate {
    let cellId = "toDoItemCell"
    
    var toDoItems: [ToDoItem] = [
        ToDoItem(title:"Take a walk", priorityLevel: priorityLevel.high, isCompletedIndicator: false),
        ToDoItem(title:"Study Design pattern", priorityLevel: priorityLevel.high, isCompletedIndicator: false),
        ToDoItem(title:"Study iOS", priorityLevel: priorityLevel.medium, isCompletedIndicator: false),
        ToDoItem(title:"Update Resume", priorityLevel: priorityLevel.medium, isCompletedIndicator: false),
        ToDoItem(title:"Watch Netflix", priorityLevel: priorityLevel.low, isCompletedIndicator: false),
        ToDoItem(title:"Finish Unit6", priorityLevel: priorityLevel.high, isCompletedIndicator: false),
        ToDoItem(title:"Do laundry", priorityLevel: priorityLevel.medium, isCompletedIndicator: false),
        ToDoItem(title:"Go to grocery shopping", priorityLevel: priorityLevel.low, isCompletedIndicator: false)
    ]
    
  
    var sections:[String] = ["High Priority", "Medium Priority", "Low Priority"]

    var highPriorityItem:[ToDoItem] = []
    var mediumPriorityItem:[ToDoItem] = []
    var lowPriorityItem:[ToDoItem] = []
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "ToDo Items"

        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToDoItem))
        tableView.register(TodoItemTableViewCell.self, forCellReuseIdentifier: cellId)
       
        // automatically calculate height from estimated height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        sortItemsPerPriority()
//        tableView.allowsMultipleSelectionDuringEditing = true


    }
    

    
    @objc
    func addToDoItem(){
        // present modally (AddEditToDoItemTVC)
        let addEditTVC = AddEditToDoItemTableViewController(style: .insetGrouped)
        addEditTVC.delegate = self
        let addEditNC = UINavigationController(rootViewController: addEditTVC)
        present(addEditNC,animated: true,completion: nil)
    }
    
    func toDoitemsUpdate(){
        toDoItems = []
        toDoItems = highPriorityItem + mediumPriorityItem + lowPriorityItem
    }
    
    // delegate method from TVC: adding new item
    func add(_ toDoItem: ToDoItem) {
        toDoItems.append(toDoItem)
        print("added item: \(toDoItem)")
        
        switch toDoItem.priorityLevel {
        case .high:
            highPriorityItem.append(toDoItem)
            tableView.insertRows(at: [IndexPath(row: highPriorityItem.count - 1, section: 0)], with: .automatic)
        case .medium:
            mediumPriorityItem.append(toDoItem)
            tableView.insertRows(at: [IndexPath(row: mediumPriorityItem.count - 1, section: 1)], with: .automatic)
        case .low:
            lowPriorityItem.append(toDoItem)
            tableView.insertRows(at: [IndexPath(row: lowPriorityItem.count - 1, section: 2)], with: .automatic)
        }
        toDoitemsUpdate()
    }
    
    // delegate method from TVC: editin existing item
    func edit(_ toDoItem: ToDoItem) {
        print("editing")
     
        // nil
        print(tableView.indexPathForSelectedRow?.row )
        
        if let indexPath = tableView.indexPathForSelectedRow {
            print(indexPath)            // [0,1]
            switch indexPath.section {
            case 0:
                print("highPriorityItem")
                if let row = tableView.indexPathForSelectedRow?.row {
                    // update model
                    highPriorityItem.remove(at: row)
                    highPriorityItem.insert(toDoItem, at: row)
                    
                    // update view
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                    tableView.reloadData()
                    tableView.deselectRow(at: indexPath, animated: true)
                }
            case 1:
                if let row = tableView.indexPathForSelectedRow?.row {
                    mediumPriorityItem.remove(at: row)
                    mediumPriorityItem.insert(toDoItem, at: row)
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                    tableView.deselectRow(at: indexPath, animated: true)
                }
            case 2:
                if let row = tableView.indexPathForSelectedRow?.row {
                    lowPriorityItem.remove(at: row)
                    lowPriorityItem.insert(toDoItem, at: row)
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                    tableView.deselectRow(at: indexPath, animated: true)
                }
            default:
            print("Editing error")
            }
        
            tableView.reloadData()
        }
    }
    

    func sortItemsPerPriority() {
        // Create different array depends on priorities
        for item in toDoItems {
            if item.priorityLevel == .high {
                highPriorityItem.append(item)
            } else if item.priorityLevel == .medium {
                mediumPriorityItem.append(item)
            } else if item.priorityLevel == .low {
                lowPriorityItem.append(item)
            } else {
                print("error: no priority defined")
            }
        }
//        var sortedToDoItems:[[ToDoItem]] = []
//        sortedToDoItems.append(highPriorityItem)
//        sortedToDoItems.append(mediumPriorityItem)
//        sortedToDoItems.append(lowPriorityItem)
//        print(sortedToDoItems)
//        return sortedToDoItems
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    // ROW NUMBER PER SECTION
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Count Row items depends on priority level
        switch section {
        case  0:
            let highPriorityItems = toDoItems.filter{ $0.priorityLevel == .high}
            return highPriorityItems.count
        case  1:
            let mediumPriorityItems = toDoItems.filter{ $0.priorityLevel == .medium}
            return mediumPriorityItems.count
        case  2:
            let lowPriorityItems = toDoItems.filter{ $0.priorityLevel == .low}
            return lowPriorityItems.count
        default:
            return 0
        }
    }

    
    // REUSABLE CELL
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        toDoitemsUpdate()
        
        // Create reusableCell
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId , for: indexPath) as! TodoItemTableViewCell
        cell.showsReorderControl = true
   
        switch indexPath.section {
        case 0:
            // Fetch the data for the row
            let toDoItem = highPriorityItem[indexPath.row]
            // Configure the cell's contents with data from the fetched object
            cell.update(with: toDoItem)
            cell.accessoryType = .detailDisclosureButton
            return cell
        case 1:
            let toDoItem = mediumPriorityItem[indexPath.row]
            cell.update(with: toDoItem)
            cell.accessoryType = .detailDisclosureButton
            return cell
        case 2:
            let toDoItem = lowPriorityItem[indexPath.row]
            cell.update(with: toDoItem)
            cell.accessoryType = .detailDisclosureButton
            return cell
        default:
            cell.titleLabel.text = "error: no priority defined"
            return cell
        }
    }
    
     

    // MOVE ROW: use with showsReorderControl
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

        // Update model
        switch sourceIndexPath.section {
        case 0:
            var removeItem = highPriorityItem.remove(at: sourceIndexPath.row)
            switch destinationIndexPath.section {
            case 0:
                highPriorityItem.insert(removeItem, at: destinationIndexPath.row)
            case 1:
                removeItem.priorityLevel = .medium
                mediumPriorityItem.insert(removeItem, at: destinationIndexPath.row)
            case 2:
                removeItem.priorityLevel = .low
                lowPriorityItem.insert(removeItem, at: destinationIndexPath.row)
            default:
                print("")
            }
        case 1:
            var removeItem = mediumPriorityItem.remove(at: sourceIndexPath.row)
            switch destinationIndexPath.section {
            case 0:
                removeItem.priorityLevel = .high
                highPriorityItem.insert(removeItem, at: destinationIndexPath.row)
            case 1:
                mediumPriorityItem.insert(removeItem, at: destinationIndexPath.row)
            case 2:
                removeItem.priorityLevel = .low
                lowPriorityItem.insert(removeItem, at: destinationIndexPath.row)
            default:
                print("")
            }
        case 2:
            var removeItem = lowPriorityItem.remove(at: sourceIndexPath.row)
            switch destinationIndexPath.section {
            case 0:
                removeItem.priorityLevel = .high
                highPriorityItem.insert(removeItem, at: destinationIndexPath.row)

            case 1:
                removeItem.priorityLevel = .medium
                mediumPriorityItem.insert(removeItem, at: destinationIndexPath.row)
            case 2:
                lowPriorityItem.insert(removeItem, at: destinationIndexPath.row)
            default:
                print("")
            }
        default:
            print("")
        }
        // update model
        toDoitemsUpdate()

    }
    
    
    
    //DESELECT ROW
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // ACCESSORY BUTTON
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let addEditTVC = AddEditToDoItemTableViewController(style: .insetGrouped)
        addEditTVC.delegate = self
        
        switch indexPath.section {
        case 0:
            // addEditTVCのitemに設定 -> edit中のToDoItem確認
            addEditTVC.item = highPriorityItem[indexPath.row]           // copy
        case 1:
            addEditTVC.item = mediumPriorityItem[indexPath.row]
        case 2:
            addEditTVC.item = lowPriorityItem[indexPath.row]
        default:
            print("")
        }
        
        let addEditNC = UINavigationController(rootViewController: addEditTVC)
        present(addEditNC,animated: true,completion: nil)
    
    }
    
    
    //SECTION HEADER
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(sections[section])"
    }
    
    // DELETE
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            print("Delete")
            switch indexPath.section {
            case 0:
                highPriorityItem.remove(at: indexPath.row)
                print(highPriorityItem)
                print(indexPath)
                tableView.reloadRows(at: [indexPath], with: .automatic)
                
            case 1:
                mediumPriorityItem.remove(at: indexPath.row)
                tableView.reloadRows(at: [indexPath], with: .automatic)
                
            case 2:
                lowPriorityItem.remove(at: indexPath.row)
                tableView.reloadRows(at: [indexPath], with: .automatic)
            
            default:
                print("error")
            }
            toDoitemsUpdate()
            tableView.reloadData()

        }
    }


 

}
