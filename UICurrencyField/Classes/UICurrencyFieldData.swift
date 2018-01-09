import Foundation

struct UICurrencyFieldData {
    var raw: Double {
        get {
            let str = intPart + decimalPart
            return Double(str) ?? 0
        }
    }
    
    init(raw: Double?) {
        if let raw = raw {
            let str = "\(raw)"
            let split = str.split(separator: Character("."))
            self.intPart = String(split[0])
            self.decimalPart = String(split[1])
        } else {
            self.intPart = ""
            self.decimalPart = ""
        }
        self.formatter = NumberFormatter()
    }
    
    var locale: Locale = .current {
        didSet {
            formatter.locale = locale
        }
    }
    
    var formattedInt: String {
        guard let doubleIntPart = Double(intPart) else {
            return ""
        }
        return formatter.string(from: NSNumber(value: doubleIntPart)) ?? ""
    }
    
    var formattedDecimal: String {
        return decimalPart
    }
    
    var hasDecimal: Bool {
        return decimalPart.count > 0
    }
    
    var isEmpty: Bool {
        return decimalPart == "" && intPart == ""
    }
    
    private var intPart: String
    private var decimalPart: String
    private var formatter: NumberFormatter
    
    mutating func removeLast() {
        if hasDecimal {
            decimalPart = String(decimalPart.dropLast())
        } else {
            intPart = String(intPart.dropLast())
        }
    }
    
    mutating func add(text: String, decimal: Bool = false) {
        if hasDecimal || decimal {
            decimalPart = decimalPart + text
        } else {
            intPart = intPart + text
        }
    }
}
