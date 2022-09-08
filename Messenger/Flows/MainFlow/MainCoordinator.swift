//
//  MainFlow.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//

import UIKit

final class MainCoordinator: BaseCoordinator, Mainable {
    
    // MARK: - Private properties
    
    private let router: TabBarable
    private let moduleFactory: ModuleFactoriable
    private let coordinatorFactory: CoordinatorFactoriable
    
    // MARK: - Initialization
    
    init(
        router: TabBarable,
        coordinatorFactory: CoordinatorFactoriable,
        moduleFactory: ModuleFactoriable)
    {
        self.moduleFactory = moduleFactory
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }
    
    // MARK: - Coordinatorable Implementation
    
    override func start() {
        let contactsModule = moduleFactory.makeContactsModule()
        let chatsModule = moduleFactory.makeChatsModule()
        let profileModule = moduleFactory.makeProfileModule()
        
        router.addTabs([contactsModule, chatsModule, profileModule])
    }
    
    // MARK: - Show Module methods
    
    private func showChats() {
        //let module = moduleFactory.makeChatsModule()
        //router.setRootModule(module, animated: true)
    }
    
}
