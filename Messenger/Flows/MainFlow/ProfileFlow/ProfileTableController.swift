//
//  ProfileTableController.swift
//  Messenger
//
//  Created by Ivan Pavlov on 10.09.2022.
//

import UIKit

final class ProfileTableController: UITableViewController, ProfileModule {
    
    // MARK: - Private Properties
    
    private let sectionsNames = [
        "Security",
        "Storage",
        "Appearance",
        "Ask a question",
        "Logout"]
    
    private let cellID = "cellID"
    
    // MARK: - ProfileModule Implementation
    
    var systemImage: String { return "brain.head.profile" }
    var systemImageColor: UIColor { return .red }
    var itemTitle: String { return "Profile" }
    var navigationTitle: String { return "Nickname" }
    var navigationBarRightItem: UIBarButtonItem? { return nil }
    
    
    // MARK: - Initialization
    
    init() {
        super.init(style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.alwaysBounceVertical = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - TableView Supply
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = sectionsNames[indexPath.section]
        cell.contentConfiguration = config
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsNames.count
    }
    
}
