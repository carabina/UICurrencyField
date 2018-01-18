import UIKit

public protocol UICurrencyFieldDelegate: class {
    func currencyField(_ currencyField: UICurrencyField, valueChanged value: Double?)
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
        didSet { currencyLabel.text = currencyIndicator == .symbol ? locale.currencySymbol : locale.currencyCode }
    }
    public var currencyTextColor: UIColor = .black {
        didSet { currencyLabel.textColor = currencyTextColor }
    }
    public var integerTextColor: UIColor = .black {
        didSet { integerLabel.textColor = integerTextColor }
    }
    public var decimalTextColor: UIColor = .black {
        didSet { decimalLabel.textColor = decimalTextColor }
    }
    public var currencyFont: UIFont = UIFont.preferredFont(forTextStyle: .title1) {
        didSet { currencyLabel.font = currencyFont }
    }
    public var integerFont: UIFont = UIFont.preferredFont(forTextStyle: .title1) {
        didSet { integerLabel.font = integerFont }
    }
    public var decimalFont: UIFont = UIFont.preferredFont(forTextStyle: .footnote) {
        didSet { decimalLabel.font = decimalFont }
    }
    public var placeholder: String = "00.00" {
        didSet {
            if data.isEmpty {
                integerLabel.text = placeholder
            }
        }
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
        renderStyle()
        renderData()
    }
    
    private func renderStyle() {
        currencyLabel.textColor = currencyTextColor
        
        if data.isEmpty {
            integerLabel.textColor = integerTextColor.withAlphaComponent(0.3)
            separatorLabel.removeFromSuperview()
            decimalLabel.removeFromSuperview()
        } else {
            integerLabel.textColor = integerTextColor

            if data.hasDecimal {
                stackView.insertArrangedSubview(separatorLabel, at: 2)
                stackView.insertArrangedSubview(decimalLabel, at: 3)
                decimalLabel.textColor = decimalTextColor
            } else {
                separatorLabel.removeFromSuperview()
                decimalLabel.removeFromSuperview()
            }
        }
    }
    
    private func renderData() {
        currencyLabel.text = currencyIndicator == .symbol ? locale.currencySymbol : locale.currencyCode
        separatorLabel.text = locale.decimalSeparator
        
        if data.isEmpty {
            integerLabel.text = placeholder
        } else {
            integerLabel.text = data.formattedInt
            
            if data.hasDecimal {
                decimalLabel.text = data.formattedDecimal
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
    
    private var currencyLabel = UILabel()
    private var integerLabel = UILabel()
    private var separatorLabel = UILabel()
    private var decimalLabel = UILabel()
    
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
            delegate?.currencyField(self, valueChanged: amount)
            return
        }
        if data.nbDecimals < maxDecimals {
            data.add(text: text, decimal: editingDecimal)
            editingDecimal = false
            delegate?.currencyField(self, valueChanged: amount)
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
