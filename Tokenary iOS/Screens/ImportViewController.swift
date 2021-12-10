// Copyright © 2021 Tokenary. All rights reserved.

import UIKit

class ImportViewController: UIViewController {
    
    var completion: ((Bool) -> Void)?
    private let walletsManager = WalletsManager.shared
    
    @IBOutlet weak var pasteButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.delegate = self
        }
    }
    
    private var inputValidationResult = WalletsManager.InputValidationResult.invalid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = Strings.importAccount
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissAnimated))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.navigationBar.sizeToFit()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textView.becomeFirstResponder()
    }
    
    @IBAction func pasteButtonTapped(_ sender: Any) {
        if let text = UIPasteboard.general.string {
            textView.text = text
            validateInput(proceedIfValid: false)
        }
    }
    
    @IBAction func okButtonTapped(_ sender: Any) {
        attemptImportWithCurrentInput()
    }
    
    private func attemptImportWithCurrentInput() {
        if inputValidationResult == .requiresPassword {
            askPassword()
        } else {
            importWith(input: textView.text, password: nil)
        }
    }
    
    private func askPassword() {
        showPasswordAlert(title: Strings.enterKeystorePassword) { [weak self] password in
            self?.importWith(input: self?.textView.text ?? "", password: password)
        }
    }
    
    private func importWith(input: String, password: String?) {
        do {
            _ = try walletsManager.addWallet(input: input, inputPassword: password)
            completion?(true)
            dismissAnimated()
        } catch {
            showMessageAlert(text: Strings.failedToImportAccount)
        }
    }
    
    private func validateInput(proceedIfValid: Bool) {
        inputValidationResult = walletsManager.validateWalletInput(textView.text)
        let isValid = inputValidationResult != .invalid
        okButton.isEnabled = isValid
        if isValid && proceedIfValid {
            attemptImportWithCurrentInput()
        }
    }
    
}

extension ImportViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            validateInput(proceedIfValid: true)
            return false
        } else {
            return true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        validateInput(proceedIfValid: false)
    }
    
}
