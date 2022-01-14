import Foundation

@available(iOS 14, *)
public struct RequestTrackingAuthorization {
    public let run: () -> Void
}

@available(iOS 14, *)
public struct RequestTrackingAuthorizationDependencies {
    var searchUserActionStorage: SearchUserActionStorage
    var appLaunchIDFAStorage: AppLaunchIDFAStorage
    var idfaPopupPresentationStorage: IDFAPopupPresentationStorage
    var permissionManager: ATTrackingManagerProtocol.Type

    public init(
        searchUserActionStorage: SearchUserActionStorage,
        appLaunchIDFAStorage: AppLaunchIDFAStorage,
        idfaPopupPresentationStorage: IDFAPopupPresentationStorage,
        permissionManager: ATTrackingManagerProtocol.Type
    ) {
        self.searchUserActionStorage = searchUserActionStorage
        self.appLaunchIDFAStorage = appLaunchIDFAStorage
        self.idfaPopupPresentationStorage = idfaPopupPresentationStorage
        self.permissionManager = permissionManager
    }
}

@available(iOS 14, *)
public enum IDFAPresentationService {
    public static func requestTrackingAuthorization(
        with dependencies: RequestTrackingAuthorizationDependencies,
        showPopup: (RequestTrackingAuthorization) -> Void,
        openSettings: @escaping () -> Void,
        completionHandler: @escaping (ATTrackingManagerAuthorizationState) -> Void
    ) {
        let service = IDFAPresentationService.makeIDFAPresentationService(
            searchUserActionStorage: dependencies.searchUserActionStorage,
            appLaunchIDFAStorage: dependencies.appLaunchIDFAStorage,
            idfaPopupPresentationStorage: dependencies.idfaPopupPresentationStorage,
            permissionManager: dependencies.permissionManager
        )

        let trackingManagerAdapter = ATTrackingManagerAdapter(trackingManager: dependencies.permissionManager)

        if service.shouldShowIDFAPopup() {
            showPopup(
                RequestTrackingAuthorization(run: {
                    trackingManagerAdapter.requestTrackingAuthorization(
                        openSettings: openSettings,
                        completionHandler: completionHandler
                    )
                })
            )
        }
    }

    static func makeIDFAPresentationService(
        searchUserActionStorage: SearchUserActionStorage,
        appLaunchIDFAStorage: AppLaunchIDFAStorage,
        idfaPopupPresentationStorage: IDFAPopupPresentationStorage,
        permissionManager: ATTrackingManagerProtocol.Type
    ) -> IDFAPresentationServiceProtocol {
        let searchIDFAPresentationHandler = SearchIDFAPresentationHandler(
            searchUserActionStorage: searchUserActionStorage,
            idfaPopupPresentationStorage: idfaPopupPresentationStorage
        )
        let appLaunchIDFAPresentationHandler = AppLaunchIDFAPresentationHandler(
            appLaunchStorage: appLaunchIDFAStorage,
            searchActionStorage: searchUserActionStorage,
            idfaPopupPresentationStorage: idfaPopupPresentationStorage
        )

        let permissionIDFAPresentationHandler = PermissionIDFAPresentationHandler(
            trackingAuthorizationState: { permissionManager.trackingAuthorizationState },
            idfaPopupPresentationStorage: idfaPopupPresentationStorage
        )

        permissionIDFAPresentationHandler
            .setNext(handler: appLaunchIDFAPresentationHandler)
            .setNext(handler: searchIDFAPresentationHandler)

        return permissionIDFAPresentationHandler
    }
}
