//
//  OneTimeNumberField.swift
//  Bulls and Cows
//
//  Created by Mete Hergül on 31.08.2020.
//  Copyright © 2020 CSTECH. All rights reserved.
//

import UIKit
 
import UIKit

class OneTimeNumberField: UITextField {
       
    private var isConfigured = false
    private var digitLabels = [UILabel()]
    var defaultCharacter = "_"
    
    private lazy var tapRecogniser: UITapGestureRecognizer = {
        let recogniser = UITapGestureRecognizer()
        recogniser.addTarget(self, action: #selector(becomeFirstResponder))
        return recogniser
    }()
    
    func configure(with slotCount: Int = 4)
    {
        guard isConfigured == false else { return }
        isConfigured.toggle()
        configureTextField()
        
        let labelsStackView = createLabelsStackView(with: slotCount)
        addSubview(labelsStackView)
        
        addGestureRecognizer(tapRecogniser)
        
        NSLayoutConstraint.activate([
            labelsStackView.topAnchor.constraint(equalTo: topAnchor),
            labelsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            labelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func clear()
    {
        for i in digitLabels
        {
            i.text = defaultCharacter
            self.text = ""
            self.configure()
        }
        
    }
    
    private func configureTextField()
    {
        tintColor = .clear
        textColor = .clear
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        delegate = self
    }
    
    private func createLabelsStackView(with count: Int) -> UIStackView
    {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        for _ in 1...count
        {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 40)
            label.backgroundColor = .clear
            label.isUserInteractionEnabled = true
            label.text = defaultCharacter
            
            stackView.addArrangedSubview(label)
            
            digitLabels.append(label)
        }
        
        return stackView
    }
    
    @objc
    private func textDidChange()
    {
        guard let text = self.text, text.count <= digitLabels.count else { return }
        
        for i in 0 ..< digitLabels.count - 1
        {
            let currentLabel = digitLabels[i + 1]
            
            if i < text.count
            {
                let index = text.index(text.startIndex,offsetBy: i)
                currentLabel.text = "\(text[index])"
            }
            else{
                currentLabel.text? = defaultCharacter
            }
        }
    }
}

extension OneTimeNumberField: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        guard let characterCount = textField.text?.count else { return false }
        return characterCount < digitLabels.count - 1 || string == ""
    }
}
