//
//  ChatInformationController.swift
//  Messenger
//
//  Created by Ivan Pavlov on 21.09.2022.
//

import UIKit

final class PublicChatInformationController: UIViewController, PublicChatInformationModule {
    
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
    
    // MARK: - ChatInformationModule Implementation
    
    var onBackButton: (() -> Void)?
    

    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        addSubviews()
    }
    
    // MARK: - Configure Subview
    
    private func addSubviews() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backBarButton
    }
    
    // MARK: - Buttons Actions
    
    @objc
    private func doBackButton() {
        onBackButton?()
    }

}
