import Foundation

private
final class Counter {
    private let queue: DispatchQueue = .init(label: "Counter")
    private var count: Int = 0
    
    func increment(completion: @escaping (Int) -> Void) {
        queue.async { [self] in
            let count = self.count
            Thread.sleep(forTimeInterval: 1.0)
            self.count = count + 1
            completion(self.count)
        }
    }
}

extension Counter: @unchecked Sendable {}

func counterMain2() {
    let counter: Counter = .init()
    
    Task {
        counter.increment { print($0) }
    }
    
    Task {
        counter.increment { print($0) }
    }
}
