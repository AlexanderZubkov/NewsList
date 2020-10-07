//
//  Constants.swift
//  NewsList
//
//  Created by Alexander Zubkov on 06.10.2020.
//

import Foundation

enum Constants {

    enum URL: String {
        case reddit = "https://www.reddit.com/r/iOSProgramming/.rss"
        case apple = "https://developer.apple.com/news/rss/news.rss"
    }

    static let modelName = "Articles"
    static let errorMessage = "Something went wrong. Please try again later."

    enum Main {
        static let pullToRefresh = "Pull to refresh"
    }
}
