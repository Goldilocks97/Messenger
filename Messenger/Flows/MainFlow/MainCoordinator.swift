//
//  MainFlow.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//

final class MainCoordinator: BaseCoordinator, Mainable {
    
    // MARK: - Private properties
    
    private let router: Routerable
    private let moduleFactory: ModuleFactoriable
    private let coordinatorrFactory: CoordinatorFactoriable
    private let user: User
    
    // MARK: - Initialization
    
    init(router: Routerable, coordinatorFactory: CoordinatorFactoriable, user: User) {
        self.router = router
        self.moduleFactory = ModuleFactory()
        self.coordinatorrFactory = coordinatorFactory
        self.user = user
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
