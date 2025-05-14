//
//  LevenshteinDistanceTest.swift
//  Fuzzywuzzy_swift
//
//  Created by Pedro Paulo de Amorim on 13/05/2025.
//

import XCTest
@testable import Fuzzywuzzy_swift

class LevenshteinDistanceTest: XCTestCase {

  func testLevenshteinDistance_basicCases() {
    // Identical strings
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "some", rhs: "some"), 0)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "", rhs: ""), 0)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "a", rhs: "a"), 0)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "abc", rhs: "abc"), 0)
  }

  func testLevenshteinDistance_emptyStrings() {
    // One empty, one non-empty
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "", rhs: "some"), 4)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "some", rhs: ""), 4)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "", rhs: "a"), 1)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "a", rhs: ""), 1)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "", rhs: ""), 0)
  }

  func testLevenshteinDistance_insertionsDeletions() {
    // Insertions
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "abc", rhs: "ab"), 1)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "ab", rhs: "abc"), 1)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "a", rhs: "abc"), 2)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "abc", rhs: "a"), 2)
    // Deletions
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "kitten", rhs: "kitt"), 2)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "kitt", rhs: "kitten"), 2)
  }

  func testLevenshteinDistance_substitutions() {
    // Substitutions
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "kitten", rhs: "sitten"), 1)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "kitten", rhs: "sittin"), 2)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "flaw", rhs: "lawn"), 2)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "gumbo", rhs: "gambol"), 2)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "book", rhs: "back"), 2)
  }

  func testLevenshteinDistance_mixedOperations() {
    // Mix of insertions, deletions, substitutions
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "intention", rhs: "execution"), 5)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "abcdef", rhs: "azced"), 3)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "Saturday", rhs: "Sunday"), 3)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "distance", rhs: "editing"), 5)
  }

  func testLevenshteinDistance_unicode() {
    // Unicode and emoji
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "我something", rhs: "someth"), 4)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "我好饿啊啊啊啊", rhs: "好烦啊"), 5)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "🐱", rhs: "🐶"), 1)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "🐱🐶", rhs: "🐱"), 1)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "🐱🐶", rhs: "🐶🐱"), 2)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "你好", rhs: "您好"), 1)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "你好世界", rhs: "世界你好"), 4)
  }

  func testLevenshteinDistance_longStrings() {
    let lhs: String = String(repeating: "a", count: 100)
    let rhs: String = String(repeating: "a", count: 100)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: lhs, rhs: rhs), 0)

    let str3: String = String(repeating: "a", count: 100)
    let str4: String = String(repeating: "b", count: 100)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: str3, rhs: str4), 100)

    let str5: String = String(repeating: "a", count: 50) + String(repeating: "b", count: 50)
    let str6: String = String(repeating: "a", count: 100)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: str5, rhs: str6), 50)
  }

  func testLevenshteinDistance_edgeCases() {
    // Single character
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "a", rhs: "b"), 1)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "a", rhs: ""), 1)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "", rhs: "a"), 1)

    // Completely different
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "abc", rhs: "xyz"), 3)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "123", rhs: "abc"), 3)

    // Case sensitivity
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "abc", rhs: "ABC"), 3)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "Abc", rhs: "abc"), 1)
  }

  func testLevenshteinDistance_originalCases() {
    // Original test cases from previous version
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "something", rhs: "some"), 5)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "something", rhs: "omethi"), 3)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "something", rhs: "same"), 6)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "something", rhs: "samewrongthong"), 7)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "something", rhs: ""), 9)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "", rhs: "some"), 4)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "some", rhs: "some"), 0)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "", rhs: ""), 0)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "我something", rhs: "someth"), 4)
    XCTAssertEqual(LevenshteinDistance.distance(lhs: "我好饿啊啊啊啊", rhs: "好烦啊"), 5)
  }
}
