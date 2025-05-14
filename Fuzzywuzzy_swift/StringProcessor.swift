//
//  StringProcessor.swift
//  Fuzzywuzzy_swift
//
//  Created by XianLi on 31/8/2016.
//  Copyright © 2016 LiXian. All rights reserved.
//

import Foundation

private let REGEX = "\\W+"

// swiftlint:disable force_try
@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, visionOS 1.0, *)
private let cachedRegex: Regex = {
  try! Regex(REGEX).ignoresCase()
}()

private let cachedNSRegularExpression: NSRegularExpression = {
  try! NSRegularExpression(pattern: REGEX, options: .caseInsensitive)
}()
// swiftlint:enable force_try

class StringProcessor {

  /// Process string by
  /// removing all but letters and numbers
  /// trim whitespace
  /// force to lower case
  class func process(value: String, forceAscii: Bool = true) -> String {
    if value.isEmpty {
        return value
    }
    let processed: String = forceAscii ? asciidammit(value) : value
    let lowercased: String = processed.lowercased()
    let replaced: String
    if #available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, visionOS 1.0, *) {
      replaced = lowercased.replacing(cachedRegex, with: " ")
    } else {
      replaced = cachedNSRegularExpression.stringByReplacingMatches(
        in: lowercased,
        options: [],
        range: NSRange(location: 0, length: lowercased.utf16.count),
        withTemplate: " "
      )
    }
    return replaced.trimmingCharacters(in: CharacterSet(charactersIn: " "))
  }
}


/// Converts a string to ASCII-only by removing or replacing non-ASCII characters.
/// If the string is already ASCII, returns it as-is.
/// Otherwise, attempts to transliterate or remove non-ASCII characters.
private func asciidammit(_ value: String) -> String {
  // If string is already ASCII, return as is
  if value.canBeConverted(to: .ascii) {
    if let asciiData = value.data(using: .ascii) {
      return String(data: asciiData, encoding: .ascii) ?? value
    }
    return value
  }
  // Try to transliterate to ASCII (removes accents, etc.)
  let mutable = NSMutableString(string: value) as CFMutableString
  CFStringTransform(mutable, nil, kCFStringTransformToLatin, false)
  CFStringTransform(mutable, nil, kCFStringTransformStripCombiningMarks, false)
  let asciiString = mutable as String
  // Remove any remaining non-ASCII characters
  let filtered = asciiString.unicodeScalars.filter { $0.isASCII }
  return String(String.UnicodeScalarView(filtered))
}
