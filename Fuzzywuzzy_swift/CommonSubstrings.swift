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
    let charArr1: [Character] = Array(lhs)
    let charArr2: [Character] = Array(rhs)

    if charArr1.isEmpty || charArr2.isEmpty {
      return []
    }

    /// create the matching matrix
    var matchingMatrix: [[Int]] = Array(
      repeating: Array(
        repeating: 0,
        count: charArr2.count + 1
      ),
      count: charArr1.count + 1
    )

    for i in 1...charArr1.count {
      for j in 1...charArr2.count {
        if charArr1[i-1] == charArr2[j-1] {
          matchingMatrix[i][j] = matchingMatrix[i-1][j-1] + 1
        } else {
          matchingMatrix[i][j] = 0
        }
      }
    }

    var pairs: [CommonSubstringPair] = []
    for i in 1...charArr1.count {
      for j in 1...charArr2.count where matchingMatrix[i][j] == 1 {
        var len: Int = 1
        while (i+len) < (charArr1.count + 1)
                && (j + len) < (charArr2.count + 1)
                && matchingMatrix[i+len][j+len] != 0 {
          len += 1
        }
        let sub1Range: Range<String.Index> = (lhs.index(lhs.startIndex, offsetBy: i-1))..<lhs.index(lhs.startIndex, offsetBy: i-1+len-1)
        let sub2Range: Range<String.Index> = (rhs.index(rhs.startIndex, offsetBy: j-1))..<rhs.index(rhs.startIndex, offsetBy: j-1+len-1)
        pairs.append(CommonSubstringPair(lhsSubRange: sub1Range, rhsSubRange: sub2Range, len: len))
      }
    }
    return pairs
  }
}
