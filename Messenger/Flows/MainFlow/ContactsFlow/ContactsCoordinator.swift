//
//  ContactsCoordinator.swift
//  Messenger
//
//  Created by Ivan Pavlov on 09.09.2022.
//

import UIKit

final class ContactsCoordinator: BaseCoordinator, Contactsable {
    
    // MARK: - Private properties
    
    let model: Model
    let router: Navigationable
    let moduleFactory: ModuleFactoriable
    let coordinatorFactory: CoordinatorFactoriable
    let rootModule: ContactsModule
    
    // MARK: - Initialization
    
    init(
        router: Navigationable,
        model: Model,
        moduleFactory: ModuleFactoriable,
        coordinatorFactory: CoordinatorFactoriable,
        rootModule: ContactsModule)
    {
        self.router = router
        self.model = model
        self.moduleFactory = moduleFactory
        self.coordinatorFactory = coordinatorFactory
        self.rootModule = rootModule
    }
    
    // MARK: - Coordinatorable Implementation
    
    override func start() {

    }
    
}
