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
        runChatsFlow(rootModule: chatsModule)
        runProfileFlow(rootModule: profileModule)
        runContactsFlow(rootModule: contactsModule)
    }
    
    // MARK: - Run Flows methods

    private func runContactsFlow(rootModule: ContactsModule) {
        let router = Router(rootModule: rootModule)
        let coordinator = ContactsCoordinator(model: model, router: router, moduleFactory: moduleFactory)
        addDependency(coordinator)
        coordinator.start()
    }

    private func runProfileFlow(rootModule: ProfileModule) {
        let router = Router(rootModule: rootModule)
        let coordinator = ProfileCoordinator(model: model, router: router, moduleFactory: moduleFactory)
        addDependency(coordinator)
        coordinator.start()
    }

    private func runChatsFlow(rootModule: ChatsModule) {
        let router = Router(rootModule: rootModule)
        let coordinator = ChatsCoordinator(model: model, router: router, moduleFactory: moduleFactory)
        addDependency(coordinator)
        coordinator.start()
    }

}
