import XCTest
@testable import AppTrackingKit

final class AppLaunchIDFAPresentationServiceTests: IDFAPresentationServiceTestsCase {

    func test_shouldShowIDFAPopup_whenAppOpenedLessThan3Times_returnsFalse_andShouldCallNextHandler_onSecondAsk() {
        let (sut, mock) = makeSUT(didSearch: true)

        XCTAssertFalse(sut.shouldShowIDFAPopup())

        XCTAssertEqual(mock.shouldShowIDFAPopupCallCount, 0, "precondition")

        XCTAssertFalse(sut.shouldShowIDFAPopup())

        XCTAssertEqual(mock.shouldShowIDFAPopupCallCount, 1)
    }

    func test_shouldShowIDFAPopup_whenAppOpenedLessThan3Times_returnsFalse_returnsNextHandlerValue() {
        let (sut, mock) = makeSUT(didSearch: true)
        mock.result = false

        XCTAssertFalse(sut.shouldShowIDFAPopup())

        mock.result = true

        XCTAssertTrue(sut.shouldShowIDFAPopup())
    }

    func test_shouldShowIDFAPopup_whenAppLaunch_3Times_andDidSearch_returnsTrue() {
        let (sut, _) = makeSUT(didSearch: true, appLaunchCount: 3)

        XCTAssertTrue(sut.shouldShowIDFAPopup())
    }

    func test_shouldShowIDFAPopup_whenAppLaunch_3Times_andDidNotSearch_returnsFalse() {
        let (sut, _) = makeSUT(didSearch: false, appLaunchCount: 3)

        XCTAssertFalse(sut.shouldShowIDFAPopup())
    }

    func test_shouldShowIDFAPopup_whenAppLaunch_9Times_andDidSearch_returnsTrue() {
        let (sut, _) = makeSUT(didSearch: true, appLaunchCount: 9)

        XCTAssertTrue(sut.shouldShowIDFAPopup())
    }

    func test_shouldShowIDFAPopup_whenTrueForAppLaunchCount_3_nextTime_returnsFalse_andShouldCallNextHandler() {
        let (sut, mock) = makeSUT(didSearch: true, appLaunchCount: 3)

        XCTAssertTrue(sut.shouldShowIDFAPopup(), "precondition")

        XCTAssertFalse(sut.shouldShowIDFAPopup())
        XCTAssertEqual(mock.shouldShowIDFAPopupCallCount, 1)
    }

    func test_shouldShowIDFAPopup_whenAppLaunchCountNotMatch_returnsFalse_andShouldNotCallNextHandler() {
        let (sut, mock) = makeSUT(didSearch: true, appLaunchCount: 5)

        XCTAssertFalse(sut.shouldShowIDFAPopup())
        XCTAssertEqual(mock.shouldShowIDFAPopupCallCount, 0)
    }

    func test_shouldShowIDFAPopup_persists() {
        let userDefaults = makeUserDefaults()
        let sut = makeSUT(didSearch: true, appLaunchCount: 3, userDefaults: userDefaults).sut

        XCTAssertTrue(sut.shouldShowIDFAPopup())

        let sut2 = makeSUT(didSearch: false, appLaunchCount: 6, userDefaults: userDefaults).sut

        XCTAssertTrue(sut2.shouldShowIDFAPopup())

        let sut3 = makeSUT(didSearch: false, userDefaults: userDefaults).sut

        XCTAssertFalse(sut3.shouldShowIDFAPopup())
    }

    // MARK: Helpers
    private func makeLaunch(_ sut: AppLaunchIDFAStorage, times: Int) {
        (0..<times).forEach { _ in sut.incrementAppLaunch() }
    }

    private func makeSUT(
        didSearch: Bool,
        appLaunchCount: Int = 0,
        userDefaults: UserDefaults? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: AppLaunchIDFAPresentationHandler, mock: IDFAPresentationServiceMock) {
        let userDefaults = userDefaults ?? makeUserDefaults()

        let storage = makeAppLaunchIDFAStorage(userDefaults: userDefaults)
        (0..<appLaunchCount).forEach { _ in storage.incrementAppLaunch() }

        let searchActionStorage = makeSearchUserActionStorage(userDefaults: userDefaults)
        if didSearch {
            searchActionStorage.didSearch()
        }

        let (sut, mock) = self.makeSUT(
            AppLaunchIDFAPresentationHandler(
                appLaunchStorage: storage,
                searchActionStorage: searchActionStorage,
                idfaPopupPresentationStorage: makeIDFAPopupPresentationStorage(userDefaults: userDefaults)
            ),
            file: file,
            line: line
        )

        return (sut, mock)
    }

    private func makeAppLaunchIDFAStorage(userDefaults: UserDefaults) -> AppLaunchIDFAStorage {
        return AppLaunchIDFAStorage(userDefaults: userDefaults)
    }

    private func makeSearchUserActionStorage(userDefaults: UserDefaults) -> SearchUserActionStorage {
        return SearchUserActionStorage(userDefaults: userDefaults)
    }

    private func makeIDFAPopupPresentationStorage(userDefaults: UserDefaults) -> IDFAPopupPresentationStorage {
        return IDFAPopupPresentationStorage(userDefaults: userDefaults)
    }
}
