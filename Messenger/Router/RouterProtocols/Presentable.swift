//
//  Presentable.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//

protocol Presentable {
    
    func present(_ module: PresentableObject)
    func present(_ module: PresentableObject, animated: Bool)
    
}
