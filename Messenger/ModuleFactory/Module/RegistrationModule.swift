//
//  RegistrationModule.swift
//  Messenger
//
//  Created by Ivan Pavlov on 05.09.2022.
//

protocol RegistrationModule: BaseModule {
    
    var onFinishing: ((Client) -> Void)? { get set }
    var onRegistration: ((String, String, String) -> Void)? { get set }
    var onBackPressed: (() -> Void)? { get set }
    
}
