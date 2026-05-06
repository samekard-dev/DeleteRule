import SwiftUI
import SwiftData

// 共通でnameや関連名を取得するためのプロトコルを定義する
protocol NamedModel {
    var name: String { get }
    func relatedNames() -> [String]
}
