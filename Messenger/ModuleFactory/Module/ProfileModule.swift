//
//  ProfileModule.swift
//  Messenger
//
//  Created by Ivan Pavlov on 10.09.2022.
//

protocol ProfileModule: TabBarableBaseModule {
    
    var onSectionSelected: ((Section) -> Void)? { get set }
    
}
