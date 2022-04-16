//
//  ViewController.swift
//  CoreData_FrameWork
//
//  Created by Mohamed Kamal on 15/04/2022.
//

import UIKit

class ViewController: UIViewController{

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var tableView: UITableView!
    private var names: [Model] = []
    private let object = DataModel.shared
    private var selectedName = ""
    override func viewWillAppear(_ animated: Bool) {
        readDataFromCoreData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    //MARK: - select value from segmented control
    @IBAction func recurranceChanged(sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex){
        case 0:
            if userName.text != ""{
                showAlert("Name Will Be Added", 0)
            }
            else{
                showAlert("Insert Name First")
            }
        case 1:
            if userName.text != "" && selectedName != ""{
                showAlert("Name Will Be Updated", 1)
            }
            else{
                showAlert("Select Name From List First")
            }
        case 2:
            if userName.text != "" {
                showAlert("Name Will Be Deleted", 2)
            }
            else{
                showAlert("Select Name From List First")
            }
        default:
            break
        }

        sender.selectedSegmentIndex = -1
        
    }
    //MARK: - read data from core data
    private func readDataFromCoreData(){
        names.removeAll()
        for name in object.readData(){
            names.append(Model(name: name.value(forKey: "name") as? String))
        }
        tableView.reloadData()
    }
    //MARK: - show alert
    private func showAlert(_ message: String,_ number: Int = -1){
        let alert = UIAlertController(title: "Alert!", message: message, preferredStyle: .alert)
        let alertActionOK = UIAlertAction(title: "Ok", style: .default) { _ in
            if number != -1 {
                if number == 0 {
                    if self.object.saveName(data: Model(name: self.userName.text)){
                        self.readDataFromCoreData()
                    }
                }
                else if number == 1 && self.selectedName != "" {
                    if self.object.readData(data: self.userName.text!, selectedData: self.selectedName).count > 0{
                        self.readDataFromCoreData()
                    }
                }
                else if number == 2 {
                    if self.object.readData(data: self.userName.text!, selectedData: self.userName.text!, selectedNumber: 2).count > 0{
                        self.readDataFromCoreData()
                    }
                }
                self.userName.text = ""
                self.selectedName = ""
            }
        }
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(alertActionOK)
        alert.addAction(alertActionCancel)
        present(alert, animated: true)
    }
    
}
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableViewCell
        cell?.setupCell(data: names[indexPath.row])
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selected = names[indexPath.row].name else{return}
        selectedName = selected
        userName.text = selected
    }
    
    
}

