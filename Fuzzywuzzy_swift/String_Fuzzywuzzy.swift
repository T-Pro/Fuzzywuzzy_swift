//
//  String_Fuzzywuzzy.swift
//  Fuzzywuzzy_swift
//
//  Created by XianLi on 30/8/2016.
//  Copyright © 2016 LiXian. All rights reserved.
//

import UIKit

public extension String {
    /// Basic Scoring Functions
    static public func fuzzRatio(str1 str1: String, str2: String) -> Int {
        let m = StringMatcher(str1: str1, str2: str2)
        return Int(m.fuzzRatio() * 100)
    }
    
    /// trys to match the shorter string with the most common substring of the longer one
    static public func fuzzPartialRatio(str1 str1: String, str2: String) -> Int {
        let shorter: String
        let longer: String
        if str1.characters.count < str2.characters.count {
            shorter = str1
            longer = str2
        } else {
            shorter = str2
            longer = str1
        }
        
        let m = StringMatcher(str1: shorter, str2: longer)
        let commonPairs = m.commonSubStringPairs
        
        let scores = commonPairs.map { (pair) -> Float in
            /// filter out pairs that are too short ( < 20% of the lenght of the shoter string )
            if pair.len * 5 < shorter.characters.count {
                return 0
            }
            
            let sub2RemLen = pair.str2SubRange.startIndex.distanceTo(longer.endIndex)
            var longSubStart = pair.str2SubRange.startIndex
            if sub2RemLen < shorter.characters.count {
                longSubStart = longSubStart.advancedBy(sub2RemLen - shorter.characters.count)
            }
            let longSubEnd   = longSubStart.advancedBy(shorter.characters.count-1)
            
            let longSubStr = longer.substringWithRange(Range(longSubStart...longSubEnd))
            let r = StringMatcher(str1: shorter, str2: longSubStr).fuzzRatio()
            if r > 0.995 { /// magic number appears in original python code
                return 1
            } else {
                return r
            }
        }
        return Int((scores.maxElement() ?? 0) * 100)
    }
    
    static private func _fuzzProcessAndSort(str: String, fullProcess: Bool = true) -> String {
        var str = str
        if fullProcess {
            str = StringProcessor.process(str)
        }
        let tokens = Array(str.componentsSeparatedByString(" "))
        return tokens.sort().joinWithSeparator(" ").stringByTrimmingCharactersInSet(NSCharacterSet.init(charactersInString: ""))
    }
    
    static private func _fuzzTokenSort(str1 str1: String, str2: String, partial: Bool = true, fullProcess: Bool = true) -> Int {
        let sorted1 = _fuzzProcessAndSort(str1, fullProcess: fullProcess)
        let sorted2 = _fuzzProcessAndSort(str2, fullProcess: fullProcess)
        
        if partial {
            return fuzzPartialRatio(str1: sorted1, str2: sorted2)
        } else {
            return fuzzRatio(str1: sorted1, str2: sorted2)
        }
    }
    
    static public func fuzzTokenSortRatio(str1 str1: String, str2: String, fullProcess: Bool = true) -> Int {
        return _fuzzTokenSort(str1: str1, str2: str2, partial: false, fullProcess: fullProcess)
    }
    
    static public func fuzzPartialTokenSortRatio(str1 str1: String, str2: String, fullProcess: Bool = true) -> Int {
        return _fuzzTokenSort(str1: str1, str2: str2, partial: true, fullProcess: fullProcess)
    }
}
