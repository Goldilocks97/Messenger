//
//  ContactsTableController.swift
//  Messenger
//
//  Created by Ivan Pavlov on 10.09.2022.
//

import UIKit

final class ContactsTableController: UITableViewController, ContactsModule {
    
    // MARK: - ContactsModule Implementation
    
    var systemImage: String { return "person.crop.circle.fill" }
    var systemImageColor: UIColor { return .red }
    var itemTitle: String { return "Contacts" }
    var navigationTitle: String { return "Contacts" }
    
    // MARK: - Private Properties
    
    private let cellID = "cellID"
    
    // MARK: - Initialization
    
    init() {
        super.init(style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
