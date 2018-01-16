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
        currencyField.locale = Locale(identifier: "fr_FR")
        currencyField.amount = 1034.213
        
        currencyField.currencyIndicator = .symbol
        currencyField.currencyTextColor = .blue
        currencyField.integerTextColor = .green
        currencyField.decimalTextColor = .red
        
        currencyField.currencyFont = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

