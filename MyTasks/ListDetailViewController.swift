//
//  ListDetailViewController.swift
//  MyTasks
//
//  Created by Manu Safarov on 18.05.2021.
//

import UIKit

protocol ListDetailViewControllerDelegate: AnyObject {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding tasks: Tasks)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing tasks: Tasks)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var doneBarButton: UIBarButtonItem!
    
    weak var delegate: ListDetailViewControllerDelegate?
    var tasksListToEdit: Tasks?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tasks = tasksListToEdit {
            title = "Edit Task"
            textField.text = tasks.name
            doneBarButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let tasks = tasksListToEdit {
            tasks.name = textField.text!
            delegate?.listDetailViewController(self, didFinishEditing: tasks)
        } else {
            let tasks = Tasks(name: textField.text!)
            delegate?.listDetailViewController(self, didFinishAdding: tasks)
        }
    }
    
    // MARK: - Table View Delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    // MARK: - Text Field Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
}
