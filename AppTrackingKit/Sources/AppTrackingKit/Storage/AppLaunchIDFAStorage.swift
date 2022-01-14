import Foundation

public struct AppLaunchIDFAStorage {
    // MARK: Types
    private enum Constants {
        static let appLaunchIDFAStorageKey = "appLaunchIDFAStorageKey"
    }

    private struct Model: Codable {
        var appLaunchCount: Int
        var markedAppLaunchCount: [Int]
    }

    // MARK: Properties
    private let userDefaults: UserDefaults

    // MARK: Initialization
    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    // MARK: Store
    public var appLaunchCount: Int {
        return self.load().appLaunchCount
    }

    public func incrementAppLaunch() {
        var model = self.load()
        model.appLaunchCount += 1
        self.save(model)
    }

    func markAsUsedCurrentAppLaunchCount() {
        var model = self.load()
        model.markedAppLaunchCount.append(model.appLaunchCount)
        self.save(model)
    }

    func isCurrentAppLaunchCountMarked() -> Bool {
        let model = self.load()
        return model.markedAppLaunchCount.contains(model.appLaunchCount)
    }

    // MARK: Helpers
    private func load() -> Model {
        if let savedModel = self.userDefaults.object(forKey: Constants.appLaunchIDFAStorageKey) as? Data,
           let decodedModel = try? JSONDecoder().decode(Model.self, from: savedModel) {
            return decodedModel
        }

        return Model(appLaunchCount: 0, markedAppLaunchCount: [])
    }

    private func save(_ model: Model) {
        guard let encoded = try? JSONEncoder().encode(model)
        else { return }

        self.userDefaults.set(encoded, forKey: Constants.appLaunchIDFAStorageKey)
    }
}
