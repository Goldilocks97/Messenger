//
//  AskQuestionController.swift
//  Messenger
//
//  Created by Ivan Pavlov on 22.09.2022.
//

import UIKit

final class AskQuestionController: UIViewController, AskQuestionModule {
    
    // MARK: - Subviews
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Info"
        label.sizeToFit()
        return label
    }()
    
    // MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        addSubviews()
        layoutSubviews()
    }
    
    // MARK: - Configure Subviews
    
    private func addSubviews() {
        view.addSubview(infoLabel)
    }
    
    private func layoutSubviews() {
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)])
    }
    
}
