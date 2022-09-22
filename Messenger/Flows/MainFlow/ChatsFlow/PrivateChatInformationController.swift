//
//  PrivateChatInformationController.swift
//  Messenger
//
//  Created by Ivan Pavlov on 21.09.2022.
//

import UIKit

final class PrivateChatInformationController: UIViewController, PrivateChatInformationModule {
    
    // MARK: - PrivateChatInformationModule Implementation
    
    var onDeleteMessagesFromDevice: (() -> Void)?
    var onBlockUser: (() -> Void)?
    
    // MARK: - Subviews
    
    private lazy var backBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            title: "Back",
            style: .plain,
            target: self,
            action: #selector(doBackButton))
        button.tintColor = .red
        return button
    }()

    private lazy var deleteMessagesFromDeviceButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(doDeleteMessageFromDevice), for: .touchUpInside)
        return button
    }()
    
    private lazy var blockUserButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(doBlockUser), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - PrivateChatInformationModule
    
    var onBackButton: (() -> Void)?
    
    //MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = .white
        addSubviews()
        layoutSubviews()
    }
    
    // MARK: - Configure Subviews
    
    private func addSubviews() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backBarButton
        navigationItem.title = "Private"
        view.addSubview(deleteMessagesFromDeviceButton)
        view.addSubview(blockUserButton)
    }
    
    // MARK: - Layout Subviews
    
    private func layoutSubviews() {
        deleteMessagesFromDeviceButton.translatesAutoresizingMaskIntoConstraints = false
        blockUserButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            deleteMessagesFromDeviceButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            deleteMessagesFromDeviceButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            deleteMessagesFromDeviceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            deleteMessagesFromDeviceButton.heightAnchor.constraint(
                equalTo: view.heightAnchor,
                multiplier: 1/25),
            
            blockUserButton.topAnchor.constraint(
                equalTo: deleteMessagesFromDeviceButton.bottomAnchor,
                constant: 15),
            blockUserButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blockUserButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blockUserButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/25)
        ])
    }
    
    // MARK: - Buttons Actions
    
    @objc
    private func doBackButton() {
        onBackButton?()
    }
    
    @objc
    private func doDeleteMessageFromDevice() {
        onDeleteMessagesFromDevice?()
    }
    
    @objc
    private func doBlockUser() {
        onBlockUser?()
    }
    
}
