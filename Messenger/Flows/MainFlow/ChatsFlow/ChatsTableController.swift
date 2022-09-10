//
//  ChatsTableController.swift
//  Messenger
//
//  Created by Ivan Pavlov on 10.09.2022.
//

import UIKit

final class ChatsTableController: UITableViewController, ChatsModule {
    
    // MARK: - ChatsModule Implementation
    
    var systemImage: String { return "envelope.fill" } 
    var systemImageColor: UIColor { return .red }
    var itemTitle: String { return "Chats" }
    var navigationTitle: String { return "Chats" }

    // MARK: - Data
    
    var chats = [Chat]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Private properties
    
    let cellID = "cellID"
    
    // MARK: - ChatsTable Module Implementation
    
    var onDidSelectChat: ((Chat) -> Void)?
    
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
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Chats"
    }
    
    // MARK: - Table View Supply
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        var config = cell.defaultContentConfiguration()
        config.text = chats[indexPath.row].name
        cell.contentConfiguration = config
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onDidSelectChat?(chats[indexPath.row])
    }
    
}
