//
//  AuthorizationModuleFactoriable.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//

protocol AuthorizationModuleFactoriable {
    
    func makeAuthorizationModule() -> LoginModule
    
}
