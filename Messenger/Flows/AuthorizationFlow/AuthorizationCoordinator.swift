//
//  Authorization Coordinator.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//

import Foundation

final class AuthorizationCoordinator: BaseCoordinator, Authorizationable {
    
    // MARK: - Authorizationable Implementation
    
    var onFinishing: (() -> Void)?

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

    // MARK: - Setup Module Callbacks
    
    private func setupRegistrationModule(_ module: RegistrationModule) {
        module.onRegistration = { [weak self] (name, username, password) in
            self?.model.registration(name: name, username: username, password: password) {
                [weak self] (result) in
                if result.response == .success {
                    // TODO: implement it in model???
                    
                    self?.model.user = User(name: name, tag: username, password: password)
                    self?.onFinishing?()
                }
            }
        }
        module.onBackPressed = { [weak self] in
            self?.router.pop(animated: true)
        }
    }

    private func setupLoginModule(_ module: LoginModule) {
        module.onLogin = { [weak self] (username, password) in
            //self?.onFinishing?()

            self?.model.login(username: username, password: password) { [weak self] (result) in
                if result.response == .success {
                    self?.onFinishing?()
                }
            }
        }
        module.onRegistration = { [weak self] in
            if let regModule = self?.moduleFactory.makeRegistrationModule() {
                self?.setupRegistrationModule(regModule)
                self?.router.push(regModule, animated: true)
            }
        }
    }
}
