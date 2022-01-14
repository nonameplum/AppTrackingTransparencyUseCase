import XCTest
@testable import AppTrackingKit

final class AppLaunchIDFAStorageTests: UserDefaultsTestsCase {

    func test_appLaunchCount_whenIncrementAppLaunch_returnsIncrementedCount() {
        let sut = makeSUT()

        XCTAssertEqual(sut.appLaunchCount, 0, "precondition")

        sut.incrementAppLaunch()

        XCTAssertEqual(sut.appLaunchCount, 1)

        sut.incrementAppLaunch()

        XCTAssertEqual(sut.appLaunchCount, 2)
    }

    func test_isCountIDFAUsed_whenNothingMarked_returnsFalse() {
        let sut = makeSUT()

        XCTAssertFalse(sut.isCurrentAppLaunchCountMarked())
    }

    func test_isCountIDFAUsed_withCount1_returnsTrue() {
        let sut = makeSUT()

        sut.incrementAppLaunch()
        sut.markAsUsedCurrentAppLaunchCount()

        XCTAssertTrue(sut.isCurrentAppLaunchCountMarked())
    }

    func test_isCountIDFAUsed_withNotMatchingCount_returnsFalse() {
        let sut = makeSUT()

        sut.incrementAppLaunch()
        sut.markAsUsedCurrentAppLaunchCount()
        sut.incrementAppLaunch()

        XCTAssertFalse(sut.isCurrentAppLaunchCountMarked())
    }

    func test_appLaunchCount_persists() {
        let userDefaults = makeUserDefaults()
        let sut1 = makeSUT(userDefaults: userDefaults)

        XCTAssertEqual(sut1.appLaunchCount, 0, "precondition")

        sut1.incrementAppLaunch()

        XCTAssertEqual(sut1.appLaunchCount, 1)

        let sut2 = makeSUT(userDefaults: userDefaults)

        XCTAssertEqual(sut2.appLaunchCount, 1)
    }

    func test_markUsedAppLaunchCount_persists() {
        let userDefaults = makeUserDefaults()
        let sut1 = makeSUT(userDefaults: userDefaults)

        sut1.incrementAppLaunch()
        XCTAssertFalse(sut1.isCurrentAppLaunchCountMarked(), "precondition")

        sut1.markAsUsedCurrentAppLaunchCount()

        XCTAssertTrue(sut1.isCurrentAppLaunchCountMarked())

        let sut2 = makeSUT(userDefaults: userDefaults)

        XCTAssertTrue(sut2.isCurrentAppLaunchCountMarked())
    }

    // MARK: Helpers

    private func makeSUT(userDefaults: UserDefaults? = nil) -> AppLaunchIDFAStorage {
        return AppLaunchIDFAStorage(userDefaults: userDefaults ?? makeUserDefaults())
    }
}
