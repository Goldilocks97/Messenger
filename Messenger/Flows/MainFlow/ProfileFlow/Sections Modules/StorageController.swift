//
//  StorageController.swift
//  Messenger
//
//  Created by Ivan Pavlov on 22.09.2022.
//

import UIKit

final class StorageController: ProfileSectionBaseController, StorageModule {
    
    // MARK: - Storage Module Callbacks Implementation
    
    var usedMemory: (Float, Float)? = nil {
        didSet {
            storageUsedStack.removeArrangedSubview(whileLoadingUserMemoryView)
            storageUsedStack.insertArrangedSubview(usedMemoryView, at: 0)
        }
    }
    
    // MARK: - Private properties
    
    let cellID = "cellID"
    
    // MARK: - Subviews
    
    private lazy var storageChatsTable: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        return table
    }()
    
    private lazy var chatsTableLabel: UILabel = {
        let label = UILabel()
        label.text = "CHATS"
        return label
    }()
    
    private lazy var usedMemoryView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .blue
        return contentView
    }()
    
    private lazy var whileLoadingUserMemoryView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    
    private lazy var storageUsedStack: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [whileLoadingUserMemoryView, deleteAllMessagesButton])
        stack.axis = .vertical
        return stack
    }()
    
    private lazy var deleteAllMessagesButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(doDeleteAllMessages), for: .touchUpInside)
        button.backgroundColor = .red
        return button
    }()
    
    // MARK: - Storage Module Methods Implementation
    
    func receiveMemoryUsage(by app: Float, total: Float) {
        print(app, total)
        let appView = UIView()
        appView.backgroundColor = .red
        let totalView = UIView()
        totalView.backgroundColor = .orange
        usedMemoryView.addSubview(appView)
        usedMemoryView.addSubview(totalView)
        
        appView.translatesAutoresizingMaskIntoConstraints = false
        totalView.translatesAutoresizingMaskIntoConstraints = false
        let proportion = app/total
        NSLayoutConstraint.activate([
            appView.topAnchor.constraint(equalTo: usedMemoryView.topAnchor),
            appView.leadingAnchor.constraint(equalTo: usedMemoryView.leadingAnchor),
            appView.bottomAnchor.constraint(equalTo: usedMemoryView.bottomAnchor),
            appView.widthAnchor.constraint(
                equalTo: usedMemoryView.widthAnchor,
                multiplier: CGFloat(proportion)),
        
            totalView.topAnchor.constraint(equalTo: usedMemoryView.topAnchor),
            totalView.leadingAnchor.constraint(equalTo: appView.trailingAnchor),
            totalView.trailingAnchor.constraint(equalTo: usedMemoryView.trailingAnchor),
            totalView.bottomAnchor.constraint(equalTo: usedMemoryView.bottomAnchor)])
        storageUsedStack.removeArrangedSubview(whileLoadingUserMemoryView)
        storageUsedStack.insertArrangedSubview(usedMemoryView, at: 0)
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        addSubviews()
        layoutSubviews()
    }

    // MARK: - Configure Subviews
    
    private func addSubviews() {
        view.addSubview(storageChatsTable)
        view.addSubview(chatsTableLabel)
        view.addSubview(storageUsedStack)
    }
    
    private func layoutSubviews() {
        storageChatsTable.translatesAutoresizingMaskIntoConstraints = false
        chatsTableLabel.translatesAutoresizingMaskIntoConstraints = false
        storageUsedStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            storageChatsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            storageChatsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            storageChatsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            storageChatsTable.heightAnchor.constraint(
                equalTo: view.heightAnchor,
                multiplier: 1/2),
            
            chatsTableLabel.bottomAnchor.constraint(equalTo: storageChatsTable.topAnchor),
            chatsTableLabel.leadingAnchor.constraint(equalTo: storageChatsTable.leadingAnchor),
            chatsTableLabel.trailingAnchor.constraint(equalTo: storageChatsTable.trailingAnchor),
            chatsTableLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/20),
            
            storageUsedStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            storageUsedStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            storageUsedStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            storageUsedStack.bottomAnchor.constraint(equalTo: chatsTableLabel.topAnchor)])
    }
    
    // MARK: - Buttons Actions
    
    @objc
    private func doDeleteAllMessages() {
        
    }
    
}

extension StorageController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = storageChatsTable.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = "AAAAA"
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
}
