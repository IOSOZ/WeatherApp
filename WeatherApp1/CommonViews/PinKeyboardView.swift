//
//  PinKeyboardView.swift
//  WeatherApp
//
//  Created by Олег Зуев on 16.03.2026.
//

import Foundation
import UIKit
import SnapKit


enum KeyBoardState {
    case faceID
    case delete
}

final class PinKeyboardView: UIView {
    
    var onDigitTap: ((String) -> Void)?
    var onDeleteTap: (() -> Void)?
    var onFaceIDTap: (() -> Void)?
    
    // MARK: - UI
    private let mainStack = UIStackView()
    private let row1 = UIStackView()
    private let row2 = UIStackView()
    private let row3 = UIStackView()
    private let row4 = UIStackView()
    
    private let oneButton = PinNumberButton()
    private let twoButton = PinNumberButton()
    private let threeButton = PinNumberButton()
    private let fourButton = PinNumberButton()
    private let fiveButton = PinNumberButton()
    private let sixButton = PinNumberButton()
    private let sevenButton = PinNumberButton()
    private let eightButton = PinNumberButton()
    private let nineButton = PinNumberButton()
    private let zeroButton = PinNumberButton()
    
    private var activeButton: UIView?
    private let emptyView = UIView()
    
    // MARK: - Private Properties
    private let needFaceId: Bool
    private var state: KeyBoardState = .delete
    
    // MARK: - Init
    init(needFaceId: Bool) {
        self.needFaceId = needFaceId
        super.init(frame: .zero)
        
        setupDigits()
        setupUI()
        setupHierarchy()
        setupLayout()
        setupActions()
        
        if needFaceId {
            updateActiveButton(for: .faceID)
        } else {
            updateActiveButton(for: .delete)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Method
    func apply(enteredSymbols: Int) {
        guard needFaceId else { return }
        
        let newState: KeyBoardState = enteredSymbols == 0 ? .faceID : .delete
        
        guard newState != state else { return }
        updateActiveButton(for: newState)
    }
}

private extension PinKeyboardView {
    
    func setupDigits() {
        oneButton.number = 1
        twoButton.number = 2
        threeButton.number = 3
        fourButton.number = 4
        fiveButton.number = 5
        sixButton.number = 6
        sevenButton.number = 7
        eightButton.number = 8
        nineButton.number = 9
        zeroButton.number = 0
    }
    
    // MARK: - Setup UI

    func setupUI() {
        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.alignment = .fill
        mainStack.distribution = .fillEqually
        
        [row1, row2, row3, row4].forEach {
            $0.axis = .horizontal
            $0.spacing = 36
            $0.alignment = .center
            $0.distribution = .equalSpacing
        }
        
        emptyView.snp.makeConstraints { make in
            make.size.equalTo(64)
        }
    }
    
    func setupHierarchy() {
        addSubview(mainStack)
        
        mainStack.addArrangedSubview(row1)
        mainStack.addArrangedSubview(row2)
        mainStack.addArrangedSubview(row3)
        mainStack.addArrangedSubview(row4)
        
        row1.addArrangedSubview(oneButton)
        row1.addArrangedSubview(twoButton)
        row1.addArrangedSubview(threeButton)
        
        row2.addArrangedSubview(fourButton)
        row2.addArrangedSubview(fiveButton)
        row2.addArrangedSubview(sixButton)
        
        row3.addArrangedSubview(sevenButton)
        row3.addArrangedSubview(eightButton)
        row3.addArrangedSubview(nineButton)
        
        row4.addArrangedSubview(emptyView)
        row4.addArrangedSubview(zeroButton)
    }
    
    // MARK: - Setup Layout
    func setupLayout() {
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - Setup Actions
    func setupActions() {
        let buttons = [oneButton, twoButton, threeButton, fourButton, fiveButton,
                       sixButton, sevenButton, eightButton, nineButton, zeroButton]
        
        buttons.forEach {
            $0.addTarget(self, action: #selector(didTapDigit(_:)), for: .touchUpInside)
        }
    }
    
    // MARK: - Update Active Button State
    func updateActiveButton(for newState: KeyBoardState) {
        state = newState
        
        if let activeButton {
            row4.removeArrangedSubview(activeButton)
            activeButton.removeFromSuperview()
        }
        
        let newButton: UIView
        
        switch newState {
        case .faceID:
            let button = FaceIDButton()
            button.addTarget(self, action: #selector(didTapFaceID), for: .touchUpInside)
            newButton = button
            
        case .delete:
            let button = PinDeleteButton()
            button.addTarget(self, action: #selector(didTapDelete), for: .touchUpInside)
            newButton = button
        }
        
        activeButton = newButton
        row4.addArrangedSubview(newButton)
    }
    
    // MARK: - OBJC Methods
    @objc func didTapDigit(_ sender: PinNumberButton) {
        onDigitTap?("\(sender.number)")
    }
    
    @objc func didTapDelete() {
        onDeleteTap?()
    }
    
    @objc func didTapFaceID() {
        onFaceIDTap?()
    }
}
