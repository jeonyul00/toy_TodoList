//
//  ViewController.swift
//  ToDoApp_CoreData
//
//  Created by 전율 on 2023/12/14.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: "TodoCell", bundle: nil), forCellReuseIdentifier: "TodoCell")
            self.fetchData()
            self.tableView.reloadData()
        }
    }
    
    let appdelegate = (UIApplication.shared.delegate as! AppDelegate)
    var todoList = [TodoList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "To Do List"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action:#selector(createTodo) )
    }
    
    
    func fetchData() -> Void {
        let fetchRequest = TodoList.fetchRequest()
        let context = appdelegate.persistentContainer.viewContext
        do{
            todoList = try context.fetch(fetchRequest)
        } catch{
            print(error)
        }
    }
    
    @objc func createTodo(){
        let detailVC = DetailTodoViewController(nibName: "DetailTodoViewController", bundle: nil)
        detailVC.delegate = self
        self.present(detailVC, animated: true)
    }
    
}

extension ViewController: DetailTodoViewControllerProtocol {
    func didFinishSave() {
        self.fetchData()
        self.tableView.reloadData()
    }
}

extension ViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodoCell
        cell.topTitle.text = todoList[indexPath.row].title
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd hh:mm:ss"
        if let todoDate = todoList[indexPath.row].date {
            cell.bottomDate.text = formatter.string(from: todoDate)
        }
        let level = PriorityLevel(rawValue: todoList[indexPath.row].priorityLevel)
        cell.priorityLevel.backgroundColor = level?.color ?? .black

        return cell
    }
    
    // 셀 선택 시
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailTodoViewController(nibName: "DetailTodoViewController", bundle: nil)
        detailVC.delegate = self
        detailVC.todoItem = todoList[indexPath.row]
        self.present(detailVC, animated: true)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    
}

