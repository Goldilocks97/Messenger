//
//  MessageCell.swift
//  Messenger
//
//  Created by Ivan Pavlov on 11.09.2022.
//

import UIKit

final class MessageCell: UITableViewCell {
    
    // MARK: Constraits
    
    var messageLabelLeadingConstrait: NSLayoutConstraint?
    var messageLabelTrailingConstrait: NSLayoutConstraint?
    
    // MARK: - Public Properties
    
    var message = Message(chatID: 0, text: "", senderID: 0, senderUsername: "", date: "", time: "") {
        didSet {
            let isIncoming = message.senderID != 4
            bubleView.backgroundColor =  isIncoming ? .red : .systemGray
            messageLabel.text = message.text
            
            // layout accordint to whether the message is incoming or not
//            if message.senderID == 4 {
//                messageLabelTrailingConstrait?.isActive = false
//                messageLabelLeadingConstrait?.isActive = true
//            } else {
//                messageLabelLeadingConstrait?.isActive = false
//                messageLabelTrailingConstrait?.isActive = true
//            }
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
        view.layer.cornerRadius = 15
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
            messageLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 2*LayoutConstants.offset),
            messageLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -2*LayoutConstants.offset),
//            messageLabel.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 3/4),
            messageLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 2*LayoutConstants.offset),
            messageLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -2*LayoutConstants.offset),
        
            bubleView.leadingAnchor.constraint(
                equalTo: messageLabel.leadingAnchor,
                constant: -LayoutConstants.offset),
            bubleView.trailingAnchor.constraint(
                equalTo: messageLabel.trailingAnchor,
                constant: LayoutConstants.offset),
            bubleView.topAnchor.constraint(
                equalTo: messageLabel.topAnchor,
                constant: -LayoutConstants.offset),
            bubleView.bottomAnchor.constraint(
                equalTo: messageLabel.bottomAnchor,
                constant: LayoutConstants.offset)]

        NSLayoutConstraint.activate(constraints)
        
//        messageLabelLeadingConstrait = messageLabel.leadingAnchor.constraint(
//            equalTo: leadingAnchor,
//            constant: 2*LayoutConstants.offset)
//        messageLabelTrailingConstrait = messageLabel.trailingAnchor.constraint(
//            equalTo: trailingAnchor,
//            constant: -2*LayoutConstants.offset)
    }
    
    private enum LayoutConstants {
        
        static let offset: CGFloat = 16
        static let widthConstant: CGFloat = 250
        
    }
    
}
