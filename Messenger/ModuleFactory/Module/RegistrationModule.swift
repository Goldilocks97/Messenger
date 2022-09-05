//
//  RegistrationModule.swift
//  Messenger
//
//  Created by Ivan Pavlov on 05.09.2022.
//

protocol RegistrationModule: BaseModule {
    
    var onFinishing: ((User) -> Void)? { get set }
    
}
