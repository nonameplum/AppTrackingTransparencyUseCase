import XCTest
@testable import AppTrackingKit

@available(iOS 14, *)
final class IDFAPresentationHandlerIntegrationTests: UserDefaultsTestsCase {

    func test_shouldShowIDFAPopup_whenIDFAPermissionGranted_returnsFalse() {
        let env = makeSUT()

        setAuthorizationState(.authorized)
        incrementAppLaunch(env.appLaunchIDFAStorage, by: 3)
        makeSearch(env.searchUserActionStorage)

        XCTAssertFalse(env.sut.shouldShowIDFAPopup())
    }

    func test_shouldShowIDFAPopup_whenIDFAPermissionNotGrantedInSystemSettings_returnsFalse() {
        let env = makeSUT()

        incrementAppLaunch(env.appLaunchIDFAStorage, by: 1)
        makeSearch(env.searchUserActionStorage)

        ATTrackingManagerStub.currentAuthorizationState = .denied

        XCTAssertFalse(env.sut.shouldShowIDFAPopup())
    }

    func test_shouldShowIDFAPopup_whenIDFAPermissionNotGranted_andLaunchCountMatches_andDidNotSearch_returnsFalse() {
        let env = makeSUT()
        incrementAppLaunch(env.appLaunchIDFAStorage, by: 3)

        XCTAssertFalse(env.sut.shouldShowIDFAPopup())
    }

    func test_shouldShowIDFAPopup_whenIDFAPermissionNotGranted_andLaunchCountMatches_andDidSearch_returnsFalse() {
        var env = makeSUT()
        setAuthorizationState(.notDetermined)
        incrementAppLaunch(env.appLaunchIDFAStorage, by: 3)
        makeSearch(env.searchUserActionStorage)

        XCTAssertTrue(env.sut.shouldShowIDFAPopup())

        env = makeSUT()
        setAuthorizationState(.authorized)
        incrementAppLaunch(env.appLaunchIDFAStorage, by: 9)
        makeSearch(env.searchUserActionStorage)

        XCTAssertFalse(env.sut.shouldShowIDFAPopup())
    }

    func test_shouldShowIDFAPopup_whenIDFAPermissionNotGranted_andDidSearch_returnsTrueOnceBecauseOfMadeSearch() {
        let env = makeSUT()
        setAuthorizationState(.notDetermined)
        incrementAppLaunch(env.appLaunchIDFAStorage, by: 1)

        XCTAssertFalse(env.sut.shouldShowIDFAPopup())

        makeSearch(env.searchUserActionStorage)

        XCTAssertTrue(env.sut.shouldShowIDFAPopup())
        XCTAssertFalse(env.sut.shouldShowIDFAPopup())
    }

    func test_shouldShowIDFAPopup_whenIDFAPermissionNotGranted_andLaunchCountMatches_shouldShowPopupOnlyOnAppLaunch() {
        let userDefaults = makeUserDefaults()
        var env = makeSUT(userDefaults: userDefaults)
        setAuthorizationState(.notDetermined)

        // 1st app launch
        incrementAppLaunch(env.appLaunchIDFAStorage, by: 1)

        XCTAssertFalse(env.sut.shouldShowIDFAPopup())

        // Makes search, kills the app (do not got the home screen)
        env.searchUserActionStorage.didSearch()
        // 2nd app launch
        env = makeSUT(userDefaults: userDefaults)
        incrementAppLaunch(env.appLaunchIDFAStorage, by: 1)

        XCTAssertFalse(env.sut.shouldShowIDFAPopup())

        // 3rd app launch
        env = makeSUT(userDefaults: userDefaults)
        incrementAppLaunch(env.appLaunchIDFAStorage, by: 1)

        XCTAssertTrue(env.sut.shouldShowIDFAPopup())
        XCTAssertFalse(env.sut.shouldShowIDFAPopup())
    }

    func test_shouldShowIDFAPopup_whenDidSearchOnSecondAppLaunch_returnTrueOnceOnThirdLaunch() {
        let userDefaults = makeUserDefaults()

        // 1st app launch
        var env = makeSUT(userDefaults: userDefaults)
        setAuthorizationState(.notDetermined)
        incrementAppLaunch(env.appLaunchIDFAStorage, by: 1)

        XCTAssertFalse(env.sut.shouldShowIDFAPopup())

        // 2nd app launch
        env = makeSUT(userDefaults: userDefaults)
        incrementAppLaunch(env.appLaunchIDFAStorage, by: 1)

        XCTAssertFalse(env.sut.shouldShowIDFAPopup())
        // the user makes the search
        makeSearch(env.searchUserActionStorage)
        // the user kills the app (do not got the home screen)

        // 3rd app launch
        env = makeSUT(userDefaults: userDefaults)
        incrementAppLaunch(env.appLaunchIDFAStorage, by: 1)

        XCTAssertTrue(env.sut.shouldShowIDFAPopup(), "Expect to show popup on 3rd app launch")
        XCTAssertFalse(env.sut.shouldShowIDFAPopup(), "Expect to not show popup again")
    }

    func test_shouldShowIDFAPopup_whenDidSearchOn9AppLaunch_returnTrueOn10AppLaunch() {
        let userDefaults = makeUserDefaults()
        var env = makeSUT(userDefaults: userDefaults)
        setAuthorizationState(.notDetermined)

        // 9 times app launch without search
        (0..<9).forEach { _ in
            env = makeSUT(userDefaults: userDefaults)
            incrementAppLaunch(env.appLaunchIDFAStorage, by: 1)
            XCTAssertFalse(env.sut.shouldShowIDFAPopup())
        }

        // 10th app launch
        env = makeSUT(userDefaults: userDefaults)
        incrementAppLaunch(env.appLaunchIDFAStorage, by: 1)

        XCTAssertFalse(env.sut.shouldShowIDFAPopup())

        // Makes the search search
        env.searchUserActionStorage.didSearch()

        XCTAssertTrue(env.sut.shouldShowIDFAPopup())
    }

    func test_shouldShowIDFAPopup_flow() {
        let userDefaults = makeUserDefaults()
        var env = makeSUT(userDefaults: userDefaults)
        setAuthorizationState(.notDetermined)
        incrementAppLaunch(env.appLaunchIDFAStorage, by: 1)

        XCTAssertFalse(env.sut.shouldShowIDFAPopup(), "Expect to now show popup on 1st app launch")

        makeSearch(env.searchUserActionStorage)

        XCTAssertTrue(env.sut.shouldShowIDFAPopup(), "Expect to show popup when the user did search")
        XCTAssertFalse(
            env.sut.shouldShowIDFAPopup(),
            "Expect to not show popup when the user already has seen it because of the search action"
        )

        env = makeSUT(userDefaults: userDefaults)
        incrementAppLaunch(env.appLaunchIDFAStorage, by: 1)

        XCTAssertFalse(env.sut.shouldShowIDFAPopup(), "Expect to not show popup on the 2nd app launch")

        env = makeSUT(userDefaults: userDefaults)
        incrementAppLaunch(env.appLaunchIDFAStorage, by: 1)

        XCTAssertTrue(env.sut.shouldShowIDFAPopup(), "Expect to show popup on 3rd app launch and did search")
        XCTAssertFalse(
            env.sut.shouldShowIDFAPopup(),
            "Expect to not show popup when the user already has seen it because of the given application launch"
        )
    }

    func test_requestTrackingAuthorization_whenDenied_shouldOpenSettings() {
        expectRequestTrackingAuthorization(whenAfterRequest: .denied, openedPopup: 2, openedSettings: 1)
    }

    func test_requestTrackingAuthorization_whenAuthorized_shouldNotShowPopupAgain() {
        expectRequestTrackingAuthorization(whenAfterRequest: .authorized, openedPopup: 1, openedSettings: 0)
    }

    func test_requestTrackingAuthorization_whenDenied_shouldDoNothing() {
        expectRequestTrackingAuthorization(withCurrentState: .denied, whenAfterRequest: .notDetermined, openedPopup: 0, openedSettings: 0)
    }

    // MARK: Helper
    private func expectRequestTrackingAuthorization(
        withCurrentState currentState: ATTrackingManagerAuthorizationState = .notDetermined,
        whenAfterRequest state: ATTrackingManagerAuthorizationState,
        openedPopup expectedOpenPopupCallCount: Int,
        openedSettings expectedOpenSettingsCallCount: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        var openPopupCallCount = 0
        var openSettingsCallCount = 0
        let userDefaults = makeUserDefaults()
        var env = self.makeSUT(userDefaults: userDefaults)
        setAuthorizationState(currentState)
        env.trackingManager.afterRequestState = state

        func requestTrackingAuthorization() {
            IDFAPresentationService.requestTrackingAuthorization(
                with: .init(
                    searchUserActionStorage: env.searchUserActionStorage,
                    appLaunchIDFAStorage: env.appLaunchIDFAStorage,
                    idfaPopupPresentationStorage: env.idfaPopupPresentationStorage,
                    permissionManager: env.trackingManager
                ),
                showPopup: { requestTrackingAuthorization in
                    openPopupCallCount += 1
                    requestTrackingAuthorization.run()
                },
                openSettings: {
                    openSettingsCallCount += 1
                },
                completionHandler: { _ in }
            )
        }

        // 1st app launch
        incrementAppLaunch(env.appLaunchIDFAStorage, by: 1)
        requestTrackingAuthorization()

        XCTAssertEqual(
            openPopupCallCount,
            0,
            "Precondition shouldn't show popup when 1st app launch",
            file: file,
            line: line
        )

        // Did search and go back to home
        makeSearch(env.searchUserActionStorage)
        requestTrackingAuthorization()

        XCTAssertEqual(
            openSettingsCallCount,
            0,
            "Expected to not open settings on 1st authorization call",
            file: file,
            line: line
        )

        // 2nd app launch
        env = self.makeSUT(userDefaults: userDefaults)
        incrementAppLaunch(env.appLaunchIDFAStorage, by: 1)
        requestTrackingAuthorization()

        // 3rd app launch
        env = self.makeSUT(userDefaults: userDefaults)
        incrementAppLaunch(env.appLaunchIDFAStorage, by: 1)
        requestTrackingAuthorization()

        XCTAssertEqual(openPopupCallCount, expectedOpenPopupCallCount, "Open popup", file: file, line: line)
        XCTAssertEqual(openSettingsCallCount, expectedOpenSettingsCallCount, "Open settings", file: file, line: line)
    }

    private func incrementAppLaunch(_ storage: AppLaunchIDFAStorage, by count: Int) {
        (0..<count).forEach { _ in storage.incrementAppLaunch() }
    }

    private func makeSearch(_ storage: SearchUserActionStorage) {
        storage.didSearch()
    }

    private func setAuthorizationState(_ state: ATTrackingManagerAuthorizationState) {
        ATTrackingManagerStub.currentAuthorizationState = state
    }

    private func makeSUT(
        userDefaults: UserDefaults? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: IDFAPresentationServiceProtocol,
        appLaunchIDFAStorage: AppLaunchIDFAStorage,
        searchUserActionStorage: SearchUserActionStorage,
        idfaPopupPresentationStorage: IDFAPopupPresentationStorage,
        trackingManager: ATTrackingManagerStub.Type
    ) {
        let userDefaults = userDefaults ?? makeUserDefaults()

        let searchUserActionStorage = SearchUserActionStorage(userDefaults: userDefaults)
        let appLaunchIDFAStorage = AppLaunchIDFAStorage(userDefaults: userDefaults)
        let idfaPopupPresentationStorage = IDFAPopupPresentationStorage(userDefaults: userDefaults)

        let sut = IDFAPresentationService.makeIDFAPresentationService(
            searchUserActionStorage: searchUserActionStorage,
            appLaunchIDFAStorage: appLaunchIDFAStorage,
            idfaPopupPresentationStorage: idfaPopupPresentationStorage,
            permissionManager: ATTrackingManagerStub.self
        )

        trackForMemoryLeaks(sut, file: file, line: line)

        return (
            sut, appLaunchIDFAStorage, searchUserActionStorage, idfaPopupPresentationStorage, ATTrackingManagerStub.self
        )
    }
}
