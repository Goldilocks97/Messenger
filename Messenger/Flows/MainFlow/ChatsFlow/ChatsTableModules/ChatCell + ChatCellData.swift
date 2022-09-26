//
//  ChatCell.swift
//  Messenger
//
//  Created by Ivan Pavlov on 24.09.2022.
//

import UIKit

final class ChatCell: UITableViewCell {
    
    // MARK: - Data
    
    var data: ChatCellData? {
        didSet{
            name.text = data?.name
            date.text = data?.date
            sender.text = data?.sender
            message.text = data?.message
            
            layout()
            
//            if data?.type == .publicChat {
//                NSLayoutConstraint.activate(publicConstraits)
//                sender.isHidden = false
//                message.isHidden = false
//            } else {
//                NSLayoutConstraint.deactivate(publicConstraits)
//                sender.isHidden = true
//                message.isHidden = true
//            }
        }
    }
    
//    private lazy var publicConstraits = [
//        sender.topAnchor.constraint(equalTo: name.bottomAnchor),
//        sender.leadingAnchor.constraint(equalTo: leadingAnchor),
//        
//        message.topAnchor.constraint(equalTo: sender.bottomAnchor),
//        message.leadingAnchor.constraint(equalTo: leadingAnchor)
//    ]
    
    // MARK: - Subviews
    
    private lazy var name: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        return label
    }()
    
    private lazy var date: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    private lazy var sender: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var message: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure Cell
    
    private func addSubviews() {
        
        // TODO: Extension addSubviews([View])
        
        addSubview(name)
        addSubview(date)
//        addSubview(sender)
//        addSubview(message)
    
    }
    
    // TODO: READ ABOUT LAYOUTSUBVIEWS FUNC
    private func layout() {
        name.translatesAutoresizingMaskIntoConstraints = false
        date.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            name.centerYAnchor.constraint(equalTo: centerYAnchor),
            name.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            
            date.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            date.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)])
//        
//
//        NSLayoutConstraint.activate([
//            sender.topAnchor.constraint(equalTo: name.bottomAnchor),
//            sender.leadingAnchor.constraint(equalTo: leadingAnchor),
//            
//            message.topAnchor.constraint(equalTo: sender.bottomAnchor),
//            message.leadingAnchor.constraint(equalTo: leadingAnchor)])
    }
    
}

struct ChatCellData {
    
    var name: String
    var type: ChatType
    var date: String
    var message: String?
    var sender: String?
    
}
