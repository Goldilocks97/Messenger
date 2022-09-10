//
//  UnderMainCoordinatorBase.swift
//  Messenger
//
//  Created by Ivan Pavlov on 10.09.2022.
//

class TabBarableBaseCoordinator: BaseCoordinator {
    
    let moduleFactory: ModuleFactoriable
    let model: Model
    let router: Navigationable
    
    init(model: Model, router: Navigationable, moduleFactory: ModuleFactoriable) {
        self.moduleFactory = moduleFactory
        self.model = model
        self.router = router
    }
    
}
