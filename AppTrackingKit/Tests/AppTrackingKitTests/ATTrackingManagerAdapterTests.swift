import XCTest
@testable import AppTrackingKit

@available(iOS 14, *)
final class ATTrackingManagerAdapterTests: XCTestCase {

    func test_requestTrackingAuthorization_whenIDFAPermission_isAuthorized_doNothing() {
        expect(when: .authorized, thenRequestAuthorization: 0, andOpenSettings: 0)
    }

    func test_requestTrackingAuthorization_whenIDFAPermission_isNotDetermined_requestsAuthorization() {
        expect(when: .notDetermined, thenRequestAuthorization: 1, andOpenSettings: 0)
    }

    func test_requestTrackingAuthorization_whenIDFAPermission_isDetermined_opensSettings() {
        expect(when: .denied, thenRequestAuthorization: 0, andOpenSettings: 1)
        expect(when: .restricted, thenRequestAuthorization: 0, andOpenSettings: 1)
    }

    func test_requestTrackingAuthorization_fromNotDetermined_toDenied_opensSettings() {
        ATTrackingManagerStub.afterRequestState = .denied
        expect(
            when: .notDetermined,
            firstRequest: {
                XCTAssertEqual($0.requestCallCount, 1, "precondition request authorization")
                XCTAssertEqual($0.openSettingsCallCount, 0, "precondition open settings")
            },
            secondRequest: {
                XCTAssertEqual($0.requestCallCount, 1, "request authorization")
                XCTAssertEqual($0.openSettingsCallCount, 1, "open settings")
            }
        )
    }

    func test_requestTrackingAuthorization_fromNotDetermined_toAuthorized_doNotOpenSettings() {
        ATTrackingManagerStub.afterRequestState = .authorized
        expect(
            when: .notDetermined,
            firstRequest: {
                XCTAssertEqual($0.requestCallCount, 1, "precondition request authorization")
                XCTAssertEqual($0.openSettingsCallCount, 0, "precondition open settings")
            },
            secondRequest: {
                XCTAssertEqual($0.requestCallCount, 1, "request authorization")
                XCTAssertEqual($0.openSettingsCallCount, 0, "open settings")
            }
        )
    }

    // MARK: Helpers
    typealias Result = ((requestCallCount: Int, openSettingsCallCount: Int)) -> Void

    private func expect(
        when idfaPermissionState: ATTrackingManagerAuthorizationState,
        thenRequestAuthorization expectedRequestAuthorization: Int,
        andOpenSettings expectedOpenSettings: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        expect(
            when: idfaPermissionState,
            firstRequest: {
                XCTAssertEqual(
                    $0.requestCallCount,
                    expectedRequestAuthorization,
                    "request authorization",
                    file: file,
                    line: line
                )
                XCTAssertEqual($0.openSettingsCallCount, expectedOpenSettings, "open settings", file: file, line: line)
            },
            secondRequest: nil
        )
    }

    private func expect(
        when idfaPermissionState: ATTrackingManagerAuthorizationState,
        firstRequest: Result,
        secondRequest: Result?
    ) {
        var requestCallCount = 0
        var openSettingsCallCount = 0
        let sut = makeSUT(idfaPermissionState: idfaPermissionState)

        func requestTrackingAuthorization() {
            sut.requestTrackingAuthorization(
                openSettings: { openSettingsCallCount += 1 },
                completionHandler: { _ in requestCallCount += 1 }
            )
        }

        requestTrackingAuthorization()

        firstRequest((requestCallCount, openSettingsCallCount))

        if let secondRequest = secondRequest {
            requestTrackingAuthorization()

            secondRequest((requestCallCount, openSettingsCallCount))
        }
    }

    private func makeSUT(
        idfaPermissionState: ATTrackingManagerAuthorizationState
    ) -> ATTrackingManagerAdapter {
        ATTrackingManagerStub.currentAuthorizationState = idfaPermissionState

        return ATTrackingManagerAdapter(trackingManager: ATTrackingManagerStub.self)
    }
}
