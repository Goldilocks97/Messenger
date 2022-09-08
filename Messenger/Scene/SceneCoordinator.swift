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
    private var user: User?
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
        guard let user = self.user else { return }
        let newRootController = UITabBarController() // use factory?
//        let apperance = UITabBarAppearance()
//        apperance.configureWithDefaultBackground()
//        apperance.backgroundColor = .black
//        apperance.backgroundEffect = .some(UIBlurEffect(style: .systemMaterial))
//        newRootController.tabBar.standardAppearance = apperance
        let newRouter = Router(rootModule: newRootController)
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.scene(changeRootViewController: newRootController)
        }
        let coordinator = coordinatorFactory.makeMainCoordinator(
            router: newRouter,
            coordinatorFactory: coordinatorFactory,
            user: user)
        addDependency(coordinator)
        newRootController.delegate = coordinator
        coordinator.start()
    }
    
    private func runAuthorizationFlow() {
        let coordinator = coordinatorFactory.makeAuthorizationCoordinator(router: router, model: model)
        addDependency(coordinator)
        coordinator.start()
        coordinator.onFinishing = { [weak self] user in
            self?.user = user
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
    
}
