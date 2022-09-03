//
//  Authorization Coordinator.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//

final class AuthorizationCoordinator: BaseCoordinator {

    // MARK: - Private properties
    
    private let router: Routerable
    private let moduleFactory: ModuleFactoriable
    
    // MARK: - Initialization
    
    init(router: Routerable) {
        self.router = router
        self.moduleFactory = ModuleFactory()
        super.init()
    }
    
    // MARK: - Coordinatorable Implementation
    
    override func start() {
        showAuthorization()
    }
    
    // MARK: - Show Module methods
    
    private func showAuthorization() {
        let module = moduleFactory.makeAuthorizationModule()
        router.setRootModule(module, animated: true)
    }
}
