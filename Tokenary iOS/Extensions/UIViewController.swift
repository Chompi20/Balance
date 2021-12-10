// Copyright © 2021 Tokenary. All rights reserved.

import UIKit

extension UIViewController {
    
    var inNavigationController: UINavigationController {
        let navigationController = UINavigationController()
        navigationController.viewControllers = [self]
        return navigationController
    }
    
    @objc func dismissAnimated() {
        dismiss(animated: true)
    }
    
    func showMessageAlert(text: String) {
        let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: Strings.ok, style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func showPasswordAlert(title: String, completion: @escaping ((String) -> Void)) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.isSecureTextEntry = true
            textField.textContentType = .oneTimeCode
        }
        let okAction = UIAlertAction(title: Strings.ok, style: .default) { [weak alert] _ in
            completion(alert?.textFields?.first?.text ?? "")
        }
        let cancelAction = UIAlertAction(title: Strings.cancel, style: .cancel)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        alert.textFields?.first?.becomeFirstResponder()
    }
    
}
