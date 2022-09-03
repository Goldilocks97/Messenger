//
//  MainFlow.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//

final class MainCoordinator: BaseCoordinator {
    
    // MARK: - Private properties
    
    private let router: Routerable
    private let moduleFactory: ModuleFactoriable
    private let coordinatorrFactory: CoordinatorFactoriable
    
    // MARK: - Initialization
    
    init(router: Routerable, coordinatorFactory: CoordinatorFactoriable) {
        self.router = router
        self.moduleFactory = ModuleFactory()
        self.coordinatorrFactory = coordinatorFactory
    }
    
    // MARK: - Coordinatorable Implementation
    
    override func start() {
        showDialogs()
    }
    
    // MARK: - Show Module methods
    
    private func showDialogs() {
        let module = moduleFactory.makeDialogsModule()
        router.setRootModule(module, animated: true)
    }
    
}
