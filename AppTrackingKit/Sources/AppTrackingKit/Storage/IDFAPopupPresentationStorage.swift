import Foundation

public struct IDFAPopupPresentationStorage {
    private enum Constants {
        static let presentedKey = "IDFAPopupPresentationStorage_presentedIDFAPopup"
    }

    private let userDefaults: UserDefaults

    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    public var presentedIDFAPopup: Bool {
        return self.userDefaults.bool(forKey: Constants.presentedKey)
    }

    func markIDFAPopupPresentation() {
        self.userDefaults.set(true, forKey: Constants.presentedKey)
    }
}
