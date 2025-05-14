//
//  Levenshtein.swift
//  Fuzzywuzzy_swift
//
//  Created by XianLi on 14/05/2025.
//  Copyright © 2025 T-Pro. All rights reserved.
//

final class Levenshtein {

  static func distance(lhs: String, rhs: String) -> Int {

    if lhs.isEmpty {
      return rhs.count
    }

    if rhs.isEmpty {
      return lhs.count
    }

    // Swap similar to what can be found on the Python implementation:
    // https://github.com/rapidfuzz/Levenshtein/blob/3f481172158fbd8dd60bdabffa402a79d3f10901/src/Levenshtein/Levenshtein-c/_levenshtein.hpp#L655
    if lhs.count < rhs.count {
      return distance(lhs: rhs, rhs: lhs)
    }

    let lhsChars: [Character] = Array(lhs)
    let rhsChars: [Character] = Array(rhs)

    let lhsCount: Int = lhsChars.count
    let rhsCount: Int = rhsChars.count

    var previousRow: [Int] = Array(0...rhsCount)
    var currentRow: [Int] = Array(repeating: 0, count: rhsCount + 1)

    for lhsIndex in 1...lhsCount {
      currentRow[0] = lhsIndex
      for rhsIndex in 1...rhsCount {
        let cost: Int = lhsChars[lhsIndex - 1] == rhsChars[rhsIndex - 1] ? 0 : 1
        currentRow[rhsIndex] = min(
          currentRow[rhsIndex - 1] + 1,
          previousRow[rhsIndex] + 1,
          previousRow[rhsIndex - 1] + cost
        )
      }
      previousRow = currentRow
    }

    return currentRow[rhsCount]
  }

  // Canonical implementation
//  class func distance(lhs: String, rhs: String) -> Int {
//    let lhsArray = Array(lhs)
//    let rhsArray = Array(rhs)
//    let m = lhsArray.count
//    let n = rhsArray.count
//
//    if m == 0 { return n }
//    if n == 0 { return m }
//
//    var dp = Array(repeating: Array(repeating: 0, count: n + 1), count: m + 1)
//
//    for i in 0...m { dp[i][0] = i }
//    for j in 0...n { dp[0][j] = j }
//
//    for i in 1...m {
//      for j in 1...n {
//        if lhsArray[i - 1] == rhsArray[j - 1] {
//          dp[i][j] = dp[i - 1][j - 1]
//        } else {
//          dp[i][j] = min(
//            dp[i - 1][j] + 1,    // deletion
//            dp[i][j - 1] + 1,    // insertion
//            dp[i - 1][j - 1] + 1 // substitution
//          )
//        }
//      }
//    }
//    return dp[m][n]
//  }

}
