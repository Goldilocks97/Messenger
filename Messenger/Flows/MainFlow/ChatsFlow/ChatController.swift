//
//  ChatController.swift
//  Messenger
//
//  Created by Ivan Pavlov on 10.09.2022.
//

import UIKit

final class ChatController: UIViewController, ChatModule {
    
    // MARK: - ChatModule Implementation
    
    var messagesUpdate: [Message] {
        get { return [] }
        set { messages += newValue }
    }
    var onSendMessage: ((String) -> Void)?
    
    // MARK: - Private properties
    
    private var messages = [Message]() {
        didSet { tableView.reloadData() }
    }
    let cellID = "cellID"
    let chatName: String
    
    // MARK: - View Subviews
    
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
        //tableView.delegate = self
        tableView.register(MessageCell.self, forCellReuseIdentifier: cellID)
        tableView.backgroundColor = .white
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
    
    // MARK: - Initialization
    
    init(chatName: String) {
        self.chatName = chatName
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

    @objc private func doSendMessage() {
//        guard let message = messageField.text else { return }
//        messageField.text = nil
//        onSendMessage?(message)
//        let dateFormate = "YYYY-MM-DD :mm:ss"
//        messages.append(Message(text: message, sender: 5, time: dateFormate))
//        tableView.beginUpdates()
//        let indexPath = IndexPath(row: messages.count-1, section: 0)
//        tableView.insertRows(at: [indexPath], with: .automatic)
//        tableView.endUpdates()
//        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
}

extension ChatController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        if let messageCell = cell as? MessageCell {
            let message = messages[indexPath.row]
            messageCell.message = message
            //print(message, indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
}
