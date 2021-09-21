//
//  TableViewController.swift
//  ToDoList(MVC)
//
//  Created by Илья Новиков on 16.09.2021.
//

import UIKit

class TableViewController: UITableViewController {

//    Обозначен  Button для обращения к его параметрам
    @IBOutlet weak var sortButton: UIBarButtonItem!

//    Введена переменная для прямого обращения к методам алерта
    var alert = UIAlertController()

//    Введена константа для обращения к модели и ее методам
    let model = Model()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

//    Количество разделов в таблице
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

//    Количество строк в таблице
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.arrayTask.count
    }

//    Функция для отрисовки таблицы с данными полученных из массива данных в модели.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell  // Присваиваем константе cell нашу кастомную ячейку
        
        cell.delegate = self
        
        let currentTask = model.arrayTask[indexPath.row]
        cell.cellLabel?.text = currentTask.string  // Присваиваем данные из массива в лэйбл ячейки

        return cell
    }

//    Функция для изменения состояния строки при нажатии на нее
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if model.changeState(at: indexPath.row) == true {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            tableView.cellForRow(at: indexPath)?.backgroundColor = .systemGreen
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            tableView.cellForRow(at: indexPath)?.backgroundColor = .none
        }
    }

//    Функция редакции задачи по свайпу
    override func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let editAction = UIContextualAction(style: .normal,
                                        title: "Edit") { [weak self] (action, view, completionHandler) in
            self?.editSelectedTask(indexPath: indexPath)
                                            completionHandler(true)
        }
        editAction.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [editAction])

    }

//    Функция для создания новой задачи,с помощью вызова алерта внутри программы по прожатии кнопки +
    @IBAction func createNewTask(_ sender: Any) {

        alert = UIAlertController(title: "Create new task", message: nil, preferredStyle: .alert)

        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Put your task here"
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
        }
        let createAlertAction = UIAlertAction(title: "Create", style: .default) { (createAlert) in

            guard let unwrTextFieldValue = self.alert.textFields?[0].text else {
                return
            }

            self.model.addTask(task: unwrTextFieldValue)
            self.model.sortByTitle()
            self.tableView.reloadData()
        }

        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(cancelAlertAction)
        alert.addAction(createAlertAction)
        present(alert, animated: true, completion: nil)
        createAlertAction.isEnabled = false
    }

//    Функция для редактирования текущих задач, с помощью вызова алерта по прожатии кнопки редактирования
    func editSelectedTask(indexPath: IndexPath) {
        let cell = tableView(tableView, cellForRowAt: indexPath) as! CustomCell
        alert = UIAlertController(title: "Edit your task", message: nil, preferredStyle: .alert)

        alert.addTextField(configurationHandler: { (textField) -> Void in
            textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
            textField.text = cell.cellLabel.text

        })

        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        let editAlertAction = UIAlertAction(title: "Submit", style: .default) { (createAlert) in

            guard let textFields = self.alert.textFields, textFields.count > 0 else{
                return
            }

            guard let textValue = self.alert.textFields?[0].text else {
                return
            }

            self.model.updateTask(at: indexPath.row, with: textValue)
            self.tableView.reloadData()
        }

        alert.addAction(cancelAlertAction)
        alert.addAction(editAlertAction)
        present(alert, animated: true, completion: nil)
    }



    @objc func alertTextFieldDidChange(_ sender: UITextField) {

            guard let senderText = sender.text, alert.actions.indices.contains(1) else {
                return
            }

            let action = alert.actions[1]
            action.isEnabled = senderText.count > 0
        }

//    Функция для сортировки задач с изменением image на  button
    @IBAction func sortTasks(_ sender: Any) {
        let arrowUp = UIImage(systemName: "arrow.up")
        let arrowDown = UIImage(systemName: "arrow.down")

        model.sortArr = !model.sortArr
        sortButton.image = model.sortArr ? arrowUp : arrowDown

        model.sortByTitle()
        tableView.reloadData()
    }
}

extension TableViewController: CellDelegate {

//    Реализация делегата функции для редактирования задачи через обращение к модели с всплывающим алертом
    func editCell(cell: CustomCell) {

        let indexPath = tableView.indexPath(for: cell)

        guard let selectedIndexPath = indexPath  else {
            return
        }

        self.editSelectedTask(indexPath: selectedIndexPath)
    }

//    Реализация делегата функции для удаления задачи через обращение к модели
    func deleteCell(cell: CustomCell) {

        let indexPath = tableView.indexPath(for: cell)

        guard let selectedIndexPath = indexPath else {
            return
        }

        model.removeTask(at: selectedIndexPath.row)
        tableView.reloadData()
    }
}

