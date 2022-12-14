//
//  StorageModule.swift
//  Messenger
//
//  Created by Ivan Pavlov on 22.09.2022.
//

protocol StorageModule: ProfileSectionBaseModule {
    
    func receiveMemoryUsage(by app: Float, total: Float)
    
}
