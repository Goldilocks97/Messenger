//
//  AuthorizationModule.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//

protocol LoginModule: BaseModule {
    
    var onLogin: ((String, String) -> Void)? { get set }
    var onRegistration: (() -> Void)? { get set }
    var onFinishing: ((User) -> Void)? { get set }
    
    func loginDidFail()
    func loginDidSucces()
    
}
