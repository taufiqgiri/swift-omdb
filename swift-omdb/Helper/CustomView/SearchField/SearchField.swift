//
//  SearchField.swift
//  swift-omdb
//
//  Created by Taufiq Ichwanusofa on 14/06/24.
//

import UIKit

protocol SearchFieldDelegate: AnyObject {
    func didIdleTyping()
    func didEndEditing()
}

class SearchField: UIView {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    public var text: String = ""
    
    var typingTimer: Timer?
    weak var delegate: SearchFieldDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        let nib = UINib(nibName: "SearchField", bundle: Bundle(for: type(of: self)))
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
        
        setupView()
    }
    
    private func setupView() {
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        
        searchTextField.delegate = self
        searchTextField.borderStyle = .none
        searchTextField.textColor = .white
        
        let placeholderText = "Search"
        let placeholderColor = UIColor.lightGray
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )
        
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        text = textField.text ?? ""
    }
}

extension SearchField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        resetTypingTimer()
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        resetTypingTimer()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        typingTimer?.invalidate()
        delegate?.didEndEditing()
    }

    func resetTypingTimer() {
        typingTimer?.invalidate()
        typingTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(userStoppedTyping), userInfo: nil, repeats: false)
    }

    @objc func userStoppedTyping() {
        delegate?.didIdleTyping()
    }
}
