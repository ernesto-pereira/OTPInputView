//
//  ViewController.swift
//  OTPInputView
//
//  Created by abhishek-001 on 09/14/2019.
//  Copyright (c) 2019 abhishek-001. All rights reserved.
//

import UIKit
import OTPSecureInputView

class ViewController: UIViewController {

    @IBOutlet weak var otpInputView: OTPInputView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        otpInputView.delegateOTP = self
        do{
            try otpInputView.otpSet(content: "12345")
        } catch {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showPinAction(_ sender: Any) {
        otpInputView.otpFetch()
    }
    
    func showPopupAlert(title: String? = "", message: String?, actionTitles:[String?] = ["Okay"], actions:[((UIAlertAction) -> Void)?] = [nil]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension ViewController: OTPViewDelegate {
    
    func didFinishedEnterOTP(otpNumber: String) {
        showPopupAlert(title:otpNumber, message: "One time code")
    }
    
    func otpNotValid() {
        showPopupAlert(title:"OTP Error", message:"")
    }
    
    
    
}
