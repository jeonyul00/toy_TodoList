//
//  TodoCell.swift
//  ToDoApp_CoreData
//
//  Created by 전율 on 2023/12/14.
//

import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet weak var priorityLevel: UIView! {
        didSet {
            priorityLevel.layer.cornerRadius = 15
        }
    }
    @IBOutlet weak var topTitle: UILabel!
    @IBOutlet weak var bottomDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
