//
//  ChatsCoordinator.swift
//  Messenger
//
//  Created by Ivan Pavlov on 09.09.2022.
//

import UIKit

final class ChatsCoordinator: BaseCoordinator, Chatsable {
    
    // MARK: - Private properties
    
    let model: Model
    let router: Navigationable
    let moduleFactory: ModuleFactoriable
    let coordinatorFactory: CoordinatorFactoriable
    let rootModule: ChatsModule
    
    // MARK: - Initialization
    
    init(
        router: Navigationable,
        model: Model,
        moduleFactory: ModuleFactoriable,
        coordinatorFactory: CoordinatorFactoriable,
        rootModule: ChatsModule)
    {
        self.router = router
        self.model = model
        self.moduleFactory = moduleFactory
        self.coordinatorFactory = coordinatorFactory
        self.rootModule = rootModule
    }
    
    // MARK: - Coordinatorable Implementation
    
    override func start() {
        rootModule.onDidSelectChat = { [weak self] (chat) in
            if let chatModule = self?.moduleFactory.makeChatModule() {
                self?.router.push(chatModule, animated: true)
            }
        }
        model.chats() { [weak self] (chats) in
            
            // TODO: - Change the way of setting new Chats
            
            if let vc = self?.rootModule as? ChatsTableController {
                vc.chats = chats.value
            }
        }
    }
    
}
