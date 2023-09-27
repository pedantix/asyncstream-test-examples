import XCTest
@testable import AsyncStreamExample

final class AsyncStreamExampleTests: XCTestCase {
    func testExample() async throws {
        let tm = TestableMonitor(delays: [100, 200, 300, 400, 500])
        var yieldedResult = 0
        for try await value in tm.testStream {
            yieldedResult += value
        }

        XCTAssertEqual(1500, yieldedResult)
    }
}

@MainActor
final class MainActorAsyncStreamExampleTests: XCTestCase {
    func testExample() async throws {
        let tm = TestableMonitor(delays: [100, 200, 300, 400, 500])
        var yieldedResult = 0
        for try await value in tm.testStream {
            yieldedResult += value
        }

        XCTAssertEqual(1500, yieldedResult)
    }
}

final class AsyncStreamMockExampleTests: XCTestCase {
    func testExample() async throws {
        let testArray = [1,2,3,4,5]
        let stream = AsyncStream<Int> { cont in
            for element in testArray {
                cont.yield(element)
            }
            cont.finish()
        }
        let mocked = ThingWithMockedAsyncStream(asyncStream: stream)

        XCTAssertNotEqual(mocked.resultsCollection, testArray)
        await mocked.run()
        XCTAssertEqual(mocked.resultsCollection, testArray)
    }
}

@MainActor
final class MainActorAsyncStreamMockExampleTests: XCTestCase {
    func testExample() async throws {
        let testArray = [1,2,3,4,5]
        let stream = AsyncStream<Int> { cont in
            for element in testArray {
                cont.yield(element)
            }
            cont.finish()
        }
        let mocked = ThingWithMockedAsyncStream(asyncStream: stream)

        XCTAssertNotEqual(mocked.resultsCollection, testArray)
        await mocked.run()
        XCTAssertEqual(mocked.resultsCollection, testArray)
    }
}
