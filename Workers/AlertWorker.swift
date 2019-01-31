import UIKit

protocol Dialog {
    func present<T: CaseReturnable>(actions: T.Type, completion: ((T.TypeReturnable) -> Void)?)
}

protocol CaseReturnable {
    associatedtype TypeReturnable
    static func getCasesRaw() -> [String]
    static func getCase(rawValue value: String) -> TypeReturnable
}

enum UploadImage: String, CaseIterable, CaseReturnable {
    typealias TypeReturnable = UploadImage
    
    case gallery = "Gallery"
    case camera = "Camera"
    
    static func getCasesRaw() -> [String] {
        return UploadImage.allCases.map({ $0.rawValue })
    }
    
    static func getCase(rawValue value: String) -> UploadImage {
        return TypeReturnable.init(rawValue: value)!
    }
}

enum WarningAction: String, CaseIterable, CaseReturnable {
    typealias TypeReturnable = WarningAction
    
    case ok = "Ок"
    
    static func getCasesRaw() -> [String] {
        return WarningAction.allCases.map({ $0.rawValue })
    }
    
    static func getCase(rawValue value: String) -> WarningAction {
        return WarningAction.init(rawValue: value)!
    }
}


class AlertWorker: Dialog {
    
    private var style           : UIAlertController.Style
    private var title           : String?
    private var message         : String?
    private var fromVC          : UIViewController
    private var titles          : [String] = []
    private var actions         : [UIAlertAction] = []
    
    init(style: UIAlertController.Style, title: String?, message: String?, fromVC: UIViewController) {
        self.style = style
        self.title = title
        self.message = message
        self.fromVC = fromVC
    }
    
    func present<T: CaseReturnable>(actions: T.Type, completion: ((T.TypeReturnable) -> Void)?) {
        let alert = UIAlertController(title: title, message:
            message, preferredStyle: style)
        
        actions.getCasesRaw().forEach {
            let action = UIAlertAction(title: $0, style: .default, handler: { action in
                let selectedCase = actions.getCase(rawValue: action.title!)
                completion!(selectedCase)
            })
            alert.addAction(action)
        }
        
        if style == .actionSheet {
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        }
        
        fromVC.present(alert, animated: true, completion: nil)
    }
}
