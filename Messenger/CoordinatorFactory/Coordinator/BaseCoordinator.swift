//
//  BaseCoordinator.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//

import UIKit

class BaseCoordinator: NSObject, Coordinatorable {
    
    // MARK: - Child Flows
    
    lazy var childCoordinators = [Coordinatorable]()
    
    
    // MARK: - Coordinatorable implementation

    func start() {}
    
    // MARK: - For controlling child flows
    
    func addDependency(_ coordinator: Coordinatorable) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(_ coordinator: Coordinatorable?) {
        guard !childCoordinators.isEmpty else { return }
        childCoordinators.removeAll(where: { $0 === coordinator })
    }
    
    // We don't actually need init because coordinator's children are removed by ARC.
    // But we still can implement some actions if need before a coordinator disappeared.
    deinit {}
    
}
