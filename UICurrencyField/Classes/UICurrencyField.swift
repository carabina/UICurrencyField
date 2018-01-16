import UIKit

public protocol UICurrencyFieldDelegate: class {
    func should()
}

public final class UICurrencyField: UIControl {
    
    // MARK: - Nested
    
    public enum CurrencyIndicator {
        case code
        case symbol
    }
    
    // MARK: - Properties
    
    public weak var delegate: UICurrencyFieldDelegate?
    
    public override var canBecomeFirstResponder: Bool {
        return true
    }
    
    public var displayCursor: Bool = false
    
    public var locale: Locale {
        set { data.locale = locale }
        get { return data.locale }
    }
    public var amount: Double? {
        set { data = UICurrencyFieldData(raw: newValue) }
        get { return data.raw }
    }
    public var maxDecimals: Int = 2
    public var minDecimals: Int = 0
    // needs to fill decimals on edit end
    public var currencyIndicator: CurrencyIndicator = .code {
        didSet { render() }
    }
    
    private var data: UICurrencyFieldData = UICurrencyFieldData(raw: nil) {
        didSet { render() }
    }
    
    private var editingDecimal: Bool = false
    
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
    
    // MARK: - Actions
    
    @objc func tapped() {
        becomeFirstResponder()
        if displayCursor {
            stackView.addArrangedSubview(cursor)
        }
    }
    
    // MARK: - Private
    
    private func render() {
        currencyLabel.text = currencyIndicator == .symbol ? locale.currencySymbol : locale.currencyCode
        separatorLabel.text = locale.decimalSeparator
        
        if data.isEmpty {
            integerLabel.text = "Placeholder"
            integerLabel.textColor = .lightGray
            separatorLabel.removeFromSuperview()
            decimalLabel.removeFromSuperview()
        } else {
            integerLabel.text = data.formattedInt
            integerLabel.textColor = .black
            
            if data.hasDecimal {
                stackView.insertArrangedSubview(separatorLabel, at: 2)
                stackView.insertArrangedSubview(decimalLabel, at: 3)
                decimalLabel.text = data.formattedDecimal
                decimalLabel.textColor = .black
            } else {
                separatorLabel.removeFromSuperview()
                decimalLabel.removeFromSuperview()
            }
        }
    }
    
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
    
    private lazy var cursor: UIView = {
        let view = UIView()
        view.backgroundColor = tintColor
        view.widthAnchor.constraint(equalToConstant: 3).isActive = true
        view.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return view
    }()
    
    public var keyboardType: UIKeyboardType = .decimalPad
}

extension UICurrencyField: UIKeyInput {
    public var hasText: Bool {
        return data.isEmpty
    }
    
    public func insertText(_ text: String) {
        if text == locale.decimalSeparator || text == "," {
            if data.isEmpty {
                data.add(text: "0")
            }
            editingDecimal = true
            stackView.insertArrangedSubview(separatorLabel, at: 2)
            return
        }
        if data.nbDecimals < maxDecimals {
            data.add(text: text, decimal: editingDecimal)
            editingDecimal = false
            print("INSERT TEXT \(text), CURRENT RAW DATA: \(data.raw)")
        }
    }
    
    public func deleteBackward() {
        data.removeLast()
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
