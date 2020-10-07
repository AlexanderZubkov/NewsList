import Foundation

struct Rss: Decodable {
    let channel: Channel

    struct Channel: Decodable {
        let item: [Item]
    }
}

struct Item: Decodable {
    let title: String
    let link: String
    let pubDate: String // Tue, 15 Sep 2020 15:12:15 PDT
}
