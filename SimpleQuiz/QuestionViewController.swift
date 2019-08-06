//
//  ViewController.swift
//  SimpleQuiz
//
//  Created by 寺島 洋平 on 2019/08/04.
//  Copyright © 2019年 YoheiTerashima. All rights reserved.
//

import UIKit
import AudioToolbox

class QuestionViewController: UIViewController {
    
    var questionData: QuestionData!
    // 問題番号のラベル
    @IBOutlet weak var questionNoLabel: UILabel!
    // 問題文のテイストビュー
    @IBOutlet weak var questionTextView: UITextView!
    // 選択肢1のボタン
    @IBOutlet weak var answer1Button: UIButton!
    // 選択肢2のボタン
    @IBOutlet weak var answer2Button: UIButton!
    // 選択肢3のボタン
    @IBOutlet weak var answer3Button: UIButton!
    // 選択肢4のボタン
    @IBOutlet weak var answer4Button: UIButton!
    // 正解のイメージビュー
    @IBOutlet weak var correctImageView: UIImageView!
    // 不正解のイメージビュー
    @IBOutlet weak var incorrectImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初期データの設定処理
        // 全画面で設定済みのquestionDataから値を取り出す
        questionNoLabel.text = "Q.\(questionData.questionNo)"
        questionTextView.text = questionData.question
        answer1Button.setTitle(questionData.answer1, for: UIControlState.normal)
        answer2Button.setTitle(questionData.answer2, for: UIControlState.normal)
        answer3Button.setTitle(questionData.answer3, for: UIControlState.normal)
        answer4Button.setTitle(questionData.answer4, for: UIControlState.normal)
    }
    
    // 選択肢1をタップ
    @IBAction func tapAnswer1Button(_ sender: Any) {
        questionData.userChiceanswerNumber = 1
        goNextQuestionWithAnimation()
    }
    // 選択肢2をタップ
    @IBAction func tapAnswer2Button(_ sender: Any) {
        questionData.userChiceanswerNumber = 2
        goNextQuestionWithAnimation()
    }
    // 選択肢3をタップ
    @IBAction func tapAnswer3Button(_ sender: Any) {
        questionData.userChiceanswerNumber = 3
        goNextQuestionWithAnimation()
    }
    // 選択肢4をタップ
    @IBAction func tapAnswer4Button(_ sender: Any) {
        questionData.userChiceanswerNumber = 4
        goNextQuestionWithAnimation()
    }
    
    func goNextQuestionWithAnimation() {
        // 正解しているかどうかを判定する
        if questionData.isCorrect() {
            // 正解のアニメーションを再生しながら次の問題へ遷移
            goNextQuestionWithCorrectAnimation()
        } else {
            // 不正解のアニメーションを再生しながら次の問題へ遷移する
            goNextQuestionWithIncorrectAnimation()
        }
    }
    
    // 次の問題に正解のアニメーション付きで遷移する
    func goNextQuestionWithCorrectAnimation() {
        // 正解を伝える音を鳴らす
        AudioServicesPlayAlertSound(1025)
        // アニメーション
        UIView.animate(withDuration: 2.0, animations: {
            // アルファ値を1.0に変化させる
            // 初期ちはStoryboardで0.0に設定済み
            self.correctImageView.alpha = 1.0
        }) { (Bool) in
            // アニメーション完了後に次の問題に進む
            self.goNextQuestion()
        }
    }
    
    // 次の問題に父兄会のアニメーション付きで遷移する
    func goNextQuestionWithIncorrectAnimation() {
        // 不正解を伝える音を鳴らす
        AudioServicesPlayAlertSound(1006)
        // アニメーション
        UIView.animate(withDuration: 2.0, animations: {
            // アルファ値を1.0に変化させる
            // 初期ちはStoryboardで0.0に設定済み
            self.incorrectImageView.alpha = 1.0
        }) { (Bool) in
            // アニメーション完了後に次の問題に進む
            self.goNextQuestion()
        }
    }
    
    // 次の問題に遷移する
    func goNextQuestion() {
        // 問題文の取り出し
        guard let nextQuestion = QuestionDataManager.sharedInstance.nextQuestion() else {
            // 問題文がなければ結果画面へ遷移する
            // StoryboardのIdentifierに設定した（result）を指定してViewControllerを生成する
            if let resultViewController = storyboard?.instantiateViewController(withIdentifier: "result") as? ResultViewController {
                // StoryboardのSegueを利用しない明示的な画面遷移処理
                present(resultViewController, animated: true, completion: nil)
            }
            return
        }
        
        // 問題文がある場合は次の問題へ遷移する
        // StoryboardのIdentifierに設定した値（question）を設定してViewControllerを生成する
        if let nextQuestionViewController = storyboard?.instantiateViewController(withIdentifier: "question") as? QuestionViewController {
            nextQuestionViewController.questionData = nextQuestion
            // StoryboardのSegueを利用しない明示的な画面遷移処理
            present(nextQuestionViewController, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

