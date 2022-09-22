//
//  ChatInformationController.swift
//  Messenger
//
//  Created by Ivan Pavlov on 21.09.2022.
//

import UIKit

final class PublicChatInformationController: UIViewController, PublicChatInformationModule {

    // MARK: - Private Properties

    private var addedUsers = [String]()
    private let cellID = "CellID"

    // MARK: - Subviews

    private lazy var backBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "Back",
            style: .plain,
            target: self,
            action: #selector(doBackButton))
        button.tintColor = .red
        return button
    }()

    private lazy var addedUsersTable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.dataSource = self
        table.delegate = self
        //table.tableHeaderView = addedUsersTableLabel
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        return table
    }()
    
    private lazy var addedUsersLabel: UILabel = {
        let label = UILabel()
        label.text = "Chat members"
        label.backgroundColor = .red
        label.textColor = .black
        label.sizeToFit()
        return label
    }()
    
    private lazy var addedUsersStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [addedUsersLabel, addedUsersTable])
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var leaveDeleteChatButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(doLeaveDeleteChat), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteMessagesFromDeviceButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(doDeleteMessageFromDevice), for: .touchUpInside)
        return button
    }()

    // MARK: - ChatInformationModule Implementation
    
    var onBackButton: (() -> Void)?
    var onLeaveDeleteButton: (() -> Void)?
    var onDeleteMessagesFromDevice: (() -> Void)?
    
    // MARK: - Initialization

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        addSubviews()
        layoutSubviews()
    }
    
    // MARK: - Configure Subview
    
    private func addSubviews() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backBarButton
        navigationItem.title = "Public"
        view.addSubview(addedUsersStack)
        view.addSubview(leaveDeleteChatButton)
        view.addSubview(deleteMessagesFromDeviceButton)
//        view.addSubview(addedUsersTableLabel)
//        view.addSubview(addedUsersTable)
    }
    
    private func layoutSubviews() {
        addedUsersStack.translatesAutoresizingMaskIntoConstraints = false
        leaveDeleteChatButton.translatesAutoresizingMaskIntoConstraints = false
        deleteMessagesFromDeviceButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            addedUsersStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            addedUsersStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addedUsersStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            addedUsersStack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/2),
        
            deleteMessagesFromDeviceButton.topAnchor.constraint(
                equalTo: addedUsersStack.bottomAnchor),
            deleteMessagesFromDeviceButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            deleteMessagesFromDeviceButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            deleteMessagesFromDeviceButton.heightAnchor.constraint(
                equalTo: view.heightAnchor,
                multiplier: 1/10),
        
            leaveDeleteChatButton.topAnchor.constraint(
                equalTo: deleteMessagesFromDeviceButton.bottomAnchor,
                constant: 10),
            leaveDeleteChatButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            leaveDeleteChatButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            leaveDeleteChatButton.bottomAnchor.constraint(
                equalTo: view.bottomAnchor)])
    }
    
    // MARK: - Buttons Actions
    
    @objc
    private func doBackButton() {
        onBackButton?()
    }
    
    @objc
    private func doLeaveDeleteChat() {
        onLeaveDeleteButton?()
    }
    
    @objc
    private func doDeleteMessageFromDevice() {
        onDeleteMessagesFromDevice?()
    }

}

extension PublicChatInformationController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = "USER"
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 25
    }
    
}
