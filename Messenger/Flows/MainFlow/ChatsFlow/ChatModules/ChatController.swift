//
//  ChatController.swift
//  Messenger
//
//  Created by Ivan Pavlov on 10.09.2022.
//

import UIKit

final class ChatController: UIViewController, ChatModule {
        
    var onBackPressed: (() -> Void)?
    
    // MARK: - ChatModule Implementation
    
    func receiveNewMessages(_ messages: [Message]) {
        var animated = false
        if self.messages.isEmpty {
            let groupedMessage = Dictionary(grouping: messages) { (element) -> Date in
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy-MM-dd"
                return dateFormat.date(from: element.date) ?? Date()
            }
            let sortedKeys = groupedMessage.keys.sorted()
            for key in sortedKeys {
                self.messages.append(groupedMessage[key] ?? [])
            }
        } else {
            let message = messages[0]
            if self.messages.last?.first?.date == message.date {
                self.messages[self.messages.count - 1].append(message)
            } else {
                self.messages.append([message])
            }
            animated = true
        }
        tableView.reloadData()
        tableView.scrollToRow(
            at: IndexPath(
                row: self.messages[self.messages.count-1].count-1,
                section: self.messages.count-1),
            at: .bottom,
            animated: animated)
    }

    var onSendMessage: ((String, Int) -> Void)?
    var onChatInformationPressed: ((Int, ChatType) -> Void)?

    var chatID: Int {
        get { return prchatID }
        set { }
    }
    
    // MARK: - Private properties
    
    private var messages = [[Message]]() {
        didSet {

//            let indexPath = IndexPath(
//                row: messages[messages.count-1].count-1,
//                section: messages.count-1)
//            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    let cellID = "cellID"
    let headerID = "headerID"
    let type: ChatType
    let chatName: String
    let prchatID: Int
    
    // MARK: - View Subviews
    
    private lazy var backBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(doBackButton))
        button.tintColor = .red
        return button
    }()

    private lazy var bottomContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
//        view.layer.borderWidth = 0.5
//        view.layer.backgroundColor = UIColor.systemGray5.cgColor
        return view
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MessageCell.self, forCellReuseIdentifier: cellID)
        tableView.register(DateHeader.self, forHeaderFooterViewReuseIdentifier: self.headerID)
        //tableView.backgroundColor = .white
        return tableView
    }()

    private lazy var messageField: UITextField = {
        let field = UITextField()
        field.placeholder = "Message"
        return field
    }()
    
    private lazy var sendMessageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(doSendMessage), for: .touchUpInside)
        return button
    }()
    
    private lazy var informationNavigationBarItem: UIBarButtonItem = {
        let item = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(doInformationButton))
        item.tintColor = .red
        return item
    }()
    
    // MARK: - Initialization
    
    init(name: String, ID: Int, type: ChatType) {
        self.type = type
        self.chatName = name
        self.prchatID = ID
        super.init(nibName: nil, bundle: nil)
        tableView.allowsSelection = false
        subscribeToKeyboardNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.title = chatName
        tableView.separatorStyle = .none
        addSubviews()
        layoutSubviews()
    }
    
    // MARK: - Configurate View
    
    private func addSubviews() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backBarButton
        navigationItem.rightBarButtonItem = informationNavigationBarItem
        view.addSubview(bottomContentView)
        bottomContentView.addSubview(messageField)
        bottomContentView.addSubview(sendMessageButton)
        view.addSubview(tableView)
    }
    
    private func layoutSubviews() {
        bottomContentView.translatesAutoresizingMaskIntoConstraints = false
        messageField.translatesAutoresizingMaskIntoConstraints = false
        sendMessageButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomContentView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.99/11),
        
            tableView.bottomAnchor.constraint(equalTo: bottomContentView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
        
            messageField.topAnchor.constraint(equalTo: bottomContentView.topAnchor),
            messageField.bottomAnchor.constraint(equalTo: bottomContentView.bottomAnchor),
            messageField.leadingAnchor.constraint(equalTo: bottomContentView.leadingAnchor),
            messageField.widthAnchor.constraint(
                equalTo: bottomContentView.widthAnchor,
                multiplier: 4/5),
            sendMessageButton.leadingAnchor.constraint(equalTo: messageField.trailingAnchor),
            sendMessageButton.trailingAnchor.constraint(equalTo: bottomContentView.trailingAnchor),
            sendMessageButton.topAnchor.constraint(equalTo: bottomContentView.topAnchor),
            sendMessageButton.bottomAnchor.constraint(equalTo: bottomContentView.bottomAnchor)])
    }

    // MARK: - Buttons actions
    
    @objc
    private func doInformationButton() {
        onChatInformationPressed?(chatID, type)
    }

    @objc
    private func doSendMessage() {
        guard
            let text = messageField.text,
            !text.isEmpty
        else {
            return
        }
        messageField.text = nil
        onSendMessage?(text, chatID)
    }

}

extension ChatController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerID) as? DateHeader {
            header.date = messages[section].first?.date
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        if let messageCell = cell as? MessageCell {
            let message = messages[indexPath.section][indexPath.row]
            messageCell.message = message
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return messages.count
    }
    
    @objc private func doBackButton() {
        onBackPressed?()
    }
    
    
}

// MARK: - Keyboard Events

extension ChatController {
    
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            //bottomContentView.conten = CGPoint(x: 0, y: keyboardSize.height)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        //bottomContentView.contentOffset = CGPoint.zero
    }
    
}

extension Date {
    
    func currentDate(in formate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        return dateFormatter.string(from: Date())
    }
    
}
