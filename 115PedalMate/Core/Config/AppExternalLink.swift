//
//  AppExternalLink.swift
//  115PedalMate
//

import Foundation

enum AppExternalLink: String {
    case privacyPolicy = "https://www.termsfeed.com/live/c8b602aa-0b66-4d5a-b7e3-ebdd52a7972d"
    case termsOfUse = "https://www.termsfeed.com/live/ae87d558-5c60-4670-9819-e37da8af15e8"

    var url: URL? {
        URL(string: rawValue)
    }
}
