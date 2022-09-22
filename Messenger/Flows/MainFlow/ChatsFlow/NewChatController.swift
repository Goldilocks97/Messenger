//
//  NewChatController.swift
//  Messenger
//
//  Created by Ivan Pavlov on 20.09.2022.
//

import UIKit

final class NewChatController: UIViewController, NewChatModule {
    
    // MARK: - Subviews
    
    private lazy var typeOfChatControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Private", "Public"])
        control.addTarget(self, action: #selector(segmentDidChange), for: .valueChanged)
        control.selectedSegmentIndex = 1
        control.selectedSegmentTintColor = .red
        return control
    }()
    
    private lazy var nicknameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Nickname to add"
        field.backgroundColor = .systemBackground
        field.autocorrectionType = .no
        return field
    }()
    
    private lazy var publicChatName: UITextField = {
        let field = UITextField()
        field.placeholder = "Chat name"
        field.backgroundColor = .systemBackground
        field.autocorrectionType = .no
        return field
    }()

    private lazy var findButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(doFindUser), for: .touchUpInside)
        button.backgroundColor = .red
        return button
    }()
    
    private lazy var findStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nicknameField, findButton])
        stack.distribution = .fillProportionally
        stack.axis = .horizontal
        return stack
    }()
    
    private lazy var addedUsers: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .insetGrouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    private lazy var createChatButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(doCreateChat), for: .touchUpInside)
        button.backgroundColor = .red
        return button
    }()
    
    private lazy var constraits: [ChatType: NSLayoutConstraint] = [
        .privateChat: findStack.topAnchor.constraint(equalTo: typeOfChatControl.bottomAnchor),
        .publicChat: findStack.topAnchor.constraint(equalTo: publicChatName.bottomAnchor)]
    
    private let cellID = "cellID"
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
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

    // MARK: - Configurate View
    
    private func addSubviews() {
        view.addSubview(typeOfChatControl)
        view.addSubview(publicChatName)
        view.addSubview(findStack)
        view.addSubview(addedUsers)
        view.addSubview(createChatButton)
    }

    private func layoutSubviews() {
        typeOfChatControl.translatesAutoresizingMaskIntoConstraints = false
        publicChatName.translatesAutoresizingMaskIntoConstraints = false
        findStack.translatesAutoresizingMaskIntoConstraints = false
        addedUsers.translatesAutoresizingMaskIntoConstraints = false
        createChatButton.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            typeOfChatControl.topAnchor.constraint(equalTo: view.topAnchor),
            typeOfChatControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            typeOfChatControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            publicChatName.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            publicChatName.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            publicChatName.topAnchor.constraint(equalTo: typeOfChatControl.bottomAnchor),
            
            //findStack.topAnchor.constraint(equalTo: publicChatName.bottomAnchor),
            findStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            findStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            addedUsers.topAnchor.constraint(equalTo: findStack.bottomAnchor),
            addedUsers.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addedUsers.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            createChatButton.topAnchor.constraint(equalTo: addedUsers.bottomAnchor),
            createChatButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            createChatButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            createChatButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        typeOfChatControl.selectedSegmentIndex == 0 ? layoutForPrivate() : layoutForPublic()

    }

    private func layoutForPublic() {
        constraits[.privateChat]?.isActive = false
        constraits[.publicChat]?.isActive = true
    }

    private func layoutForPrivate() {
        constraits[.publicChat]?.isActive = false
        constraits[.privateChat]?.isActive = true
    }

    // MARK: - Actions

    @objc
    private func segmentDidChange() {
        switch(typeOfChatControl.selectedSegmentIndex) {
        case 0:
            publicChatName.isHidden = true
            layoutForPrivate()
        case 1:
            publicChatName.isHidden = false
            layoutForPublic()
        default:
            break
        }
    }
    
    @objc
    private func doFindUser() {
        
    }
    
    @objc
    private func doCreateChat() {
    
    }
    
//    // MARK: - Types of Chat
//
//    private enum ChatType {
//
//        case privateType = 0
//        case publicType = 1
//
//    }

}

extension NewChatController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = "USER"
        cell.contentConfiguration = config
        return cell
    }

}

enum ChatType: Int {
    
    case publicChat = 0
    case privateChat = 1
    
}
