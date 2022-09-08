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
        setupLoginModule(loginModule)
        router.push(loginModule, animated: true)
        //router.setRootModule(loginModule, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func authorizationDidSucces(response: String) -> Bool {
        guard
            let id = Int(response),
            id >= 0
        else { return false }
        return true
    }
    
    // MARK: - Setup Module Callbacks
    
    private func setupRegistrationModule(_ module: RegistrationModule) {
        module.onRegistration = { [weak self] (name, username, password) in
            print(name, username, password)
            let response = true
            if response {
                self?.router.pop(animated: true)
            }
            
        }
        module.onBackPressed = { [weak self] in
            self?.router.pop(animated: true)
        }
    }
    
    private func setupLoginModule(_ module: LoginModule) {
        module.onLogin = { [weak self] (username, password) in
            self?.onFinishing?(User(name: username, password: password))
            //self?.model.authorization(username: username, password: password)
        }
        module.onRegistration = { [weak self] in
            if let regModule = self?.moduleFactory.makeRegistrationModule() {
                self?.setupRegistrationModule(regModule)
                self?.router.push(regModule, animated: true)
            }
        }
        module.onFinishing = { [weak self] (user) in
            print(user)
        }
        self.model.onLogin = { [weak self] (message) in
            guard
                let result = self?.authorizationDidSucces(response: message),
                result
            else {
                DispatchQueue.main.async {
                    module.loginDidFail()
                }
                return
            }
            DispatchQueue.main.async {
                module.loginDidSucces()
            }

        }
    }
}
