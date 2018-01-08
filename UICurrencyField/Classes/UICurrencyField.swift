import UIKit

struct UICurrencyFieldData {
    var int: String?
    var decimal: String?
}

public protocol UICurrencyFieldDelegate: class {
    func should()
}

public final class UICurrencyField: UIControl {
    
    // MARK: - Nested
    
    public enum State {
        case empty
        case normal
    }
    
    // MARK: - Properties
    
    weak var delegate: UICurrencyFieldDelegate?
    
    public override var canBecomeFirstResponder: Bool {
        return true
    }
    
    public var aState: State = .empty {
        didSet {
            render()
        }
    }
    public var locale: Locale = .current {
        didSet {
            render()
        }
    }
    public var amount: Double = 0
    
    // Create an adapter to data, using text or number input parsing it to data
    var data: UICurrencyFieldData = UICurrencyFieldData(int: nil, decimal: nil) {
        didSet {
            render()
        }
    }
    
    var editingDecimal: Bool = false
    
    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
        setUpConstraints()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
        setUpConstraints()
    }
    
    // MARK: - Instance Methods
    
    func render() {
        currencyLabel.text = locale.currencySymbol
        separatorLabel.text = locale.decimalSeparator
        switch aState {
        case .normal:
            if let int = data.int  {
                integerLabel.text = int
                integerLabel.textColor = .black
            }
            
            if let decimal = data.decimal, decimal.count > 0 {
                stackView.insertArrangedSubview(separatorLabel, at: 2)
                stackView.insertArrangedSubview(decimalLabel, at: 3)
                decimalLabel.text = decimal
                decimalLabel.textColor = .black
            } else {
                separatorLabel.removeFromSuperview()
                decimalLabel.removeFromSuperview()
            }
        case .empty:
            integerLabel.text = "00"
            decimalLabel.text = "00"
            integerLabel.textColor = .gray
            decimalLabel.textColor = .gray
        }
    }
    
    // MARK: - Actions
    
    @objc func tapped() {
        becomeFirstResponder()
    }
    
    // MARK: - Private
    
    private func setUpView() {
        addSubview(stackView)
        stackView.addArrangedSubview(currencyLabel)
        stackView.addArrangedSubview(integerLabel)
        stackView.addArrangedSubview(separatorLabel)
        stackView.addArrangedSubview(decimalLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        stackView.addGestureRecognizer(tap)
    }
    
    private func setUpConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor).isActive = true
        
        decimalLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        decimalLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        separatorLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        separatorLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        integerLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        integerLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    // MARK: - Lazy var
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = UIStackViewAlignment.fill
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private lazy var currencyLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var integerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    private lazy var separatorLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var decimalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    public var keyboardType: UIKeyboardType = .decimalPad
}

// UITextInputTraits
extension UICurrencyField: UIKeyInput {
    public var hasText: Bool {
        switch aState {
        case .empty:
            return false
        default:
            return true
        }
    }
    
    public func insertText(_ text: String) {
        if text == locale.decimalSeparator || text == "," {
            editingDecimal = true
            stackView.insertArrangedSubview(separatorLabel, at: 2)
            return
        }
        
        if let decimal = data.decimal, decimal.count > 0 {
            data.decimal = decimal + text
        } else if editingDecimal {
            data.decimal = text
        } else if let int = data.int {
            data.int = int + text
        } else {
            data.int = text
        }
    }
    
    public func deleteBackward() {
        if var decimal = data.decimal, decimal.count > 0 {
            decimal.removeLast()
            data.decimal = decimal
            editingDecimal = decimal.count > 0
        } else if var int = data.int, int.count > 0 {
            editingDecimal = false
            int.removeLast()
            data.int = int
        }
    }
}

extension UICurrencyField: UITextInputTraits {
    var property: UITextAutocorrectionType {
        return .no
    }
}

extension UICurrencyField: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == gestureRecognizer.view
    }
}
