//
//  AddEditToDoItemTableViewCell.swift
//  SimpleTodoApp
//
//  Created by Yumi Machino on 2021/01/10.
//

import UIKit

class AddEditToDoItemTableViewCell: UITableViewCell {
    
    let itemTextField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(itemTextField)
        itemTextField.matchParent(padding: .init(top: 8, left: 8, bottom: 8, right: 8))
        }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
