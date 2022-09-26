//
//  SceneCoordinator.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//

import UIKit

final class SceneCoordinator: BaseCoordinator {
    
    // MARK: - Private properties
    
    private let router: Routerable
    private let coordinatorFactory: CoordinatorFactoriable
    private let model: Model
    private lazy var scenario: Scenario = .none {
        didSet { start() }
    }
    
    // MARK: - Public properties
    
    let rootModule: PresentableObject
        
    // MARK: - Inittialization
    
    // TODO: - rootModule is not PresentableObject but rather NavigationModule
    init(rootModule: PresentableObject) {
        self.rootModule = rootModule
        self.model = Model(handlerQueue: DispatchQueue.main)
        self.router = Router(rootModule: rootModule)
        self.coordinatorFactory = CoordinatorFactory()
        super.init()
    }
    
    // MARK: - Coordinatorable implementation
    
    override func start() {
        //scenario = .authorization
        switch(scenario) {
        case .main:
            runMainFlow()
        case .authorization:
            runAuthorizationFlow()
        case .none:
            defineScenario()
        }
    }

    // MARK: - Run child flows
    
    private func runMainFlow() {
        let coordinator = coordinatorFactory.makeMainCoordinator(
            router: router,
            coordinatorFactory: coordinatorFactory,
            model: model)
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runAuthorizationFlow() {
        let coordinator = coordinatorFactory.makeAuthorizationCoordinator(
            router: router,
            model: model)
        addDependency(coordinator)
        coordinator.onFinishing = { [weak self] in
            self?.removeDependency(coordinator)
            self?.runMainFlow()
        }
        coordinator.start()
    }

    // MARK: - Private methods
    
    private func defineScenario() {
        if let (login, password) = model.currentClient {
            model.login(username: login, password: password) { [weak self] (response) in
                switch (response.response) {
                case .success(_, _):
                    self?.scenario = .main
                default:
                    self?.scenario = .authorization
                }
            }
        } else {
            scenario = .authorization
        }
    }
    
    // MARK: - Private enums
    
    private enum Scenario {
        case main
        case authorization
        case none
    
    }
    
}
