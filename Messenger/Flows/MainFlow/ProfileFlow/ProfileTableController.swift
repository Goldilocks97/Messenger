//
//  ProfileTableController.swift
//  Messenger
//
//  Created by Ivan Pavlov on 10.09.2022.
//

import UIKit

final class ProfileTableController: UITableViewController, ProfileModule {
    
    // MARK: ProfileModule Implementation
    
    var systemImage: String { return "brain.head.profile" }
    var systemImageColor: UIColor { return .red }
    var itemTitle: String { return "Profile" }
    var navigationTitle: String { return "Profile" }
    var navigationBarRightItem: UIBarButtonItem? { return nil }
    
    
    // MARK: Initialization
    
    init() {
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
