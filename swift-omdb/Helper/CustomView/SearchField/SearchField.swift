//
//  SearchField.swift
//  swift-omdb
//
//  Created by Taufiq Ichwanusofa on 14/06/24.
//

import UIKit

class SearchField: UIView {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
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
        
        searchTextField.borderStyle = .none
        searchTextField.textColor = .white
        
        let placeholderText = "Search"
        let placeholderColor = UIColor.lightGray
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )
    }
}
