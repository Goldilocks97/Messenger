//
//  MessageCell.swift
//  Messenger
//
//  Created by Ivan Pavlov on 11.09.2022.
//

import UIKit

final class MessageCell: UITableViewCell {
    
    // MARK: - Public Properties
    
    var message = Message(chatID: 0, text: "", senderID: 0, senderUsername: "", date: "", time: "") {
        didSet {
            let isIncoming = message.senderID != 4
            bubleView.backgroundColor =  isIncoming ? .red : .systemGray
            messageLabel.text = message.text
            
            //layout accordint to whether the message is incoming or not
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32).isActive = isIncoming
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32).isActive = !isIncoming
        }
    }
    
    // MARK: - Subviews
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let bubleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        return view
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
    
    // MARK: - Setup Subviews
    
    private func addSubviews() {
        addSubview(bubleView)
        addSubview(messageLabel)
    }

    private func layout() {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        bubleView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 250),

            bubleView.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor, constant: -16),
            bubleView.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor, constant: 16),
            bubleView.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: -16),
            bubleView.bottomAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16)]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}
