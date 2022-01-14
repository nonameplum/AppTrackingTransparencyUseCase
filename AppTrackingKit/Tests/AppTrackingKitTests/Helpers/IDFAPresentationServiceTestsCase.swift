import XCTest
@testable import AppTrackingKit

class IDFAPresentationServiceTestsCase: UserDefaultsTestsCase {
    final class IDFAPresentationServiceMock: IDFAPresentationHandlerProtocol {
        var nextHandler: IDFAPresentationHandlerProtocol?
        var shouldShowIDFAPopupCallCount = 0
        var result: Bool = false

        func shouldShowIDFAPopup() -> Bool {
            self.shouldShowIDFAPopupCallCount += 1
            return self.result
        }
    }

    func makeSUT<T: IDFAPresentationHandlerProtocol>(
        _ sut: T,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: T, mock: IDFAPresentationServiceMock) {
        let mock = IDFAPresentationServiceMock()
        sut.setNext(handler: mock)

        trackForMemoryLeaks(mock, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, mock)
    }
}

class UserDefaultsTestsCase: XCTestCase {
    func makeUserDefaults() -> UserDefaults {
        let suiteName = UUID().uuidString
        let userDefaults = UserDefaults(suiteName: suiteName)!
        addTeardownBlock {
            userDefaults.removeSuite(named: suiteName)
        }
        return userDefaults
    }
}
