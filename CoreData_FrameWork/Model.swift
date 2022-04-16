//
//  Model.swift
//  CoreData_FrameWork
//
//  Created by Mohamed Kamal on 15/04/2022.
//

import Foundation
import UIKit
import CoreData
struct Model{
    var name: String?
}
class DataModel{
    static let shared = DataModel()
    private init(){}
    //MARK: - Save Data
    func saveName(data: Model)->Bool{
        //1 to access core data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return false}
        //2 reference from container That contain data
        let manageContext = appDelegate.persistentContainer.viewContext
        //3 access entity to handle data
        guard let entity = NSEntityDescription.entity(forEntityName: "UserName", in: manageContext) else{return false}
        //4 the gate to save, update and delete data
        let record = NSManagedObject(entity: entity, insertInto: manageContext)
        //5 set data
        record.setValue(data.name, forKey: "name")
        //6 save data
        do{
            try manageContext.save()
        }catch{
            return false
        }
        
        return true
    }
    //MARK: - Read Data
    func readData(data: String = "", selectedData: String = "", selectedNumber: Int = 1)->[NSManagedObject]{
        var names: [NSManagedObject] = []
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            let manageContext = appDelegate.persistentContainer.viewContext
            let fechRequest = NSFetchRequest<NSManagedObject>(entityName: "UserName")
            do{
                if data == ""{
                    names = try manageContext.fetch(fechRequest)
                }
                else{
                    if selectedNumber == 1{
                        let predicate = NSPredicate(format: "name = %@", selectedData)
                        fechRequest.predicate = predicate
                        names = try manageContext.fetch(fechRequest)
                        updateData(data: data, records: names)
                    }
                    else if selectedNumber == 2{
                        let predicate = NSPredicate(format: "name = %@", selectedData)
                        fechRequest.predicate = predicate
                        names = try manageContext.fetch(fechRequest)
                        if names.count > 0{
                            manageContext.delete(names[0])
                        }
                    }
                    try manageContext.save()
                }
            }catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
        return names
    }
    //MARK: - Update Data
    func updateData(data: String, records: [NSManagedObject]){
        if records.count > 0{
            for object in records{
                object.setValue(data, forKey: "name")
                
            }
        }
    }
    
}

