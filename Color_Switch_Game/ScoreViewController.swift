//
//  ScoreViewController.swift
//  Color_Switch_Game
//
//  Created by SAM on 30/04/2019.
//  Copyright © 2019 SAM. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController{
 

    @IBOutlet var highscore: UILabel!
    @IBOutlet var score: UILabel!
    
    var high_score:Int!
    var score_pass:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        vc.delegate_vc = self


        highscore.text = String(high_score!)
        score.text = String(score_pass!)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
