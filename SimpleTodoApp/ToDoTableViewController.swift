//
//  ToDoTableViewController.swift
//  SimpleTodoApp
//
//  Created by Yumi Machino on 2021/01/09.
//

import UIKit

class ToDoTableViewController: UITableViewController, AddEditToDoTVCDelegate {
    let cellId = "toDoItemCell"
    
    // Data Source
    var toDoItems: [ToDoItem] = [
        ToDoItem(title:"Take a walk", priorityLevel: priorityLevel.high, isCompletedIndicator: true),
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
     
    }

    @objc
    func addToDoItem(){
        // present modally (AddEditToDoItemTVC)
        let addEditTVC = AddEditToDoItemTableViewController(style: .insetGrouped)
        addEditTVC.delegate = self
        let addEditNC = UINavigationController(rootViewController: addEditTVC)
        present(addEditNC,animated: true,completion: nil)
    }
    
    func add(_ toDoItem: ToDoItem) {
        toDoItems.append(toDoItem)
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
    }
    
    
    func edit(_ toDoItem: ToDoItem) {
        if let indexPath = tableView.indexPathForSelectedRow {
            switch indexPath.section {
            case 0:
                if let row = tableView.indexPathForSelectedRow?.row {
                    // update model
                    highPriorityItem.remove(at: row)
                    highPriorityItem.insert(toDoItem, at: row)
                    // update view
                    tableView.reloadRows(at: [indexPath], with: .automatic)
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
        }
    }
    
    
    
    
    
    func sortItemsPerPriority(){
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
        toDoItems = []
        toDoItems = highPriorityItem + mediumPriorityItem  + lowPriorityItem

    }
    
    
    
    //CHECKMARK
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addEditTVC = AddEditToDoItemTableViewController(style: .insetGrouped)
        addEditTVC.delegate = self
        switch indexPath.section {
        case 0:
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
        
        
        
        
        
        
        print(indexPath)        // [0,0]-> get object
        // update model and view
        switch indexPath.section {
        case 0:
            var item = highPriorityItem[indexPath.row]
            print(item)
            if item.isCompletedIndicator == false {
                item.isCompletedIndicator = true
                print(item)
                // update view
                
            } else if item.isCompletedIndicator == true {
                item.isCompletedIndicator = false
            }
        case 1:
            var item = mediumPriorityItem[indexPath.row]
            if item.isCompletedIndicator == false {
                item.isCompletedIndicator = true
            } else if item.isCompletedIndicator == true {
                item.isCompletedIndicator = false
            }
        case 2:
            var item = lowPriorityItem[indexPath.row]
            if item.isCompletedIndicator == false {
                item.isCompletedIndicator = true
            } else if item.isCompletedIndicator == true {
                item.isCompletedIndicator = false
            }
        default:
            print("")
        }
//
//        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
//            // delegate and update model?
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
//
//        }
    }
    

    
    //SECTION HEADER
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(sections[section])"
    }
    
    // DELETE
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            toDoItems.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//    }


 

}
