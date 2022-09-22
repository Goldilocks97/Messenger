//
//  ProfileTableController.swift
//  Messenger
//
//  Created by Ivan Pavlov on 10.09.2022.
//

import UIKit

final class ProfileTableController: UITableViewController, ProfileModule {
    
    // MARK: - Private Properties
    
    private let sections: [Section] = [
        .security,
        .storage,
        .appearance,
        .askQuestion,
        .logout]
    
    private let cellID = "cellID"

    // MARK: - ProfileModule Implementation
    
    var systemImage: String { return "brain.head.profile" }
    var systemImageColor: UIColor { return .red }
    var itemTitle: String { return "Profile" }
    var navigationTitle: String { return "Nickname" }
    var navigationBarRightItem: UIBarButtonItem? { return nil }
    var onSectionSelected: ((Section) -> Void)?
    
    
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
        config.text = sections[indexPath.section].rawValue
        cell.contentConfiguration = config
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSectionSelected?(sections[indexPath.section])
    }
    
}

enum Section: String {

    case security = "Security"
    case storage = "Storage"
    case appearance = "Appearance"
    case askQuestion = "Ask a question"
    case logout = "Logout"

}
