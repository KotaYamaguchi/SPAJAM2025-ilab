import Foundation


struct Star: Identifiable, Decodable , Hashable{
    // Identifiableに準拠させるため、ユニークなIDプロパティを用意します。
    // この場合、星の名前(name)がユニークであると仮定します。
    var id: String { name }

    let name: String
    let ra: String
    let dec: String
    let vmag: Double
    var collectStar : Bool = false

    // CSVのヘッダーとプロパティ名をマッピングします。
    private enum CodingKeys: String, CodingKey {
        case name
        case ra
        case dec
        case vmag
    }
}



// ユーザーがタップして追加した星の情報を保持する構造体
struct UserStar: Identifiable {
    let id = UUID()
    let name: String
    let azimuth: Double  // 作成された時点の方位角
    let altitude: Double // 作成された時点の高度
}
