//
//  UILabelHelper.swift
//  WeatherApp
//
//  Created by Олег Зуев on 04.03.2026.
//

import Foundation
import UIKit


struct TextStyle {
    let font: UIFont
    let lineHeight: CGFloat?      // nil = не трогаем
    let kern: CGFloat?            // nil = не трогаем
    let alignment: NSTextAlignment

    init(
        font: UIFont,
        lineHeight: CGFloat? = nil,
        kern: CGFloat? = nil,
        alignment: NSTextAlignment = .natural
    ) {
        self.font = font
        self.lineHeight = lineHeight
        self.kern = kern
        self.alignment = alignment
    }

    func attributed(_ text: String, color: UIColor = .label) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment

        var attrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraph
        ]

        if let lineHeight {
            paragraph.minimumLineHeight = lineHeight
            paragraph.maximumLineHeight = lineHeight
        }

        if let kern {
            attrs[.kern] = kern
        }

        return NSAttributedString(string: text, attributes: attrs)
    }
}

extension UILabel {
    func apply(_ style: TextStyle, text: String, color: UIColor = .label) {
        attributedText = style.attributed(text, color: color)
    }
}


final class PaddedTextField: UITextField {

    private let padding: UIEdgeInsets

    init(padding: UIEdgeInsets) {
        self.padding = padding
        super.init(frame: .zero)
        borderStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
}

extension UILabel {
    func underline() {
        guard let text else { return }
        
        attributedText = NSAttributedString(
            string: text,
            attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue]
        )
    }
}
