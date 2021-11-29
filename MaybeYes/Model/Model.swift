//
//  Model.swift
//  MaybeYes
//
//  Created by Nikita Nesporov on 17.09.2021.
//

import UIKit


struct Question {
    let text: String
    let answerYes: String
    let answerNo: String
    
    init(question: String, yes: String, no: String) {
        text = question
        answerYes = yes
        answerNo = no
    }
}

struct QuizBrain {
    
    var questionNumber = 0
    var score = 0
    var lostScore = 0
    var timeToRefresh: Bool?
    
    /*
     let quiz = [
         Question(question: "Ёлка", yes: "True", no: "False"),
         Question(question: "Гирлянда", yes: "True", no: "False"),
         Question(question: "Шар", yes: "True", no: "False"),
         Question(question: "Праздник", yes: "True", no: "False"),
         Question(question: "Мороз", yes: "True", no: "False"),
         Question(question: "Снегурочка", yes: "True", no: "False"),
         Question(question: "Олень", yes: "True", no: "False"),
         Question(question: "Санки", yes: "True", no: "False"),
         Question(question: "Снег", yes: "True", no: "False"),
         Question(question: "Снежинка", yes: "True", no: "False"),
         Question(question: "Подарок", yes: "True", no: "False"),
         Question(question: "Снеговик", yes: "True", no: "False")
     ]
     */
    
    let quiz = [
        Question(question: "Ёлка", yes: "True", no: "False"),
        Question(question: "Гирлянда", yes: "True", no: "False") 
    ]
     
    func getQuestionText() -> String {
        return quiz[questionNumber].text
    }
    
    func getProgress() -> Float {
        print("\(Float(questionNumber) / Float(quiz.count))")
        
        return Float(questionNumber) / Float(quiz.count)
    }
      
    mutating func getScore() -> Int {
        return score
    }
    
    mutating func getLostScore() -> Int {
        return lostScore
    }
    
    mutating func nextQuestion() {
        if questionNumber + 1 < quiz.count {
            questionNumber += 1
            timeToRefresh = false
        } else if score + lostScore == quiz.count {
            timeToRefresh = true
            print("refresh?")
        } else {
            print("wtf 3")
        }
    }
    
    mutating func checkAnswer(userAnswer: String) { // -> Bool {
        if userAnswer == quiz[questionNumber].answerYes {
            score += 1
        } else if userAnswer == quiz[questionNumber].answerNo {
            lostScore += 1
        }
    }
    
    mutating func refresh() {
        self.questionNumber = 0
        self.score = 0
        self.lostScore = 0 
    }
}
 
