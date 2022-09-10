//
//  ChatsCoordinator.swift
//  Messenger
//
//  Created by Ivan Pavlov on 09.09.2022.
//

import UIKit

final class ChatsCoordinator: TabBarableBaseCoordinator, Chatsable {
    
    // MARK: - Coordinatorable Implementation
    
    override func start() {
        let vc = ChatsTableController()
        router.setRootModule(vc, animated: true)
        model.chats() { [weak self] (chats) in
            vc.chats = chats.value
        }
    }
    
}
