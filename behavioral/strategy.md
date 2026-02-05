# Strategy Pattern

> Define family of algorithms, make them interchangeable

## Problem

- Need to switch between algorithms at runtime
- Have multiple ways to do the same thing
- Want to avoid large conditional statements

## Solution

```swift
// MARK: - Strategy Protocol
protocol SortingStrategy {
    func sort<T: Comparable>(_ array: [T]) -> [T]
    var name: String { get }
    var timeComplexity: String { get }
}

// MARK: - Concrete Strategies
class QuickSortStrategy: SortingStrategy {
    let name = "Quick Sort"
    let timeComplexity = "O(n log n) average"
    
    func sort<T: Comparable>(_ array: [T]) -> [T] {
        guard array.count > 1 else { return array }
        
        let pivot = array[array.count / 2]
        let less = array.filter { $0 < pivot }
        let equal = array.filter { $0 == pivot }
        let greater = array.filter { $0 > pivot }
        
        return sort(less) + equal + sort(greater)
    }
}

class MergeSortStrategy: SortingStrategy {
    let name = "Merge Sort"
    let timeComplexity = "O(n log n)"
    
    func sort<T: Comparable>(_ array: [T]) -> [T] {
        guard array.count > 1 else { return array }
        
        let middle = array.count / 2
        let left = sort(Array(array[..<middle]))
        let right = sort(Array(array[middle...]))
        
        return merge(left, right)
    }
    
    private func merge<T: Comparable>(_ left: [T], _ right: [T]) -> [T] {
        var result: [T] = []
        var leftIndex = 0
        var rightIndex = 0
        
        while leftIndex < left.count && rightIndex < right.count {
            if left[leftIndex] < right[rightIndex] {
                result.append(left[leftIndex])
                leftIndex += 1
            } else {
                result.append(right[rightIndex])
                rightIndex += 1
            }
        }
        
        result.append(contentsOf: left[leftIndex...])
        result.append(contentsOf: right[rightIndex...])
        return result
    }
}

class InsertionSortStrategy: SortingStrategy {
    let name = "Insertion Sort"
    let timeComplexity = "O(n²)"
    
    func sort<T: Comparable>(_ array: [T]) -> [T] {
        var result = array
        for i in 1..<result.count {
            var j = i
            while j > 0 && result[j] < result[j - 1] {
                result.swapAt(j, j - 1)
                j -= 1
            }
        }
        return result
    }
}

// MARK: - Context
class DataSorter {
    private var strategy: SortingStrategy
    
    init(strategy: SortingStrategy = QuickSortStrategy()) {
        self.strategy = strategy
    }
    
    func setStrategy(_ strategy: SortingStrategy) {
        self.strategy = strategy
    }
    
    func sort<T: Comparable>(_ data: [T]) -> [T] {
        print("Using \(strategy.name) - \(strategy.timeComplexity)")
        return strategy.sort(data)
    }
    
    func smartSort<T: Comparable>(_ data: [T]) -> [T] {
        if data.count < 10 {
            strategy = InsertionSortStrategy()
        } else if data.count > 10000 {
            strategy = MergeSortStrategy()
        } else {
            strategy = QuickSortStrategy()
        }
        return sort(data)
    }
}

// Usage
let sorter = DataSorter()
let numbers = [64, 34, 25, 12, 22, 11, 90]

sorter.setStrategy(QuickSortStrategy())
let quickSorted = sorter.sort(numbers)

sorter.setStrategy(MergeSortStrategy())
let mergeSorted = sorter.sort(numbers)
```

## Payment Strategy Example

```swift
protocol PaymentStrategy {
    var displayName: String { get }
    var icon: String { get }
    func validate() throws
    func process(amount: Decimal) async throws -> PaymentResult
}

class CreditCardPayment: PaymentStrategy {
    let displayName = "Credit Card"
    let icon = "creditcard.fill"
    
    private let cardNumber: String
    private let expiry: String
    private let cvv: String
    
    init(cardNumber: String, expiry: String, cvv: String) {
        self.cardNumber = cardNumber
        self.expiry = expiry
        self.cvv = cvv
    }
    
    func validate() throws {
        guard cardNumber.count == 16 else {
            throw PaymentError.invalidCardNumber
        }
        guard cvv.count == 3 else {
            throw PaymentError.invalidCVV
        }
    }
    
    func process(amount: Decimal) async throws -> PaymentResult {
        try validate()
        return try await StripeAPI.charge(card: cardNumber, amount: amount)
    }
}

class ApplePayPayment: PaymentStrategy {
    let displayName = "Apple Pay"
    let icon = "apple.logo"
    
    func validate() throws {
        guard PKPaymentAuthorizationController.canMakePayments() else {
            throw PaymentError.applePayNotAvailable
        }
    }
    
    func process(amount: Decimal) async throws -> PaymentResult {
        try validate()
        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.app"
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(decimal: amount))
        ]
        
        return try await withCheckedThrowingContinuation { continuation in
            let controller = PKPaymentAuthorizationController(paymentRequest: request)
            controller.present()
        }
    }
}

// Context
class CheckoutViewModel: ObservableObject {
    @Published var selectedStrategy: PaymentStrategy?
    @Published var availableStrategies: [PaymentStrategy] = []
    
    func loadPaymentMethods() {
        var strategies: [PaymentStrategy] = []
        strategies.append(PayPalPayment())
        
        if PKPaymentAuthorizationController.canMakePayments() {
            strategies.append(ApplePayPayment())
        }
        
        availableStrategies = strategies
        selectedStrategy = strategies.first
    }
    
    func checkout(amount: Decimal) async throws -> PaymentResult {
        guard let strategy = selectedStrategy else {
            throw CheckoutError.noPaymentMethod
        }
        return try await strategy.process(amount: amount)
    }
}
```

## When to Use ✅

- Multiple algorithms for same task
- Switch algorithms at runtime
- Avoid conditional statements
- Algorithms should be interchangeable

## When NOT to Use ❌

- Only one algorithm exists
- Algorithms rarely change
- Algorithm selection is static

## Related Patterns

- **State**: Similar structure, different intent
- **Command**: Encapsulates single operation
- **Template Method**: Defines algorithm skeleton
