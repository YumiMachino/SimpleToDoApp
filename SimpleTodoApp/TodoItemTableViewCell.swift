//
//  TodoItemTableViewCell.swift
//  SimpleTodoApp
//
//  Created by Yumi Machino on 2021/01/09.
//

import UIKit

class TodoItemTableViewCell: UITableViewCell {
    
    let checkmarkLabel: UILabel = {
        let btn = UILabel()
        btn.setContentHuggingPriority(.required, for: .horizontal)
        return btn
    }()

    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = .boldSystemFont(ofSize: 20)
        lb.numberOfLines = 1
        return lb
    }()
    
    let imgLabel = UILabel()
    
    var priorityLevel:priorityLevel = .medium
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
            let hStackView = HorizontalStackView(arrangedSubviews: [checkmarkLabel,titleLabel, imgLabel],spacing: 16, alignment: .fill,distribution: .fill)
            contentView.addSubview(hStackView)
        hStackView.matchParent(padding: .init(top: 8, left: 16, bottom: 16, right: 8))
      
        }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // call this function in TVC
    func update(with toDoItem: ToDoItem) {
        checkmarkLabel.text = toDoItem.isCompletedIndicator ? "✔️" : ""
        titleLabel.text = toDoItem.title
        priorityLevel = toDoItem.priorityLevel
    }
        
    

}
