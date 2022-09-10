//
//  ProfileCoordinator.swift
//  Messenger
//
//  Created by Ivan Pavlov on 09.09.2022.
//

import UIKit

final class ProfileCoordinator: BaseCoordinator, Profiliable {
    
    // MARK: - Private properties
    
    let model: Model
    let router: Navigationable
    let moduleFactory: ModuleFactoriable
    let coordinatorFactory: CoordinatorFactoriable
    let rootModule: ProfileModule
    
    // MARK: - Initialization
    
    init(
        router: Navigationable,
        model: Model,
        moduleFactory: ModuleFactoriable,
        coordinatorFactory: CoordinatorFactoriable,
        rootModule: ProfileModule)
    {
        self.router = router
        self.model = model
        self.moduleFactory = moduleFactory
        self.coordinatorFactory = coordinatorFactory
        self.rootModule = rootModule
    }
    
    // MARK: - Coordinatorable Implementation
    
    override func start() {
        //router.setRootModule(, animated: true)
    }
    
}
