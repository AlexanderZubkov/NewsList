import Foundation
import XMLCoder

struct Feed: Decodable {
    var entry: [Entry]
}

struct Entry: Decodable {
    var title: String
    var link: Link
    var updated: String // 2020-09-14T20:04:37+00:00

    struct Link: Decodable, DynamicNodeDecoding {
        var href: String
        var value = ""

        enum CodingKeys: String, CodingKey {
            case href
            case value = ""
        }

        static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
            switch key {
            case Link.CodingKeys.href:
                return .attribute
            default:
                return .element
            }
        }
    }

//    static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
//        switch key {
//        case Entry.CodingKeys.link:
//            return .attribute
//        default:
//            return .element
//        }
//    }

//    enum CodingKeys: String, CodingKey {
//        case title
//        case link = "href"
//        case updated
//    }
}
