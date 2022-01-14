import XCTest
@testable import AppTrackingKit

final class IDFAPopupPresentationStorageTests: UserDefaultsTestsCase {

    func test_presentedIDFAPopup_whenNotMarked_returnsFalse() {
        let sut = makeSUT()

        XCTAssertFalse(sut.presentedIDFAPopup)
    }

    func test_presentedIDFAPopup_whenDidMarkPresentation_returnsTrue() {
        let sut = makeSUT()

        sut.markIDFAPopupPresentation()

        XCTAssertTrue(sut.presentedIDFAPopup)
    }

    //MARK: Helpers
    func makeSUT() -> IDFAPopupPresentationStorage {
        return IDFAPopupPresentationStorage(userDefaults: makeUserDefaults())
    }
}
