//
//  MainFlow.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//

import UIKit

final class MainCoordinator: BaseCoordinator, Mainable {
    
    // MARK: - Private Properties
    
    private let router: Routerable
    private let moduleFactory: ModuleFactoriable
    private let coordinatorFactory: CoordinatorFactoriable
    private let model: Model
    
    // MARK: - Initialization
    
    init(
        router: Routerable,
        coordinatorFactory: CoordinatorFactoriable,
        model: Model)
    {
        self.moduleFactory = ModuleFactory()
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.model = model
    }
    
    // MARK: - Coordinatorable Implementation
    
    override func start() {
        let chatsModule = moduleFactory.makeChatsModule()
        let profileModule = moduleFactory.makeProfileModule()
        let tabs = [chatsModule, profileModule]
        let tabBarModule = moduleFactory.makeTabBarModule(tabs: tabs)
        
        router.setRootModule(tabBarModule, animated: true)
        runChatsFlow(rootModule: chatsModule)
        runProfileFlow(rootModule: profileModule)
    }

    // MARK: - Run Flows methods

    private func runProfileFlow(rootModule: ProfileModule) {
        let coordinator = ProfileCoordinator(
            router: router,
            model: model,
            moduleFactory: moduleFactory,
            coordinatorFactory: coordinatorFactory,
            rootModule: rootModule)
        addDependency(coordinator)
        coordinator.start()
    }

    private func runChatsFlow(rootModule: ChatsModule) {
        let coordinator = ChatsCoordinator(
            router: router,
            model: model,
            moduleFactory: moduleFactory,
            coordinatorFactory: coordinatorFactory,
            rootModule: rootModule)
        addDependency(coordinator)
        coordinator.start()
    }

}
