//
//  DateHeader.swift
//  Messenger
//
//  Created by Ivan Pavlov on 20.09.2022.
//

import UIKit

final class DateHeader: UITableViewHeaderFooterView {
    
    var date: String? = "" {
        didSet {
            dateLabel.text = date
        }
    }

    private lazy var dateBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        backgroundView = UIView()
        addSubviews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(dateBubbleView)
        contentView.addSubview(dateLabel)
    }
    
    private func layout() {
        dateBubbleView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dateLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            dateBubbleView.leadingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -10),
            dateBubbleView.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 10),
            dateBubbleView.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            dateBubbleView.topAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -10)])
    }
    
}
