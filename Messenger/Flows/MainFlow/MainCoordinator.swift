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
    private let user: User
    private var tabsIndexes: [Tabs: Int]?
    
    // MARK: - Initialization
    
    init(router: TabBarable, coordinatorFactory: CoordinatorFactoriable, user: User) {
        self.moduleFactory = ModuleFactory()
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.user = user
    }
    
    // MARK: - Coordinatorable Implementation
    
    override func start() {
        let contactsModule = moduleFactory.makeContactsModule()
        let dialogsModule = moduleFactory.makeDialogsModule()
        let profileModule = moduleFactory.makeProfileModule()
        router.addTabs([contactsModule, dialogsModule, profileModule])
        tabsIndexes = [.contacts: 0, .dialogs: 1, .profile: 2]
    }
    
    // MARK: - Show Module methods
    
    private func showDialogs() {
        //let module = moduleFactory.makeDialogsModule()
        //router.setRootModule(module, animated: true)
    }
    
}

extension MainCoordinator: UITabBarControllerDelegate {
    
    func tabBarController(
        _ tabBarController: UITabBarController,
        didSelect viewController: UIViewController)
    {
        if viewController is ContactsModule {
            if let index = tabsIndexes?[.contacts] {
                router.setTab(index: index)
            }
        } else if viewController is DialogsModule {
            if let index = tabsIndexes?[.dialogs] {
                //router.setTab(index: index)
            }
            
        } else if viewController is ProfileModule {
            if let index = tabsIndexes?[.profile] {
                router.setTab(index: index)
            }
        }
    }
    
//    func tabBarController(
//        _ tabBarController: UITabBarController,
//        shouldSelect viewController: UIViewController
//    ) -> Bool {
//        return false
//    }
    
    enum Tabs {
        case contacts
        case dialogs
        case profile
    }

}
