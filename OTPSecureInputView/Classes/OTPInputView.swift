//
//  OTPInputView.swift
//  Abhishek Rathi - iOS
//  work.abhirathi@gmail.com
//
//  Created by Abhishek.Rathi on 30/08/19.
//  Copyright © 2019 Abhishek.Rathi. All rights reserved.
//

import UIKit

public protocol OTPViewDelegate {
    func didFinishedEnterOTP(otpNumber: String)
    func otpNotValid()
    func didEndEditing()
    func didBeginEditing()
    func onButtonClicked()
}

public extension OTPViewDelegate {
    func didFinishedEnterOTP(otpNumber: String) {}
    func otpNotValid() {}
    func didEndEditing() {}
    func didBeginEditing() {}
    func onButtonClicked() {}
}

@IBDesignable public class OTPInputView: UIView {
    static let DEFAULT_MAX_DIGITS = 6

    @IBInspectable var backgroundColour: UIColor = .clear
    @IBInspectable var shadowColour: UIColor = .darkGray
    @IBInspectable var textColor: UIColor = .black
    @IBInspectable var font: UIFont = UIFont.boldSystemFont(ofSize: 23)
    @IBInspectable public var maximumDigits: Int = DEFAULT_MAX_DIGITS {
        didSet { self.redraw() }
    }
    @IBInspectable public var secureTextEntry: Bool = false {
        didSet { self.redraw() }
    }
    @IBInspectable public var showButton: Bool = false {
        didSet {
            self.secureTextEntry = showButton
            self.redraw()
        }
    }
    @IBInspectable public var tintImg: UIColor = .white {
        didSet { self.redraw() }
    }
    @available(iOS 13.0, *)
    @IBInspectable public lazy var normalImg: UIImage =
            UIImage(systemName: "eye", withConfiguration: UIImage.SymbolConfiguration(scale: .large)) ?? OTPInputView.VisibilityIcon
             {
        didSet {
            self.redraw()
        }
    }
    @available(iOS 13.0, *)
    @IBInspectable public lazy var selectedImg: UIImage =
            UIImage(systemName: "eye.slash", withConfiguration: UIImage.SymbolConfiguration(scale: .large)) ?? OTPInputView.VisibilityOffIcon {
        didSet {
            self.redraw()
        }
    }
    public var delegateOTP: OTPViewDelegate?
    private lazy var stackView: UIStackView = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .horizontal
        s.alignment = .fill
        s.spacing = 10
        s.distribution = .fillEqually
        return s
    }()
    
    private static var VisibilityIcon: UIImage {
        let bundle = Bundle(for: self)
        return UIImage(named: "ic_visibility", in: bundle, compatibleWith: nil)!
    }

    private static var VisibilityOffIcon: UIImage {
        let bundle = Bundle(for: self)
        return UIImage(named: "ic_visibility_off", in: bundle, compatibleWith: nil)!
    }
    
    private var isSecureTextEntry = true

    override public func prepareForInterfaceBuilder() { setupTextFields() }

    override public func awakeFromNib() { setupTextFields() }

    fileprivate func setupTextFields() {
        backgroundColor = self.backgroundColor
        self.redraw()
        addSubview(stackView)
        NSLayoutConstraint.activate(
                [
                    stackView.widthAnchor.constraint(equalTo: widthAnchor),
                    stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
                    stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
                    stackView.heightAnchor.constraint(equalTo: heightAnchor)
                ]
        )
    }

    private func redraw() {
        stackView.arrangedSubviews.forEach { view in
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        for tag in 1...maximumDigits {
            let textField = OTPTextField()
            textField.tag = tag //set Tag to textField
            stackView.addArrangedSubview(textField)  // Add to stackView
            setupTextFieldStyle(textField)  // set the style accordingly
        }
        if showButton && secureTextEntry {
            let rightButton = setupRightButton()
            stackView.addArrangedSubview(rightButton)
        }
    }

    private func setupRightButton() -> UIButton {
        let rightButton = UIButton(type: .custom)
        rightButton.adjustsImageWhenHighlighted = false
        
        var normalStateImg = OTPInputView.VisibilityIcon
        var selectedStateImg = OTPInputView.VisibilityOffIcon
        
        if #available(iOS 13.0, *) {
            normalStateImg = self.normalImg.withTintColor(tintImg, renderingMode: .alwaysOriginal)
            selectedStateImg = self.selectedImg.withTintColor(tintImg, renderingMode: .alwaysOriginal)
        } else {
            normalStateImg = normalStateImg.maskWithColor(color: tintImg)!
            selectedStateImg = selectedStateImg.maskWithColor(color: tintImg)!
        }
        
        rightButton.setImage(normalStateImg, for: .normal)
        rightButton.setImage(selectedStateImg, for: .selected)
        rightButton.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
        return rightButton
    }

    @objc private func buttonClicked(_ sender: Any) {
        (sender as! UIButton).isSelected = self.isSecureTextEntry
        self.toggleSecureTextEntry()
        isSecureTextEntry.toggle()

        delegateOTP?.onButtonClicked()
    }

    private func toggleSecureTextEntry() {
        stackView.arrangedSubviews.forEach { view in
            if view is UITextField {
                let uiTextField = view as! UITextField
                uiTextField.isSecureTextEntry = !self.isSecureTextEntry
            }
        }
    }

    fileprivate func setupTextFieldStyle(_ textField: UITextField) {
        textField.delegate = self // set up textField delegate
        textField.backgroundColor = .white
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.contentHorizontalAlignment = .center
        textField.layer.cornerRadius = 10
        textField.dropShadow(shadowOpacity: 0.6, shadowColor: shadowColour)
        textField.textColor = textColor
        textField.tintColor = textColor
        textField.font = font
        textField.isSecureTextEntry = secureTextEntry
    }
}

extension OTPInputView: UITextFieldDelegate {

    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String
    ) -> Bool {
        var nextTag = 0

        if string.checkBackspace() {
            textField.deleteBackward()
            return false
        } else if string.count == 1 {
            textField.text = string
            nextTag = textField.tag + 1
        } else if string.count == maximumDigits {
            var otpPasted = string
            for tag in 1...maximumDigits {
                guard let textfield = viewWithTag(tag) as? UITextField else {
                    continue
                }
                textfield.text = String(otpPasted.removeFirst())
            }
            otpFetch()
        }

        if let nextTextfield = viewWithTag(nextTag) as? OTPTextField {
            nextTextfield.becomeFirstResponder()
        } else {
            if nextTag > maximumDigits {
                otpFetch()
            }
            endEditing(true)
        }
        return false
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        delegateOTP?.didBeginEditing()
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegateOTP?.didEndEditing()
    }

    public func otpFetch() {
        var otp = ""
        for tag in 1...maximumDigits {
            guard let textfield = viewWithTag(tag) as? UITextField else {
                continue
            }
            otp += textfield.text!
        }

        // Check if OTP is complete, i.e equals to maxDigits allowed
        if otp.count == maximumDigits {
            delegateOTP?.didFinishedEnterOTP(otpNumber: otp)
        } else {
            delegateOTP?.otpNotValid()
        }
    }

}

extension String {
    func checkBackspace() -> Bool {
        if let char = self.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
            return false
        }
        return false
    }
}

extension UIView {
    func dropShadow(shadowRadius: CGFloat = 2.0,
                    offsetSize: CGSize = CGSize(width: 2, height: 5),
                    shadowOpacity: Float = 0.5,
                    shadowColor: UIColor = UIColor.lightGray
    ) {
        layer.masksToBounds = false
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = offsetSize
        layer.shadowRadius = shadowRadius
    }
}

extension UIImage {

    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!

        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!

        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)

        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }

}
