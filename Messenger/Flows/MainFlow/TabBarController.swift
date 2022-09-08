//
//  TabBarController.swift
//  Messenger
//
//  Created by Ivan Pavlov on 08.09.2022.
//

import UIKit

final class TabBarController: UITabBarController, TabBarModule {
    
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//enum Tab {
//    case contacts
//    case chats
//    case profile
//}
