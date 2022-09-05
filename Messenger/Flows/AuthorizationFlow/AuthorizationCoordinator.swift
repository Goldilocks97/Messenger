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
        let loginModule = moduleFactory.makeAuthorizationModule()
        model.onLogin = { [weak self] (message) in
            guard
                let result = self?.authorizationDidSucces(response: message),
                result
            else {
                loginModule.loginDidFail()
                return
            }
            loginModule.loginDidSucces()
        }
        router.setRootModule(loginModule, animated: true)
        loginModule.onLogin = { [weak self] (username, password) in
            self?.model.authorization(username: username, password: password)
        }
        loginModule.onRegistration = { [weak self] in
            if let regModule = self?.moduleFactory.makeRegistrationModule() {
                self?.router.push(regModule, animated: true)
            }
        }
        loginModule.onFinishing = { [weak self] (user) in
            print(user)
        }
    }
    
    // MARK: - Private Methods
    
    private func authorizationDidSucces(response: String) -> Bool {
        if let id = Int(response) {
            return true
        }
        return false
    }
}
