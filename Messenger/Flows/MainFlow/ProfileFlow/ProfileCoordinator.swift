//
//  ProfileCoordinator.swift
//  Messenger
//
//  Created by Ivan Pavlov on 09.09.2022.
//

import UIKit

final class ProfileCoordinator: BaseCoordinator, Profiliable {
    
    // MARK: - Private properties
    
    let model: Model
    let router: Routerable
    let moduleFactory: ModuleFactoriable
    let coordinatorFactory: CoordinatorFactoriable
    let rootModule: ProfileModule
    
    // MARK: - Initialization
    
    init(
        router: Routerable,
        model: Model,
        moduleFactory: ModuleFactoriable,
        coordinatorFactory: CoordinatorFactoriable,
        rootModule: ProfileModule)
    {
        self.router = router
        self.model = model
        self.moduleFactory = moduleFactory
        self.coordinatorFactory = coordinatorFactory
        self.rootModule = rootModule
    }
    
    // MARK: - Coordinatorable Implementation
    
    override func start() {
        rootModule.onSectionSelected = { [weak self] (section) in
            switch(section) {
            case .security:
                if let securityModule = self?.moduleFactory.makePrivacyAndSecurityModule() {
                    self?.router.push(securityModule, animated: true)
                }
            case .storage:
                if let storageModule = self?.moduleFactory.makeStorageModule() {
                    self?.router.push(storageModule, animated: true)
                }
            case .appearance:
                if let appearanceModule = self?.moduleFactory.makeAppearanceModule() {
                    self?.router.present(appearanceModule, animated: true)
                }
            case .askQuestion:
                if let askQuestionModule = self?.moduleFactory.makeAskQuestionModule() {
                    self?.router.present(askQuestionModule, animated: true)
                }
            case .logout:
                print(section.rawValue)
            }
        }
        //router.setRootModule(, animated: true)
    }
    
}
