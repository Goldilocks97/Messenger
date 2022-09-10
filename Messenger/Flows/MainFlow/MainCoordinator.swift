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
    private let model: Model
    
    // MARK: - Initialization
    
    init(
        router: TabBarable,
        coordinatorFactory: CoordinatorFactoriable,
        moduleFactory: ModuleFactoriable,
        model: Model)
    {
        self.moduleFactory = moduleFactory
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.model = model
    }
    
    // MARK: - Coordinatorable Implementation
    
    override func start() {
        let contactsModule = moduleFactory.makeContactsModule(
            systemImage: "person.crop.circle.fill",
            imageColor: .red,
            title: "Contacts")
        let chatsModule = moduleFactory.makeChatsModule(
            systemImage: "envelope.fill",
            imageColor: .red,
            title: "Chats")
        let profileModule = moduleFactory.makeProfileModule(
            systemImage: "brain.head.profile",
            imageColor: .red,
            title: "Profile")
        
        router.addTabs([contactsModule, chatsModule, profileModule])
    }
    
    // MARK: - Show Module methods
    
    private func showChats() {
        //let module = moduleFactory.makeChatsModule()
        //router.setRootModule(module, animated: true)
    }
    
}
