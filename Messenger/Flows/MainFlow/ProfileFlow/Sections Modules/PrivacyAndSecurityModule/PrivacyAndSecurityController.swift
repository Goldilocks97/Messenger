//
//  PrivacyAndSecurityController.swift
//  Messenger
//
//  Created by Ivan Pavlov on 22.09.2022.
//

import UIKit

final class PrivacyAndSecurityController: ProfileSectionBaseController, PrivacyAndSecurityModule {
    
    
    // MARK: - Private Properties
    
    let cellID = "cellID"
    let sections: [PrivacyAndSecuritySection] = [
        .blockedUsers,
        .changePassword,
        .passwordOnLogin
    ]
    
    // MARK: - Subviews
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        return table
    }()
    
    // MARK: - PrivacyAndSecurityModule Implementation
    
    var onSelectedSection: ((PrivacyAndSecuritySection) -> Void)?
        
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addSubviews()
        layoutSubviews()
    }
    
    // MARK: - Configure Subviews
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func layoutSubviews() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    }
    
}

enum PrivacyAndSecuritySection: String {
    
    case blockedUsers = "Blocked Users"
    case changePassword = "Change Password"
    case passwordOnLogin = "Password on Login"
    
}

// MARK: - TableView Supply

extension PrivacyAndSecurityController: UITableViewDataSource, UITableViewDelegate {
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelectedSection?(sections[indexPath.section])
    }
    
    internal func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = sections[indexPath.section].rawValue
        cell.contentConfiguration = config
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
}
