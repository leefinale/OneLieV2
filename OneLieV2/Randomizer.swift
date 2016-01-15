//
//  Randomizer.swift
//  OneLieV2
//
//  Created by Elex Lee on 12/23/15.
//  Copyright © 2015 Elex Lee. All rights reserved.
//

import Foundation

func randomize(inputArray: [String], completion: (randomizedArray: [String], answerKey: Int) -> Void) {
    var scrambledArray: [String] = []
    var answerKey: Int
    let randNum = Int(arc4random_uniform(6))
    if randNum == 0 {
        scrambledArray.append(inputArray[0])
        scrambledArray.append(inputArray[1])
        scrambledArray.append(inputArray[2])
        answerKey = 2
    }
    else if randNum == 1 {
        scrambledArray.append(inputArray[0])
        scrambledArray.append(inputArray[2])
        scrambledArray.append(inputArray[1])
        answerKey = 1
    }
    else if randNum == 2 {
        scrambledArray.append(inputArray[1])
        scrambledArray.append(inputArray[0])
        scrambledArray.append(inputArray[2])
        answerKey = 2
    }
    else if randNum == 3 {
        scrambledArray.append(inputArray[1])
        scrambledArray.append(inputArray[2])
        scrambledArray.append(inputArray[0])
        answerKey = 1
    }
    else if randNum == 4 {
        scrambledArray.append(inputArray[2])
        scrambledArray.append(inputArray[0])
        scrambledArray.append(inputArray[1])
        answerKey = 0
    }
    else {
        scrambledArray.append(inputArray[2])
        scrambledArray.append(inputArray[1])
        scrambledArray.append(inputArray[0])
        answerKey = 0
    }
    completion(randomizedArray: scrambledArray, answerKey: answerKey)
}
