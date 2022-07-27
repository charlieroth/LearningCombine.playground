import Foundation
import Combine

// Publishers that will pass a limited number of values

let foodbank = ["apple", "bread", "orange", "milk"].publisher
//let sub1 = foodbank.sink(receiveCompletion: { completion in
//    print("completion: \(completion)")
//}, receiveValue: { item in
//    print("received item: \(item)")
//})

let calendar = Calendar.current
let endDate = calendar.date(byAdding: .second, value: 3, to: Date())
struct EndDateError: Error {}
func throwAtEndDate(foodItem: String, date: Date) throws -> String {
    if date < endDate! {
        return "\(foodItem) at \(date)"
    }
    
    throw EndDateError()
}

let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
// Combine elements from foodbank and timer publisher and deliver pairs of elements as tuples
let sub2 = foodbank.zip(timer)
    // Transforms all elements from the upstream publisher with a provided error-throwing closure
    .tryMap({ (foodItem, timestamp) in
        try throwAtEndDate(foodItem: foodItem, date: timestamp)
    })
    .sink { completion in
        switch completion {
            case .finished:
                print("completion: finished")
            case .failure(let error):
                print("completion with failure: \(error)")
        }
    } receiveValue: { result in
        print("\(result)")
    }
