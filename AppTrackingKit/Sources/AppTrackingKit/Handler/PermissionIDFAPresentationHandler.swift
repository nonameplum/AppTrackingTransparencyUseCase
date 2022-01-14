import Foundation

@available(iOS 14, *)
final class PermissionIDFAPresentationHandler: IDFAPresentationHandlerProtocol {
    var nextHandler: IDFAPresentationHandlerProtocol?
    private let trackingAuthorizationState: () -> ATTrackingManagerAuthorizationState
    private let idfaPopupPresentationStorage: IDFAPopupPresentationStorage

    init(
        trackingAuthorizationState: @escaping () -> ATTrackingManagerAuthorizationState,
        idfaPopupPresentationStorage: IDFAPopupPresentationStorage
    ) {
        self.trackingAuthorizationState = trackingAuthorizationState
        self.idfaPopupPresentationStorage = idfaPopupPresentationStorage
    }

    func shouldShowIDFAPopup() -> Bool {
        if self.trackingAuthorizationState() == .authorized {
            return false
        }

        if self.trackingAuthorizationState() == .denied &&
            !self.idfaPopupPresentationStorage.presentedIDFAPopup {
            return false
        }

        return self.nextHandler?.shouldShowIDFAPopup() ?? false
    }
}
