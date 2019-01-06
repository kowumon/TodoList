//
//  ListViewController.swift
//  TODO
//
//  Created by kowumon on 05/01/2019.
//  Copyright © 2019 kowumon. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var todos = [Todo]()
    // computed property
    var sectioned: [[Todo]] {
        let todo = todos.filter { $0.isDone == false }
        let done = todos.filter { $0.isDone == true }
        return [todo, done].filter { $0.count > 0 }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    
    @IBAction func didTapPlus(_ sender: Any) {
        let controller = UIAlertController(title: "Add Todo", message: nil, preferredStyle: .alert)
        controller.addTextField(configurationHandler: nil)
        let action = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self = self else { return }
            if let input = controller.textFields?.first?.text, input.count > 0 {
                let todo = Todo(title: input)
                let before = self.sectioned.count
                self.todos.append(todo)
                let newIndexPath = IndexPath(row: self.sectioned[0].count - 1, section: 0)
                let after = self.sectioned.count
                if before != after {
                    self.tableView.reloadData()
                } else {
                    self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                }
            }
        }
        let cancleAction = UIAlertAction(title: "cancle", style: .cancel)
        controller.addAction(action)
        controller.addAction(cancleAction)
        present(controller, animated: true)
    }
}

extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectioned.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectioned[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.id, for: indexPath) as? TodoCell {
            let todo = sectioned[indexPath.section][indexPath.row]
            
            if todo.isDone {
                cell.accessoryType = .checkmark
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: todo.title)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray, range: NSMakeRange(0, attributeString.length))
                cell.titleLabel.attributedText = attributeString
            } else {
                cell.accessoryType = .none
                cell.titleLabel.attributedText = nil
                cell.titleLabel.text = todo.title
            }
            return cell
        }
        return UITableViewCell()
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "TODO"
        case 1:
            return "DONE"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var todo = sectioned[indexPath.section][indexPath.row]
        todos = todos.filter { $0 != todo }
        todo.isDone = !todo.isDone
    
        let before = self.sectioned.count
        todos.append(todo)
        let after = self.sectioned.count
        
        if before != after {
            tableView.reloadData()
        } else {
            tableView.beginUpdates()
            let deleteIndexPath = IndexPath(row: indexPath.row, section: indexPath.section)
            let newSection = indexPath.section == 0 ? 1 : 0

            let newRow = sectioned[newSection].count - 1
            let insertIndexPath = IndexPath(row: newRow, section: newSection)
            tableView.insertRows(at: [insertIndexPath], with: .automatic)
            tableView.deleteRows(at: [deleteIndexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}
