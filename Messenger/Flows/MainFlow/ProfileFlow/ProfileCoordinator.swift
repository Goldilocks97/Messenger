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
            self?.userDidSelectedSection(section)
        }
    }
    
    // MARK: - Callbacks for Modules
    
    private func userDidSelectedSectionInSecurityModule(_ section: PrivacyAndSecuritySection) {
        switch(section) {
        case .blockedUsers:
            let blockedUsersModule = moduleFactory.makeBlockedUsersModule()
            router.present(blockedUsersModule, animated: true)
        case .changePassword:
            let changePasswordModule = moduleFactory.makeChangePasswordModule()
            router.present(changePasswordModule, animated: true)
        case .passwordOnLogin:
            let passwordOnLogin = moduleFactory.makePasswordOnLoginModule()
            router.present(passwordOnLogin, animated: true)
        }
    }
    
    private func userDidSelectedSection(_ section: Section) {
        switch(section) {
        case .security:
            let securityModule = moduleFactory.makePrivacyAndSecurityModule()
            securityModule.onBackButton = { [weak self] in
                self?.router.pop(animated: true)
            }
            securityModule.onSelectedSection = { [weak self] (section) in
                self?.userDidSelectedSectionInSecurityModule(section)
            }
            router.push(securityModule, animated: true)
        case .storage:
            let storageModule = moduleFactory.makeStorageModule()
            storageModule.onBackButton = { [weak self] in
                self?.router.pop(animated: true)
            }
            router.push(storageModule, animated: true)
        case .appearance:
            let appearanceModule = moduleFactory.makeAppearanceModule()
            router.present(appearanceModule, animated: true)
        case .askQuestion:
            let askQuestionModule = moduleFactory.makeAskQuestionModule()
            router.present(askQuestionModule, animated: true)
        case .logout:
            let actions = [
                UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
                    self?.router.dismiss(animated: true)
                },
                UIAlertAction(title: "Logout", style: .default) { [weak self] _ in
                    print("logout")
                }
            ]
            let logoutModule = moduleFactory.makeLogoutModule(
                title: "Are You Sure?",
                message: nil,
                preferredStyle: .alert,
                actions: actions)
            router.present(logoutModule, animated: true)
        }
    }
    
}
