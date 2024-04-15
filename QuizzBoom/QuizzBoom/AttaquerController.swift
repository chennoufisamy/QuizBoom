//
//  AttaquerController.swift
//  QuizzBoom
//
//  Created by Samy Chennoufi on 11/04/2024.
//

import UIKit

class AttaquerController: UIViewController {

    var nomJoueur1a : String = ""
    var nomJoueur2a : String = ""

    
    @IBOutlet weak var joueur1MessageLabel: UILabel!
    
    @IBOutlet weak var joueur2messageLabel: UILabel!
    
    @IBOutlet weak var compteurLabelJoueur1: UILabel!
    
    @IBOutlet weak var compteurLabelJoueur2: UILabel!
    var choixDifficulte : String = ""
    @IBAction func choixDifficulte(_ sender: UIButton) {
        if sender.tag == 0{
            choixDifficulte = "facile"
        }else if sender.tag == 1{
            choixDifficulte = "moyenne"
        }else{
            choixDifficulte = "difficile"
        }
    }
    //Evoi de la variable choixDifficulte à classe QuizController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "versQuiz" {
            if let destinationVC = segue.destination as? QuizController {
                destinationVC.difficulte = choixDifficulte
                print("difficulte \(choixDifficulte)")
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(nomJoueur1a)")
        if nomJoueur1a == ""{
            joueur1MessageLabel.text = "Joueur1, c'est ton tour!"
        } else{
            joueur1MessageLabel.text = "\(nomJoueur1a), c'est ton tour!"
        }
        /*if nomJoueur2a == ""{
            joueur2messageLabel.text = "Joueur2, c'est ton tour!"
        }else{
            joueur2messageLabel.text = "\(nomJoueur2a), c'est ton tour!"
        }*/
        
        
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
