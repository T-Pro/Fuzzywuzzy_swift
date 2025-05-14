//
//  LevenshteinTest.swift
//  Fuzzywuzzy_swift
//
//  Created by Pedro Paulo de Amorim on 13/05/2025.
//

import XCTest
@testable import Fuzzywuzzy_swift

class LevenshteinTest: XCTestCase {

  func testLevenshtein_basicCases() {
    // Identical strings
    XCTAssertEqual(Levenshtein.distance(lhs: "some", rhs: "some"), 0)
    XCTAssertEqual(Levenshtein.distance(lhs: "", rhs: ""), 0)
    XCTAssertEqual(Levenshtein.distance(lhs: "a", rhs: "a"), 0)
    XCTAssertEqual(Levenshtein.distance(lhs: "abc", rhs: "abc"), 0)
    XCTAssertEqual(Levenshtein.distance(lhs: "cat dog", rhs: "dog mouse"), 7)
    XCTAssertEqual(Levenshtein.distance(lhs: "dog mouse", rhs: "cat dog"), 7)

  }

  func testLevenshtein_emptyStrings() {
    // One empty, one non-empty
    XCTAssertEqual(Levenshtein.distance(lhs: "", rhs: "some"), 4)
    XCTAssertEqual(Levenshtein.distance(lhs: "some", rhs: ""), 4)
    XCTAssertEqual(Levenshtein.distance(lhs: "", rhs: "a"), 1)
    XCTAssertEqual(Levenshtein.distance(lhs: "a", rhs: ""), 1)
    XCTAssertEqual(Levenshtein.distance(lhs: "", rhs: ""), 0)
  }

  func testLevenshtein_insertionsDeletions() {
    // Insertions
    XCTAssertEqual(Levenshtein.distance(lhs: "abc", rhs: "ab"), 1)
    XCTAssertEqual(Levenshtein.distance(lhs: "ab", rhs: "abc"), 1)
    XCTAssertEqual(Levenshtein.distance(lhs: "a", rhs: "abc"), 2)
    XCTAssertEqual(Levenshtein.distance(lhs: "abc", rhs: "a"), 2)
    // Deletions
    XCTAssertEqual(Levenshtein.distance(lhs: "kitten", rhs: "kitt"), 2)
    XCTAssertEqual(Levenshtein.distance(lhs: "kitt", rhs: "kitten"), 2)
  }

  func testLevenshtein_substitutions() {
    // Substitutions
    XCTAssertEqual(Levenshtein.distance(lhs: "kitten", rhs: "sitten"), 1)
    XCTAssertEqual(Levenshtein.distance(lhs: "kitten", rhs: "sittin"), 2)
    XCTAssertEqual(Levenshtein.distance(lhs: "flaw", rhs: "lawn"), 2)
    XCTAssertEqual(Levenshtein.distance(lhs: "gumbo", rhs: "gambol"), 2)
    XCTAssertEqual(Levenshtein.distance(lhs: "book", rhs: "back"), 2)
  }

  func testLevenshtein_mixedOperations() {
    // Mix of insertions, deletions, substitutions
    XCTAssertEqual(Levenshtein.distance(lhs: "intention", rhs: "execution"), 5)
    XCTAssertEqual(Levenshtein.distance(lhs: "abcdef", rhs: "azced"), 3)
    XCTAssertEqual(Levenshtein.distance(lhs: "Saturday", rhs: "Sunday"), 3)
    XCTAssertEqual(Levenshtein.distance(lhs: "distance", rhs: "editing"), 5)
  }

  func testLevenshtein_unicode() {
    // Unicode and emoji
    XCTAssertEqual(Levenshtein.distance(lhs: "我something", rhs: "someth"), 4)
    XCTAssertEqual(Levenshtein.distance(lhs: "我好饿啊啊啊啊", rhs: "好烦啊"), 5)
    XCTAssertEqual(Levenshtein.distance(lhs: "🐱", rhs: "🐶"), 1)
    XCTAssertEqual(Levenshtein.distance(lhs: "🐱🐶", rhs: "🐱"), 1)
    XCTAssertEqual(Levenshtein.distance(lhs: "🐱🐶", rhs: "🐶🐱"), 2)
    XCTAssertEqual(Levenshtein.distance(lhs: "你好", rhs: "您好"), 1)
    XCTAssertEqual(Levenshtein.distance(lhs: "你好世界", rhs: "世界你好"), 4)
  }

  func testLevenshtein_longStrings() {
    let lhs: String = String(repeating: "a", count: 100)
    let rhs: String = String(repeating: "a", count: 100)
    XCTAssertEqual(Levenshtein.distance(lhs: lhs, rhs: rhs), 0)

    let str3: String = String(repeating: "a", count: 100)
    let str4: String = String(repeating: "b", count: 100)
    XCTAssertEqual(Levenshtein.distance(lhs: str3, rhs: str4), 100)

    let str5: String = String(repeating: "a", count: 50) + String(repeating: "b", count: 50)
    let str6: String = String(repeating: "a", count: 100)
    XCTAssertEqual(Levenshtein.distance(lhs: str5, rhs: str6), 50)
  }

  func testLevenshtein_edgeCases() {
    // Single character
    XCTAssertEqual(Levenshtein.distance(lhs: "a", rhs: "b"), 1)
    XCTAssertEqual(Levenshtein.distance(lhs: "a", rhs: ""), 1)
    XCTAssertEqual(Levenshtein.distance(lhs: "", rhs: "a"), 1)

    // Completely different
    XCTAssertEqual(Levenshtein.distance(lhs: "abc", rhs: "xyz"), 3)
    XCTAssertEqual(Levenshtein.distance(lhs: "123", rhs: "abc"), 3)

    // Case sensitivity
    XCTAssertEqual(Levenshtein.distance(lhs: "abc", rhs: "ABC"), 3)
    XCTAssertEqual(Levenshtein.distance(lhs: "Abc", rhs: "abc"), 1)
  }

  func testLevenshtein_originalCases() {
    // Original test cases from previous version
    XCTAssertEqual(Levenshtein.distance(lhs: "something", rhs: "some"), 5)
    XCTAssertEqual(Levenshtein.distance(lhs: "something", rhs: "omethi"), 3)
    XCTAssertEqual(Levenshtein.distance(lhs: "something", rhs: "same"), 6)
    XCTAssertEqual(Levenshtein.distance(lhs: "something", rhs: "samewrongthong"), 7)
    XCTAssertEqual(Levenshtein.distance(lhs: "something", rhs: ""), 9)
    XCTAssertEqual(Levenshtein.distance(lhs: "", rhs: "some"), 4)
    XCTAssertEqual(Levenshtein.distance(lhs: "some", rhs: "some"), 0)
    XCTAssertEqual(Levenshtein.distance(lhs: "", rhs: ""), 0)
    XCTAssertEqual(Levenshtein.distance(lhs: "我something", rhs: "someth"), 4)
    XCTAssertEqual(Levenshtein.distance(lhs: "我好饿啊啊啊啊", rhs: "好烦啊"), 5)
  }
  
}
