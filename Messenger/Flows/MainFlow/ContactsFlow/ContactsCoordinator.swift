//
//  ContactsCoordinator.swift
//  Messenger
//
//  Created by Ivan Pavlov on 09.09.2022.
//

import UIKit

final class ContactsCoordinator: TabBarableBaseCoordinator, Contactsable {
    
    // MARK: - Coordinatorable Implementation
    
    override func start() {
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        router.setRootModule(UIViewController(), animated: true)
    }
    
}
