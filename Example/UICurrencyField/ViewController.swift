import UIKit
import UICurrencyField

final class ViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet private var currencyField: UICurrencyField!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currencyField.amount = 1034.213
    }
}

