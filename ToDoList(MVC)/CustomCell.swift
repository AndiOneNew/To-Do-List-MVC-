//
//  CustomCell.swift
//  ToDoList(MVC)
//
//  Created by Илья Новиков on 16.09.2021.
//

import UIKit

protocol CellDelegate {
    func editCell(cell: CustomCell)
    func deleteCell(cell: CustomCell)
}

class CustomCell: UITableViewCell {
    
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate: CellDelegate?
    
   
    @IBAction func editCell(_ sender: UIButton) {
        delegate?.editCell(cell: self)
    }
    
    @IBAction func deleteCell(_ sender: UIButton) {
        delegate?.deleteCell(cell: self)
    }
}
