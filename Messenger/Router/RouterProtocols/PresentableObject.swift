//
//  File.swift
//  Messenger
//
//  Created by Ivan Pavlov on 03.09.2022.
//
import UIKit


// For encapsulation ViewControllers in Router.
protocol PresentableObject: AnyObject {

    func toPresent() -> UIViewController

}

extension UIViewController: PresentableObject {
  
    func toPresent() -> UIViewController {
        return self
    }
}
