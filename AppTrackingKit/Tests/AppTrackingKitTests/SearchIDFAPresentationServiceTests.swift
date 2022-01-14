import XCTest
@testable import AppTrackingKit

final class SearchIDFAPresentationServiceTests: IDFAPresentationServiceTestsCase {

    func test_shouldShowIDFAPopup_whenNonSearchWasMade_returnsFalse() {
        expect(withSearchCount: 0, shouldShow: false)
    }

    func test_shouldShowIDFAPopup_whenOneSearchWasMade_returnsTrue() {
        expect(withSearchCount: 1, shouldShow: true)
    }

    func test_shouldShowIDFAPopup_whenXSearchesWasMade_butDidNotUseShowIDFAPopup_returnsTrue() {
        expect(withSearchCount: 10, shouldShow: true)
    }

    func test_shouldShowIDFAPopup_whenDidShowIDFAPopup_nextTime_returnsFalse() {
        let sut = makeSUT(didSearchCount: 1)

        XCTAssertTrue(sut.shouldShowIDFAPopup(), "precondition")
        XCTAssertFalse(sut.shouldShowIDFAPopup())
    }

    func test_shouldShowIDFAPopup_persists() {
        let userDefaults = makeUserDefaults()
        let sut1 = makeSUT(didSearchCount: 1, userDefaults: userDefaults)

        XCTAssertTrue(sut1.shouldShowIDFAPopup(), "precondition")
        XCTAssertFalse(sut1.shouldShowIDFAPopup(), "precondition")

        let sut2 = makeSUT(userDefaults: userDefaults)

        XCTAssertFalse(sut2.shouldShowIDFAPopup())
    }

    // MARK: Private
    private func expect(
        withSearchCount searchCount: Int,
        shouldShow expectedValue: Bool,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let sut = makeSUT(didSearchCount: searchCount)

        XCTAssertEqual(
            sut.shouldShowIDFAPopup(),
            expectedValue,
            "Expected show: \(expectedValue)",
            file: file,
            line: line
        )
    }

    private func makeSUT(
        didSearchCount: Int? = nil,
        userDefaults: UserDefaults? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) -> SearchIDFAPresentationHandler  {
        let userDefaults = userDefaults ?? makeUserDefaults()
        let storage = SearchUserActionStorage(userDefaults: userDefaults)
        let idfaPopupPresentationStorage = IDFAPopupPresentationStorage(userDefaults: userDefaults)
        if let didSearchCount = didSearchCount {
            (0..<didSearchCount).forEach { _ in storage.didSearch() }
        }

        return self.makeSUT(
            SearchIDFAPresentationHandler(
                searchUserActionStorage: storage,
                idfaPopupPresentationStorage: idfaPopupPresentationStorage
            ),
            file: file,
            line: line
        ).sut
    }
}
