@testable import AppTrackingKit

@available(iOS 14, *)
struct ATTrackingManagerStub {
    static var afterRequestState: ATTrackingManagerAuthorizationState = .denied
    static var currentAuthorizationState: ATTrackingManagerAuthorizationState = .notDetermined
}

@available(iOS 14, *)
extension ATTrackingManagerStub: ATTrackingManagerProtocol {
    static var trackingAuthorizationState: ATTrackingManagerAuthorizationState { return Self.currentAuthorizationState }
    static func requestTrackingAuthorization(
        completionHandler completion: @escaping (ATTrackingManagerAuthorizationState) -> Void
    ) {
        Self.currentAuthorizationState = Self.afterRequestState
        completion(Self.currentAuthorizationState)
    }
}
