//
//  Model.swift
//  ToDoList(MVC)
//
//  Created by Илья Новиков on 16.09.2021.
//

import Foundation

//  Создан класс описывающий итемы внтури массива
class Task {
    var string: String
    var complited: Bool
    
    init(string: String, complited: Bool) {
        self.string = string
        self.complited = complited
    }
}

//  Модель для обработки пользовательских запросов

class Model {
    
//        Массив с задачами
    var arrayTask: [Task] = [Task (string: "rrr", complited: false)]
    
//    Булево значение для обозначения отсортирован ли массив
    var sortArr = false
    
//    Функция для добавления новой задачи в массив
    func addTask(task: String, complited: Bool = false) {
        arrayTask.append(Task(string: task, complited: complited))
    }
        
//    Функция для сортировки массива
    func sortByTitle() {
        arrayTask.sort {
            sortArr ? $0.string > $1.string : $0.string < $1.string
        }
    }
//    Функция для обновления задачи выбранной из списка
    func updateTask(at index: Int, with string: String) {
        arrayTask[index].string = string
    }
    
//    Функция для удаления задачи из массива данных
    func removeTask(at index: Int) {
        arrayTask.remove(at: index)
    }
    
//    Функция для проверки статуса выполнения задачи
    func changeState(at task: Int) -> Bool {
        arrayTask[task].complited = !arrayTask[task].complited
    return arrayTask[task].complited
    }
}
