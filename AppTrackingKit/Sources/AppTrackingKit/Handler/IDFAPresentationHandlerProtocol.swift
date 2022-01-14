import Foundation

public protocol IDFAPresentationServiceProtocol: AnyObject {
    func shouldShowIDFAPopup() -> Bool
}
protocol IDFAPresentationHandlerProtocol: IDFAPresentationServiceProtocol {
    @discardableResult
    func setNext(handler: IDFAPresentationHandlerProtocol) -> IDFAPresentationHandlerProtocol
    var nextHandler: IDFAPresentationHandlerProtocol? { get set }
}
extension IDFAPresentationHandlerProtocol {
    func setNext(handler: IDFAPresentationHandlerProtocol) -> IDFAPresentationHandlerProtocol {
        self.nextHandler = handler
        return handler
    }
    func shouldShowIDFAPopup() -> Bool {
        return nextHandler?.shouldShowIDFAPopup() ?? false
    }
}
