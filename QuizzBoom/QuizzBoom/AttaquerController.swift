//
//  AttaquerController.swift
//  QuizzBoom
//
//  Created by Samy Chennoufi on 11/04/2024.
//

import UIKit

class AttaquerController: UIViewController {
    var nomJoueur1 : String = ""
    var nomJoueur2 : String = ""
    var compteur : Int = 0
    
    @IBOutlet weak var joueur1MessageLabel: UILabel!
    
    @IBOutlet weak var joueur2messageLabel: UILabel!
    
    @IBOutlet weak var compteurLabelJoueur1: UILabel!
    
    @IBOutlet weak var compteurLabelJoueur2: UILabel!
    var choixDifficulte : String = ""
    @IBAction func choixDifficulte(_ sender: UIButton) {
        
        if sender.tag == 0{
            choixDifficulte = "facile"
            compteur += 1
        }else if sender.tag == 1{
            choixDifficulte = "moyenne"
            compteur += 2
        }else{
            choixDifficulte = "difficile"
            compteur += 3
        }
        print("compteur \(compteur)")
        UserDefaults.standard.set(compteur, forKey: "compteurValue")

    }
    //Evoi de la variable choixDifficulte à classe QuizController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "versQuiz" {
            if let destinationVC = segue.destination as? QuizController {
                destinationVC.difficulte = choixDifficulte
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        compteur = UserDefaults.standard.integer(forKey: "compteurValue")
        print("ciao \(nomJoueur1)")
        print("ciao \(nomJoueur2)")
        if nomJoueur1 == ""{
            joueur1MessageLabel?.text = "Joueur1, c'est ton tour!"
        } else{
            joueur1MessageLabel?.text = "\(nomJoueur1), c'est ton tour!"
        }
        if nomJoueur2 == ""{
            joueur2messageLabel?.text = "Joueur2, c'est ton tour!"
        }else{
            joueur2messageLabel?.text = "\(nomJoueur2), c'est ton tour!"
        }
        compteurLabelJoueur1?.text = "Nombre de bombes : \(compteur)"
        print("compteur 2 \(compteur)")
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
