//
//  ChatsTableController.swift
//  Messenger
//
//  Created by Ivan Pavlov on 10.09.2022.
//

import UIKit

final class ChatsTableController: UITableViewController, ChatsModule {
    
    // MARK: - TabBarableModule Implementation
    
    var systemImage: String { return "envelope.fill" } 
    var systemImageColor: UIColor { return .red }
    var itemTitle: String { return "Chats" }
    var navigationTitle: String { return "Chats" }
    
    func receiveNewChats(_ chats: [Chat]) {
        if !self.chats.isEmpty {
            self.chats.insert(chats[0], at: 0)
        } else {
            self.chats = chats.sorted(by: >)
        }
    }
    
    func receiveLastMessage(_ message: LastMessage) {
        if let index = chats.firstIndex(where: { $0.id == message.chatID }) {
            if (chats[index].lastMessage?.date != message.date || chats[index].lastMessage?.time != message.time) ||
                chats[index].lastMessage == nil
            {
                chats[index].lastMessage = message
                
                // TODO: - Implement personal sort (via binary search??)
                
                self.chats = chats.sorted(by: >)
            }
        }
    }

    // MARK: - Private properties
    
    private let cellID = "cellID"
    
    var navigationBarRightItem: UIBarButtonItem? {
        let item = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(doNewChat))
        item.tintColor = .red
        return item
    }
    
    private var chats = [Chat]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - ChatsTable Module Implementation
    
    var onDidSelectedChat: ((Chat) -> Void)?
    var onNewChatPressed: (() -> Void)?
    
    // MARK: - Initialization
    
    init() {
        super.init(style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .white
    }


    // MARK: - Table View Supply

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = chats[indexPath.row].name + (chats[indexPath.row].lastMessage?.text ?? "")
        cell.contentConfiguration = config
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onDidSelectedChat?(chats[indexPath.row])
    }

    @objc
    private func doNewChat() {
        onNewChatPressed?()
    }

}
