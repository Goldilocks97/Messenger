//
//  ChatController.swift
//  Messenger
//
//  Created by Ivan Pavlov on 10.09.2022.
//

import UIKit

final class ChatController: UITableViewController, ChatModule {
    
    // MARK: - View Subviews
    
    private lazy var bottomContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.borderWidth = 10
        view.layer.backgroundColor = UIColor.systemGray5.cgColor
        return view
    }()
    
    // MARK: - Initialization
    
    init() {
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        addSubviews()
        layoutSubviews()
    }
    
    // MARK: - Configurate View
    
    private func addSubviews() {
        view.addSubview(bottomContentView)
    }
    
    private func layoutSubviews() {
        bottomContentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomContentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomContentView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/15)])
    }
    
}
