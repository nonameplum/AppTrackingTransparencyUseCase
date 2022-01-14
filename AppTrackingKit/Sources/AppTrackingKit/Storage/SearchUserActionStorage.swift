import Foundation

public struct SearchUserActionStorage {
    private enum Constants {
        static let didSearchKey = "SearchUserActionStorage_didSearch"
    }

    private let userDefaults: UserDefaults

    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    public var markedDidSearch: Bool {
        self.userDefaults.bool(forKey: Constants.didSearchKey)
    }

    public func didSearch() {
        self.userDefaults.set(true, forKey: Constants.didSearchKey)
    }
}
