//
//  File.swift
//  SimpleQuiz
//
//  Created by 寺島 洋平 on 2019/08/05.
//  Copyright © 2019年 YoheiTerashima. All rights reserved.
//

import Foundation

// 一つの問題に関する情報を格納するデータクラス
class QuestionData {
    // 問題文
    var question: String
    // 選択肢1
    var answer1: String
    // 選択肢2
    var answer2: String
    // 選択肢3
    var answer3: String
    // 選択肢4
    var answer4: String
    // 正解の番号
    var correctAnswerNumber: Int
    // ユーザーが選択した選択肢の番号
    var userChiceanswerNumber: Int?
    // 問題文の番号
    var questionNo: Int = 0
    
    // クラスが生成されたときの処理
    init(questionSourceDataArray: [String]) {
        question = questionSourceDataArray[0]
        answer1 = questionSourceDataArray[1]
        answer2 = questionSourceDataArray[2]
        answer3 = questionSourceDataArray[3]
        answer4 = questionSourceDataArray[4]
        correctAnswerNumber = Int(questionSourceDataArray[5])!
    }
    
    // ユーザーが選択した答えが正解かどうか判定する
    func isCorrect() -> Bool {
        // 答えが一致しているかどうかを判定する
        if correctAnswerNumber == userChiceanswerNumber {
            // 正解
            return true
        }
        // 不正解
        return false
    }
}

// クイズデータ全般の管理と成績を管理するクラス
class QuestionDataManager {
    // シングルトンのオブジェクトを生成
    static let sharedInstance = QuestionDataManager()
    
    // 問題全体を格納するための配列
    var questionDataArray = [QuestionData]()
    
    // 現在の問題の番号（インデックス）
    var nowQuestionIndex: Int = 0
    
    // 初期化処理
    private init() {
        // シングルトンであることを保証するためにprivateで宣言しておく
    }
    
    // 問題文の読み込み処理
    func loadQuestion() {
        
        // 格納済みの問題文があれば一旦削除しておく
        questionDataArray.removeAll()
        
        // 現在の問題のインデックスを初期化
        nowQuestionIndex = 0
        
        // csvファイルのパスを取得
        guard let csvfilePath = Bundle.main.path(forResource: "question", ofType: "csv") else {
            // csvファイルなし
            print("csvファイルが存在しません")
            return
        }
        
        // csvファイルの読み込み
        do {
            let csvStringData = try String(contentsOfFile: csvfilePath, encoding: String.Encoding.utf8)
            // csvデータを1行づつ読み込む
            csvStringData.enumerateLines(invoking: {(line, stop) in
                // カンマ区切りで分割
                let questionSourceDataArray = line.components(separatedBy: ",")
                // 問題データを格納するオブジェクトを作成
                // QuestionDataクラスのインスタンス
                let questionData = QuestionData(questionSourceDataArray: questionSourceDataArray)
                // 1つの問題のインスタンスを問題全体を格納する配列に追加
                self.questionDataArray.append(questionData)
                // インスタンスに問題番号を設定
                questionData.questionNo = self.questionDataArray.count
            })
        } catch let error {
            print("csvファイル読み込みエラーが発生しました:\(error)")
            return
        }
    }
    
    // 次の問題を取り出す
    func nextQuestion() -> QuestionData? {
        if nowQuestionIndex < questionDataArray.count {
            let nextQuestion = questionDataArray[nowQuestionIndex]
            nowQuestionIndex += 1
            return nextQuestion
        }
        return nil
    }
}
