//
//  TableViewCell.swift
//  CoreData_FrameWork
//
//  Created by Mohamed Kamal on 15/04/2022.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var userNameCell: UILabel!
    func setupCell(data: Model){
        userNameCell.text = data.name
    }
}
