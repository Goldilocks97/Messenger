//
//  DialogController.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//

import UIKit

final class ChatsController: UIViewController, ChatsModule {
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem.image = UIImage(systemName: "envelope.fill")
        tabBarItem.title = "Chats"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
}
