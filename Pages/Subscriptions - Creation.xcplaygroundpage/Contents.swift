import Foundation
import Combine
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

// Timer is a publisher in the Foundation framework
let subscription: AnyCancellable = Timer
    // Returns a publisher that repeatedly emits the current date on the given interval
    .publish(every: 0.5, on: .main, in: .common)
    // Creates a start signal for the TimerPublisher returned from .publish()
    .autoconnect()
    // Selectively republish elements from an upstream publisher during an interval you specify
    .throttle(for: .seconds(2), scheduler: DispatchQueue.main, latest: true)
    // Accumulate all previously-published values into a single value, which you then combine with each newly-published value.
    .scan(0, { (count, _) in
        return count + 1
    })
    // A closure to test each element to determine whether to republish the element to the downstream subscriber
    .filter({ count in
        return count < 6
    })
    // Attach a subscriber, with closure-based behavior, to an upstream publisher
    .sink(receiveCompletion: { completion in
        print("data stream complete: \(completion)")
    }, receiveValue: { (timestamp) in
        print("receieved value: \(timestamp)")
    })

// Cancel a subscription after
DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
    subscription.cancel()
}
