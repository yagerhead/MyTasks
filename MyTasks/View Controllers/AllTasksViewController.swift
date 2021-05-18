//
//  AllTasksTableViewController.swift
//  MyTasks
//
//  Created by Manu Safarov on 16.05.2021.
//

import UIKit

class AllTasksViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    let cellIdentifier = "TasksCell"
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        
        //The user returns to the task from which the application was closed (to improve the UX)
        let index = dataModel.indexOfSelectedTask
        if index >= 0 && index < dataModel.lists.count {
            let tasks = dataModel.lists[index]
            performSegue(withIdentifier: "ShowTasks", sender: tasks)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTasks" {
            let controller = segue.destination as! TaskListsViewController
            controller.tasks = sender as? Tasks
        } else if segue.identifier == "AddNewTask" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }
    
    // MARK: - Table View Delegates
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let tasks = dataModel.lists[indexPath.row]
        cell.textLabel!.text = tasks.name
        cell.textLabel?.font = UIFont(name: "Poppins-Medium", size: 17)
        cell.accessoryType = .detailDisclosureButton
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataModel.indexOfSelectedTask = indexPath.row
        
        let tasks = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowTasks", sender: tasks)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self
        
        let tasks = dataModel.lists[indexPath.row]
        controller.tasksListToEdit = tasks
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - List Detail View Controller Delegates
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding tasks: Tasks) {
        let newRowIndex = dataModel.lists.count
        dataModel.lists.append(tasks)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing tasks: Tasks) {
        if let index = dataModel.lists.firstIndex(of: tasks) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel!.text = tasks.name
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Navigation Controller Delegates
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if viewController === self {
            dataModel.indexOfSelectedTask = -1
        }
    }
}
