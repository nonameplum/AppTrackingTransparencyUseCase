import XCTest
@testable import AppTrackingKit

@available(iOS 14, *)
final class PermissionIDFAPresentationServiceTests: IDFAPresentationServiceTestsCase {

    func test_shouldShowIDFAPopup_whenIDFAPermission_isGranted_returnsFalse() {
        let (sut, mock) = makeSUT(trackingAuthorizationState: .authorized)

        XCTAssertFalse(sut.shouldShowIDFAPopup())
        XCTAssertEqual(mock.shouldShowIDFAPopupCallCount, 0)
    }

    func test_shouldShowIDFAPopup_whenIDFAPermission_isNotGranted_returnsNextHandlerValue() {
        expectNextHandlerValue(when: .notDetermined)
    }

    // MARK: Private
    private func expectNextHandlerValue(
        when trackingAuthorizationState: ATTrackingManagerAuthorizationState,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let (sut, mock) = makeSUT(trackingAuthorizationState: trackingAuthorizationState)

        XCTAssertEqual(mock.shouldShowIDFAPopupCallCount, 0, "precondition")

        mock.result = true

        XCTAssertTrue(sut.shouldShowIDFAPopup(), file: file, line: line)

        mock.result = false

        XCTAssertFalse(sut.shouldShowIDFAPopup(), file: file, line: line)
    }

    private func makeSUT(
        trackingAuthorizationState: ATTrackingManagerAuthorizationState,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: PermissionIDFAPresentationHandler, mock: IDFAPresentationServiceMock) {
        return self.makeSUT(
            PermissionIDFAPresentationHandler(
                trackingAuthorizationState: { trackingAuthorizationState },
                idfaPopupPresentationStorage: IDFAPopupPresentationStorage(userDefaults: makeUserDefaults())
            ),
            file: file,
            line: line
        )
    }
}
