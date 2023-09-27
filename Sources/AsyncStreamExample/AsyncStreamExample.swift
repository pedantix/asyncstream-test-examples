// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

class TestableMonitor {
    let delays: [Int]

    init(delays: [Int]) {
        self.delays = delays
    }
    private var idx = 0
    private(set) var streamStopped: Bool = false

    lazy var testStream: AsyncThrowingStream<Int, any Error> = {
        return AsyncThrowingStream<Int, any Error> { continuation in
              Task.detached {
                  for delay in self.delays {
                      do {
                          try await Task.sleep(for: ContinuousClock.Duration.milliseconds(delay))
                          continuation.yield(delay)
                      } catch {
                          continuation.finish(throwing: error)
                      }
                  }
                  continuation.finish()
            }
          }
    }()
}

class ThingWithMockedAsyncStream<Element> {
    var asyncStream: AsyncStream<Element>

    private(set) var resultsCollection = [Element]()
    
    init(asyncStream: AsyncStream<Element>) {
        self.asyncStream = asyncStream
    }

    func run() async {
        for await result in asyncStream {
            resultsCollection.append(result)
        }
    }
}
