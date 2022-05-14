//
//  ViewController.swift
//  TicTacToe
//
//  Created by Aram Martirosyan on 14.05.22.
//

import UIKit

enum GameState {
    case started
    case win(winner: String)
    case draw
}

class ViewController: UIViewController {
    var resetButton: UIButton!
    var titleLabel: UILabel!
    var mainStackView: UIStackView!
    var overlayView: UIView!
    var winnerLabel: UILabel!
    
    var squareViews: [SquareView] = []
    var isXState: Bool = true
    var isReadyForValidations: Bool = false
    
    var gameArray: [[String]] = [] {
        didSet {
            if isReadyForValidations {
                checkGameStatus()
            }
        }
    }
    
    var gameState: GameState = .started {
        didSet {
            switch gameState {
            case .started:
                isReadyForValidations = false
                squareViews.forEach({ $0.removeData() })
                for i in gameArray.indices {
                    for j in gameArray[i].indices {
                        gameArray[i][j] = ""
                    }
                }
                isXState = true
                isReadyForValidations = true
                overlayView.isHidden = true
                winnerLabel.isHidden = true
            case .win(let winner):
                winnerLabel.text = "\(winner) wins"
                winnerLabel.isHidden = false
                overlayView.isHidden = false
            case .draw:
                winnerLabel.text = "It's draw"
                winnerLabel.isHidden = false
                overlayView.isHidden = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTitleLabel()
        initStackView()
        initResetButton()
        initOverlayView()
        initWinnerLabel()
        
        constructHierarchies()
        activateConstraints()
        
        createSquareGrid(size: 1...3)
        
        resetButton.addTarget(
            self, action: #selector(resetButtonPressed),
            for: .touchUpInside
        )
    }
    
    func createSquareGrid(size: ClosedRange<Int>) {
        for i in size {
            let stackView = createHorizontalStackView()
            mainStackView.addArrangedSubview(stackView)
            
            gameArray.append([])
            for j in size {
                let squareView = SquareView()
                gameArray[i-1].append("")
                
                squareView.onButtonSelection = {
                    if self.isXState {
                        self.gameArray[i-1][j-1] = "X"
                        squareView.set(value: "X")
                    } else {
                        self.gameArray[i-1][j-1] = "O"
                        squareView.set(value: "O")
                    }
                    self.isXState.toggle()
                }
                
                let height = (Int(view.frame.width) - 50 - (size.upperBound - 1)*12)/size.upperBound
                NSLayoutConstraint.activate([
                    squareView.heightAnchor.constraint(equalToConstant: CGFloat(height))
                ])
                
                squareViews.append(squareView)
                stackView.addArrangedSubview(squareView)
            }
        }
        gameState = .started
        isReadyForValidations = true
    }
    
    func createHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        return stackView
    }
    
    @objc func resetButtonPressed() {
        gameState = .started
    }
    
    func checkGameStatus() {
        for i in gameArray.indices {
            if gameArray[i][0] != "" && gameArray[i][0] ==
                gameArray[i][1] && gameArray[i][0] ==
                gameArray[i][2] {
                gameState = .win(winner: gameArray[i][0])
                return
            }
            
            if gameArray[0][i] != "" && gameArray[0][i] ==
                gameArray[1][i] && gameArray[0][i] ==
                gameArray[2][i] {
                gameState = .win(winner: gameArray[0][i])
                return
            }
        }
        
        if gameArray[0][0] != "" && gameArray[0][0] ==
            gameArray[1][1] && gameArray[0][0] ==
            gameArray[2][2] {
            gameState = .win(winner: gameArray[0][0])
            return
        }
        
        if gameArray[0][2] != "" && gameArray[0][2] ==
            gameArray[1][1] && gameArray[0][2] ==
            gameArray[2][0] {
            gameState = .win(winner: gameArray[0][2])
            return
        }
    }
}

extension ViewController {
    private func initWinnerLabel() {
        winnerLabel = UILabel()
        winnerLabel.font = .systemFont(ofSize: 30, weight: .bold)
        winnerLabel.textColor = .black
        winnerLabel.numberOfLines = 0
        winnerLabel.textAlignment = .center
        winnerLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func initOverlayView() {
        overlayView = UIView()
        overlayView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 0.2)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func initResetButton() {
        resetButton = UIButton(type: .system)
        resetButton.backgroundColor = .lightGray
        resetButton.layer.cornerRadius = 12
        resetButton.setTitle("Reset", for: .normal)
        resetButton.setTitleColor(.black, for: .normal)
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func initTitleLabel() {
        titleLabel = UILabel()
        titleLabel.backgroundColor = .white
        titleLabel.text = "TicTacToe"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func initStackView() {
        mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.spacing = 12
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.backgroundColor = .white
    }
    
    private func constructHierarchies() {
        view.addSubview(titleLabel)
        view.addSubview(mainStackView)
        view.addSubview(resetButton)
        view.addSubview(overlayView)
        view.addSubview(winnerLabel)
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 90),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            overlayView.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            
            winnerLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            winnerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            winnerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            resetButton.widthAnchor.constraint(equalToConstant: 80),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}



