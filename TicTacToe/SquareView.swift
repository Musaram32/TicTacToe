//
//  SquareView.swift
//  TicTacToe
//
//  Created by Aram Martirosyan on 14.05.22.
//

import UIKit

class SquareView: UIView {
    var squareLabel: UILabel!
    var squareButton: UIButton!
    var onButtonSelection: (()-> Void)?
    var isValueSet: Bool = false
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .lightGray
        layer.cornerRadius = 12
        initSquareLabel()
        initSquareButton()
        constructHierarchys()
        initConstraints()
        
        squareButton.addTarget(self, action: #selector(squareButtonTapped), for: .touchUpInside)
    }
    
    @objc func squareButtonTapped() {
        onButtonSelection?()
    }
    
    func set(value: String) {
        guard isValueSet else {
            squareLabel.text = value
            isValueSet = true
            return
        }
        isValueSet = true
    }
    
    func removeData() {
        isValueSet = false
        squareLabel.text = ""
    }
}

extension SquareView {
    private func initSquareLabel() {
        squareLabel = UILabel()
        squareLabel.textAlignment = .center
        squareLabel.textColor = .black
        squareLabel.font = .systemFont(ofSize: 50, weight: .bold)
        squareLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func initSquareButton() {
        squareButton = UIButton()
        squareButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func constructHierarchys() {
        addSubview(squareLabel)
        addSubview(squareButton)
    }
    
    private func initConstraints() {
        NSLayoutConstraint.activate([
            squareLabel.topAnchor.constraint(equalTo: topAnchor),
            squareLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            squareLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            squareLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            squareButton.topAnchor.constraint(equalTo: topAnchor),
            squareButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            squareButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            squareButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}


