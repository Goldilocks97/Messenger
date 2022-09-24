//
//  NewChatController.swift
//  Messenger
//
//  Created by Ivan Pavlov on 20.09.2022.
//

import UIKit

final class NewChatController: UIViewController, NewChatModule {
    
    // MARK: - NewChatModule Callbacks Implementation
    
    var onCreatePublicChat: ((String, [Int]) -> Void)?
    var onCreatePrivateChat: ((Int) -> Void)?
    var onFindUser: ((String) -> Void)?
    
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
    
    private lazy var addedUsersTable: UITableView = {
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
    
    // MARK: - Private Properties
    
    private lazy var constraits: [ChatType: NSLayoutConstraint] = [
        .privateChat: findStack.topAnchor.constraint(equalTo: typeOfChatControl.bottomAnchor),
        .publicChat: findStack.topAnchor.constraint(equalTo: publicChatName.bottomAnchor)]
    private let cellID = "cellID"
    private var lastSearchNickname = String()
    private var addedUsers = [(String, Int)]() {
        didSet { addedUsersTable.reloadData() }
    }
    
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
    
    // MARK: - NewChatModule Methods Implementation
    
    func userSearchResponse(response: FindUserID.Response) {
        switch(response) {
        case .found(let id):
            addedUsers.append((lastSearchNickname, id))
        case .notFound:
            print("not found")
        }
        nicknameField.text = nil
    }

    // MARK: - Configurate View
    
    private func addSubviews() {
        view.addSubview(typeOfChatControl)
        view.addSubview(publicChatName)
        view.addSubview(findStack)
        view.addSubview(addedUsersTable)
        view.addSubview(createChatButton)
    }

    private func layoutSubviews() {
        typeOfChatControl.translatesAutoresizingMaskIntoConstraints = false
        publicChatName.translatesAutoresizingMaskIntoConstraints = false
        findStack.translatesAutoresizingMaskIntoConstraints = false
        addedUsersTable.translatesAutoresizingMaskIntoConstraints = false
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
            
            addedUsersTable.topAnchor.constraint(equalTo: findStack.bottomAnchor),
            addedUsersTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addedUsersTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            createChatButton.topAnchor.constraint(equalTo: addedUsersTable.bottomAnchor),
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
        addedUsersTable.reloadData()
    }
    
    @objc
    private func doFindUser() {
        guard let nick = nicknameField.text else {
            return
        }
        lastSearchNickname = nick
        onFindUser?(nick)
    }
    
    @objc
    private func doCreateChat() {
        if addedUsers.isEmpty {
            return
        }
        switch(typeOfChatControl.selectedSegmentIndex) {
        case 0:
            onCreatePrivateChat?(addedUsers[0].1)
        case 1:
            guard
                let chatName = publicChatName.text,
                addedUsers.count >= 2 // TODO: Check it in coordinator
            else { return }
            onCreatePublicChat?(chatName, addedUsers.map { $0.1 })
        default:
            break
        }
    }
}

extension NewChatController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if addedUsers.isEmpty {
            return 0
        }
        return typeOfChatControl.selectedSegmentIndex == 0 ? 1 : addedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = addedUsers[indexPath.row].0
        cell.contentConfiguration = config
        return cell
    }

}

enum ChatType: Int {
    
    case publicChat = 0
    case privateChat = 1
    
}
