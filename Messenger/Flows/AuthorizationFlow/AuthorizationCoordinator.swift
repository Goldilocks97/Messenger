//
//  Authorization Coordinator.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//

import Foundation

final class AuthorizationCoordinator: BaseCoordinator, Authorizationable {
    
    // MARK: - Authorizationable Implementation
    
    var onFinishing: ((User) -> Void)?

    // MARK: - Private Properties
    
    private let router: Routerable
    private let moduleFactory: ModuleFactoriable
    private let model: Model
    
    // MARK: - Initialization
    
    init(router: Routerable, model: Model) {
        self.router = router
        self.moduleFactory = ModuleFactory()
        self.model = model
        super.init()
    }
    
    // MARK: - Coordinatorable Implementation
    
    override func start() {
        showAuthorization()
    }
    
    // MARK: - Show Module Methods

    private func showAuthorization() {
        let module = moduleFactory.makeAuthorizationModule()
        router.setRootModule(module, animated: true)
        module.onLogin = { [weak self] (username, password) in
            self?.model.authorization(username: username, password: password)
        }
        module.onRegistration = { [weak self] in
            if let module = self?.moduleFactory.makeRegistrationModule() {
                self?.router.push(module, animated: true)
            }
        }
    }
}
