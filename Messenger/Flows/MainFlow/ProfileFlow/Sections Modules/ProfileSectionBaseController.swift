//
//  ProfileSectionBaseController.swift
//  Messenger
//
//  Created by Ivan Pavlov on 22.09.2022.
//

import UIKit

class ProfileSectionBaseController: UIViewController, ProfileSectionBaseModule {
    
    // MARK: - ProfileSectionBaseModule Implementation
    
    var onBackButton: (() -> Void)?
    
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
        
        addSubviews()
    }
    
    // MARK: - Configure Subviews
    
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
