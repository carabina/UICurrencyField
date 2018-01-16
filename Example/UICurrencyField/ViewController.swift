import UIKit
import UICurrencyField

final class ViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet private var currencyField: UICurrencyField!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currencyField.amount = 1034.213
        currencyField.currencyIndicator = .symbol
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

