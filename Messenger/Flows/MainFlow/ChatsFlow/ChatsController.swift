//
//  ChatsController.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//

import UIKit

final class ChatsController: TabBarableBaseController, ChatsModule {
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //navigationBar.prefersLargeTitles = true
    }
    
}
