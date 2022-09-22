//
//  AppearanceController.swift
//  Messenger
//
//  Created by Ivan Pavlov on 22.09.2022.
//

import UIKit

final class AppearanceController:
    UIColorPickerViewController,
    AppearanceModule,
    UIColorPickerViewControllerDelegate
{
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundColor = .white
    }
    
    // MARK: - ColorPicker Delegate
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        print(selectedColor)
    }
    
    func colorPickerViewController(
        _ viewController: UIColorPickerViewController,
        didSelect color: UIColor,
        continuously: Bool)
    {
        if !continuously {
            print(color)
        }
    }
    
}
