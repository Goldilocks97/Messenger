//
//  Authorizationable.swift
//  Messenger
//
//  Created by Ivan Pavlov on 04.09.2022.
//

protocol Authorizationable: Coordinatorable {
    
    var onFinishing: (() -> Void)? { set get }
    
}
