//
//  SceneCoordinator.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//

final class SceneCoordinator: BaseCoordinator {
    
    // MARK: - Private properties
    
    private let router: Routerable
    private let coordinatorFactory: CoordinatorFactoriable
    private lazy var scenario: Scenario = {
        return defineScenario()
    }()
    
    // MARK: - Public properties
    
    let rootModule: PresentableObject
        
    // MARK: - Inittialization
    
    init(rootModule: PresentableObject) {
        self.rootModule = rootModule
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
        let coordinator = coordinatorFactory.makeMainCoordinator(
            router: router,
            coordinatorFactory: coordinatorFactory)
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runAuthorizationFlow() {
        let coordinator = coordinatorFactory.makeAuthorizationCoordinator(router: router)
        addDependency(coordinator)
        coordinator.start()
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
