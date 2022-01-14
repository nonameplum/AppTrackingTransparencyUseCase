import XCTest
@testable import AppTrackingKit

final class SearchUserActionStorageTests: UserDefaultsTestsCase {

    func test_searchCount_whenFreshInstance_returns0() {
        let sut = makeSUT()

        XCTAssertFalse(sut.markedDidSearch)
    }

    func test_searchCount_whenDidSearch_returns1() {
        let sut = makeSUT()

        sut.didSearch()

        XCTAssertTrue(sut.markedDidSearch)
    }

    func test_searchCount_persists() {
        let userDefaults = makeUserDefaults()
        let sut = makeSUT(userDefaults: userDefaults)

        sut.didSearch()

        XCTAssertTrue(sut.markedDidSearch)

        let sut2 = makeSUT(userDefaults: userDefaults)

        XCTAssertTrue(sut2.markedDidSearch)
    }

    // MARK: Helpers
    func makeSUT(userDefaults: UserDefaults? = nil) -> SearchUserActionStorage {
        return SearchUserActionStorage(userDefaults: userDefaults ?? makeUserDefaults())
    }
}
