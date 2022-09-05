//
//  Navigationable.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//

protocol Navigationable {
    
    func push(_ module: PresentableObject, animated: Bool)
    func setRootModule(_ module: PresentableObject, animated: Bool)
    
}
