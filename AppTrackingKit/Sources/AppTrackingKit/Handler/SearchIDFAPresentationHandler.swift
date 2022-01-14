import Foundation

final class SearchIDFAPresentationHandler: IDFAPresentationHandlerProtocol {
    var nextHandler: IDFAPresentationHandlerProtocol?
    private let searchUserActionStorage: SearchUserActionStorage
    private let idfaPopupPresentationStorage: IDFAPopupPresentationStorage

    init(
        searchUserActionStorage: SearchUserActionStorage,
        idfaPopupPresentationStorage: IDFAPopupPresentationStorage
    ) {
        self.searchUserActionStorage = searchUserActionStorage
        self.idfaPopupPresentationStorage = idfaPopupPresentationStorage
    }

    func shouldShowIDFAPopup() -> Bool {
        if self.searchUserActionStorage.markedDidSearch && !self.idfaPopupPresentationStorage.presentedIDFAPopup {
            self.idfaPopupPresentationStorage.markIDFAPopupPresentation()
            return true
        }

        return false
    }
}
