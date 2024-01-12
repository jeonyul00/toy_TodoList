//
//  DetailTodoViewController.swift
//  ToDoApp_CoreData
//
//  Created by 전율 on 2023/12/14.
//

import UIKit
import CoreData

enum PriorityLevel:Int16 {
    case level1 = 1
    case level2 = 2
    case level3 = 3
}

extension PriorityLevel {
    var color:UIColor {
        switch self {
        case .level1:
            return .green
        case .level2:
            return .orange
        case .level3:
            return .red
        }
    }
    var title: String {
        switch self {
        case .level1:
            return "Low"
        case .level2:
            return "Normal"
        case .level3:
            return "High"
        }
        
    }
}

protocol DetailTodoViewControllerProtocol {
    func didFinishSave()
}

class DetailTodoViewController: UIViewController {
    
    @IBOutlet weak var priorityLevel1: UIButton! {
        didSet {
            priorityLevel1.layer.cornerRadius = CGFloat(halfButtonHeight)
            priorityLevel1.setTitle(PriorityLevel.level1.title, for: .normal)
        }
    }
    @IBOutlet weak var priorityLevel2: UIButton! {
        didSet {
            priorityLevel2.layer.cornerRadius = CGFloat(halfButtonHeight)
            priorityLevel2.setTitle(PriorityLevel.level2.title, for: .normal)
        }
    }
    @IBOutlet weak var priorityLevel3: UIButton! {
        didSet {
            priorityLevel3.layer.cornerRadius = CGFloat(halfButtonHeight)
            priorityLevel3.setTitle(PriorityLevel.level3.title, for: .normal)
        }
    }
    @IBOutlet weak var datePickerHeight: NSLayoutConstraint!
    @IBOutlet weak var openClouseButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    let halfButtonHeight = 20
    var isPickerOpen = true
    var priorityLevel = PriorityLevel.level1
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let appdelegate = (UIApplication.shared.delegate as! AppDelegate)
    var delegate:DetailTodoViewControllerProtocol?
    var todoItem: TodoList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openClouseButton.setTitle("clouse", for: .normal)
        if let todoItem = todoItem {
            saveButton.setTitle("update", for: .normal)
            titleTextField.text = todoItem.title
            datePicker.date = todoItem.date ?? Date()
            let level = PriorityLevel(rawValue: todoItem.priorityLevel)
            priorityLevel = level ?? .level1
            priorityLevel1.backgroundColor = .clear
            priorityLevel2.backgroundColor = .clear
            priorityLevel3.backgroundColor = .clear
            switch level {
            case .level1:
                priorityLevel1.backgroundColor = level?.color
            case .level2:
                priorityLevel2.backgroundColor = level?.color
            case .level3:
                priorityLevel3.backgroundColor = level?.color
            case .none:
                break
            }
        } else {
            deleteButton.isHidden = true
        }
    }
    
    @IBAction func selectLevel(_ sender: UIButton) {
        priorityLevel1.backgroundColor = .clear
        priorityLevel2.backgroundColor = .clear
        priorityLevel3.backgroundColor = .clear
        
        if sender.currentTitle == PriorityLevel.level1.title {
            sender.backgroundColor = PriorityLevel.level1.color
            priorityLevel = .level1
        } else if sender.currentTitle == PriorityLevel.level2.title {
            sender.backgroundColor = PriorityLevel.level2.color
            priorityLevel = .level2
        } else {
            sender.backgroundColor = PriorityLevel.level3.color
            priorityLevel = .level3
        }
        
    }
    
    @IBAction func save(_ sender: Any) {
        if let todoItem = todoItem {
            todoItem.title = titleTextField.text
            todoItem.priorityLevel = priorityLevel.rawValue
            todoItem.date = datePicker.date
            appdelegate.saveContext()
            delegate?.didFinishSave()
            self.dismiss(animated: true)
            return
        }
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "TodoList", in: context) else { return }
        let managedObject = NSManagedObject(entity: entityDescription, insertInto: context) as! TodoList
        managedObject.title = titleTextField.text
        managedObject.priorityLevel = priorityLevel.rawValue
        managedObject.date = datePicker.date
        managedObject.id = UUID()
        
        let appdelegate = (UIApplication.shared.delegate as! AppDelegate)
        appdelegate.saveContext()
        
        delegate?.didFinishSave()
        self.dismiss(animated: true)
    }
    
    @IBAction func deleteItem(_ sender: Any) {
        if let todoItem = todoItem {
            context.delete(todoItem)
            appdelegate.saveContext()
            delegate?.didFinishSave()
            self.dismiss(animated: true)
        }
        
    }
    
    @IBAction func pickerOpenOrClose(_ sender: Any) {
        isPickerOpen.toggle()
        UIView.animate(withDuration: 0.25) {
            if self.isPickerOpen {
                self.datePickerHeight.priority = UILayoutPriority(100)
                self.openClouseButton.setTitle("clouse", for: .normal)
            } else {
                self.datePickerHeight.priority = UILayoutPriority(1000)
                self.openClouseButton.setTitle("open", for: .normal)
            }
            self.view.layoutIfNeeded()
        }
    }
}
