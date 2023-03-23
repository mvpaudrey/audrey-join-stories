import Foundation

extension String {

    static let empty = ""

}

extension Optional where Wrapped == String {

    var orEmpty: String {
        self ?? .empty
    }
}
