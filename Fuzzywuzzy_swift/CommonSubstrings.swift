//
//  CommonSubstrings.swift
//  Fuzzywuzzy_swift
//
//  Created by XianLi on 30/8/2016.
//  Copyright © 2016 LiXian. All rights reserved.
//

import Foundation

struct CommonSubstringPair {
  let lhsSubRange: Range<String.Index>
  let rhsSubRange: Range<String.Index>
  let len: Int
}

class CommonSubstrings: NSObject {
  /// get all pairs of common substrings
  class func pairs(lhs: String, rhs: String) -> [CommonSubstringPair] {
    /// convert String to array of Characters
    let lhsCharArray: [Character] = Array(lhs)
    let rhsCharArray: [Character] = Array(rhs)

    if lhsCharArray.isEmpty || rhsCharArray.isEmpty {
      return []
    }

    /// create the matching matrix
    var matchingMatrix: [[Int]] = Array(
      repeating: Array(
        repeating: 0,
        count: rhsCharArray.count + 1
      ),
      count: lhsCharArray.count + 1
    )

    for lhsIndex in 1...lhsCharArray.count {
      for rhsIndex in 1...rhsCharArray.count {
        let similarChar: Bool = lhsCharArray[lhsIndex-1] == rhsCharArray[rhsIndex-1]
        matchingMatrix[lhsIndex][rhsIndex] = similarChar
          ? matchingMatrix[lhsIndex-1][rhsIndex-1] + 1
          : 0
      }
    }

    var pairs: [CommonSubstringPair] = []
    for lhsIndex in 1...lhsCharArray.count {
      for rhsIndex in 1...rhsCharArray.count
      where matchingMatrix[lhsIndex][rhsIndex] == 1 {
        var len: Int = 1
        while (lhsIndex+len) < (lhsCharArray.count + 1)
                && (rhsIndex + len) < (rhsCharArray.count + 1)
                && matchingMatrix[lhsIndex+len][rhsIndex+len] != 0 {
          len += 1
        }
        let lhsSubRange: Range<String.Index> = substringRange(lhs, lhsIndex-1, len)
        let rhsSubRange: Range<String.Index> = substringRange(rhs, rhsIndex-1, len)
        pairs.append(
          CommonSubstringPair(
            lhsSubRange: lhsSubRange,
            rhsSubRange: rhsSubRange,
            len: len)
          )
      }
    }
    return pairs
  }
}

private func substringRange(
  _ str: String,
  _ start: Int,
  _ len: Int
) -> Range<String.Index> {
  let lower: String.Index = str.index(str.startIndex, offsetBy: start)
  let upper: String.Index = str.index(str.startIndex, offsetBy: start + len - 1)
  return lower..<upper
}
