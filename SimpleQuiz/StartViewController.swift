//
//  StartViewController.swift
//  SimpleQuiz
//
//  Created by 寺島 洋平 on 2019/08/05.
//  Copyright © 2019年 YoheiTerashima. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 次の画面に遷移する前に呼び出される準備処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 問題文の読み込み
        QuestionDataManager.sharedInstance.loadQuestion()
        
        // 遷移先画面の呼び出し
        guard let nextViewController = segue.destination as? QuestionViewController else {
            // 取得できずに終了
            return
        }
        
        // 問題文の取り出し
        guard let questionData = QuestionDataManager.sharedInstance.nextQuestion() else {
            // 取得できずに終了
            return
        }
        
        // 問題文のセット
        nextViewController.questionData = questionData
    }
    
    // タイトルに戻ってくるときの処理
    @IBAction func goToTitle(_ segue: UIStoryboardSegue) {
        
    }

}
