import Foundation

final class AppLaunchIDFAPresentationHandler: IDFAPresentationHandlerProtocol {
    private enum Constants {
        static let allowedAppLaunchCounts: [Int] = [3, 9]
    }

    var nextHandler: IDFAPresentationHandlerProtocol?
    private var didShowAlertAfterAppLaunch: [Int: Bool] = [:]
    private let appLaunchStorage: AppLaunchIDFAStorage
    private let searchActionStorage: SearchUserActionStorage
    private let idfaPopupPresentationStorage: IDFAPopupPresentationStorage

    init(
        appLaunchStorage: AppLaunchIDFAStorage,
        searchActionStorage: SearchUserActionStorage,
        idfaPopupPresentationStorage: IDFAPopupPresentationStorage
    ) {
        self.appLaunchStorage = appLaunchStorage
        self.searchActionStorage = searchActionStorage
        self.idfaPopupPresentationStorage = idfaPopupPresentationStorage
    }

    func shouldShowIDFAPopup() -> Bool {
        defer { self.appLaunchStorage.markAsUsedCurrentAppLaunchCount() }

        guard self.searchActionStorage.markedDidSearch
        else { return false }

        if !self.appLaunchStorage.isCurrentAppLaunchCountMarked() {
            if Constants.allowedAppLaunchCounts.contains(self.appLaunchStorage.appLaunchCount) {
                if self.searchActionStorage.markedDidSearch
                    && !self.idfaPopupPresentationStorage.presentedIDFAPopup
                {
                    self.idfaPopupPresentationStorage.markIDFAPopupPresentation()
                }
                return true
            } else {
                return false
            }
        }

        return self.nextHandler?.shouldShowIDFAPopup() ?? false
    }
}
