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
    private lazy var scenario: Scenario = {
        return defineScenario()
    }()
    
    // MARK: - Public properties
    
    let rootModule: PresentableObject
        
    // MARK: - Inittialization
    
    init(rootModule: PresentableObject) {
        self.rootModule = rootModule
        self.model = Model()
        self.router = Router(rootModule: rootModule)
        self.coordinatorFactory = CoordinatorFactory()
        super.init()
    }
    
    // MARK: - Coordinatorable implementation
    
    override func start() {
        switch(scenario) {
        case .main:
            runMainFlow()
        case .authorization:
            runAuthorizationFlow()
        }
    }

    // MARK: - Run child flows
    
    private func runMainFlow() {
        let moduleFactory = ModuleFactory()
        let newRootController = moduleFactory.makeTabBarModule()
        let newRouter = Router(rootModule: newRootController)
        
        changeRootViewControllerOfWindowScene(newRootController)
        let coordinator = coordinatorFactory.makeMainCoordinator(
            router: newRouter,
            coordinatorFactory: coordinatorFactory,
            moduleFactory: moduleFactory)

        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runAuthorizationFlow() {
        let coordinator = coordinatorFactory.makeAuthorizationCoordinator(
            router: router,
            model: model)
        addDependency(coordinator)
        coordinator.start()
        coordinator.onFinishing = { [weak self] (user) in
            self?.removeDependency(coordinator)
            self?.runMainFlow()
        }
    }

    // MARK: - Private methods
    
    private func defineScenario() -> Scenario {
        return .authorization
    }
    
    // MARK: - Private enums
    
    private enum Scenario {
        case main
        case authorization
    
    }
    
    private func changeRootViewControllerOfWindowScene(
        _ rootController: PresentableObject)
    {
        if let sceneDelegate =
            UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        {
            sceneDelegate.scene(
                changeRootViewController: rootController.toPresent())
        }
    }
    
}
