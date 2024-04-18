//
//  AttaquerController.swift
//  QuizzBoom
//
//  Created by Samy Chennoufi on 11/04/2024.
//

import UIKit

class AttaquerController: UIViewController {
    
    let nbObjets: Int = 5
    var gameOver : Bool = false
    var compteur : Int = UserDefaults.standard.integer(forKey: "compteurValue")
    var nomJoueur1 = UserDefaults.standard.string(forKey: "nomJoueur1Value")
    var nomJoueur2 = UserDefaults.standard.string(forKey: "nomJoueur2Value")
    var nbObjetsAbbatusJ1 : Int = 0
    var nbObjetsAbbatusJ2 : Int = 0
    var grilleJoueur1tab: [[String]]?
    var grilleJoueur2tab: [[String]]?
    var positionGrilleJoueur1: [[Int]]?
    var positionGrilleJoueur2: [[Int]]?
    
    @IBOutlet weak var joueur1MessageLabel: UILabel!
    
    @IBOutlet weak var joueur2messageLabel: UILabel!
    
    @IBOutlet weak var compteurLabelJoueur1: UILabel!
    
    @IBOutlet weak var compteurLabelJoueur2: UILabel!
    var choixDifficulte : String = ""
    @IBAction func choixDifficulte(_ sender: UIButton) {
        /*compteur = 0*/
        if sender.tag == 0{
            choixDifficulte = "facile"
            /*compteur = 1*/
        }else if sender.tag == 1{
            choixDifficulte = "moyenne"
            /*compteur = 2*/
        }else{
            choixDifficulte = "difficile"
            /*compteur = 3*/
        }
        /*print("compteur \(compteur)")*/
        /*UserDefaults.standard.set(compteur, forKey: "compteurValue")*/

    }
    //Evoi de la variable choixDifficulte à classe QuizController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "versQuiz" {
            if let destinationVC = segue.destination as? QuizController {
                destinationVC.difficulte = choixDifficulte
            }
        }
    }
    
    func verifObjetAbbatu(ligne: Int,colonne : Int,positionGrilleJoueur : [[Int]],grilleJoueur : [[String]]) -> Bool {
        for position in positionGrilleJoueur{
            var debutLigne = position[0]
            var finLigne = position[1]
            var debutColonne = position[2]
            var finColonne = position[3]
            if (debutLigne <= ligne && ligne <= finLigne) && (debutColonne <= colonne && colonne <= finColonne){
                for l in debutLigne...finLigne{
                    for c in debutColonne...finColonne{
                        if grilleJoueur[l][c] != "X"{
                            return false
                        }
                    }
                }
            }
        }
        return true
    }
    
    func attaquer(grilleJoueur : inout [[String]], positionGrilleJoueur : inout [[Int]], nbObjetsAbbatus : inout Int,compteur : inout Int){
        
        var ligne : Int = -1
        var colonne : Int = -1
        while compteur > 0 {
            
            // fonction qui permet à l'utilisateur de choisir une case à attaquer et qui return la ligne et la colonne de la case choisie
            /*(ligne, colonne) = attaquerCase()*/
            
            /// Si aucun objet placé sur cette case
            if grilleJoueur[ligne][colonne] == "."{
                grilleJoueur[ligne][colonne] = "#"
                let alert = UIAlertController(title: "Attaque échoué", message: "Case vide, aucun objet n'a été touché", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {_ in }))
            }else if grilleJoueur[ligne][colonne] == "O"{ // Si objet placé
                grilleJoueur[ligne][colonne] = "X"
                let alert = UIAlertController(title: "Attaque réussi!", message: "Bingo, tu as touché un objet!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {_ in
                    if self.verifObjetAbbatu(ligne: ligne,colonne: colonne, positionGrilleJoueur: self.positionGrilleJoueur1!, grilleJoueur: self.grilleJoueur1tab!){ //Si objet abbatu
                        let alert = UIAlertController(title: "Objet détrui!", message: "Un objet a été détrui.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {_ in}))
                        self.nbObjetsAbbatusJ1 += 1
                    }
                }))
            }
            compteur -= 1
        }
        
    }
    
    func verifGameOver(nbObjetsAbbatus : Int){
        if nbObjets == nbObjetsAbbatus{
            gameOver = true
            let alert = UIAlertController(title: "Game Over", message: "Tu as gagné!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Revenir à l'accueil", comment: "Default action"), style: .default, handler: {_ in
                if let revenirAccueil = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                if let rootViewController = revenirAccueil.windows.first?.rootViewController {
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    if let entreeAppViewController = storyboard.instantiateViewController(withIdentifier: "entreeApp") as? UIViewController {
                                        rootViewController.present(entreeAppViewController, animated: true, completion: nil)
                                    }
                                }
                            }
            }))
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        /*compteur = UserDefaults.standard.integer(forKey: "compteurValue")*/
        print("ciao \(nomJoueur1 ?? "")")
        print("ciao \(nomJoueur2 ?? "")")
        if nomJoueur1 == ""{
            joueur1MessageLabel?.text = "Joueur1, c'est ton tour!"
        } else{
            joueur1MessageLabel?.text = "\(nomJoueur1!), c'est ton tour!"
        }
        if nomJoueur2 == ""{
            joueur2messageLabel?.text = "Joueur2, c'est ton tour!"
        }else{
            joueur2messageLabel?.text = "\(nomJoueur2!), c'est ton tour!"
        }
        compteurLabelJoueur1?.text = "Nombre de bombes : \(compteur)"
        print("compteur 2 \(compteur)")
        
        grilleJoueur1tab = UserDefaults.standard.array(forKey: "grilleJoueur1tab") as? [[String]]
               
        grilleJoueur2tab = UserDefaults.standard.array(forKey: "grilleJoueur2tab") as? [[String]]
        
        positionGrilleJoueur1 = UserDefaults.standard.array(forKey: "positionGrilleJoueur1") as? [[Int]]
        
        positionGrilleJoueur2 = UserDefaults.standard.array(forKey: "positionGrilleJoueur2") as? [[Int]]
        
        if let grilleJoueur1tab = grilleJoueur1tab {
            for ligne in grilleJoueur1tab {
                let ligneString = ligne.joined(separator: " ") // Convertir la ligne en une chaîne en joignant ses éléments avec un espace
                print(ligneString)
            }
        }
        if let positionGrilleJoueur1 = positionGrilleJoueur1 {
            for ligne in positionGrilleJoueur1 {
                let ligneString = ligne.map { String($0) }.joined(separator: " ") // Convertir la ligne en une chaîne en joignant ses éléments avec un espace
                print(ligneString)
            }}
        
       if let grilleJoueur2tab = grilleJoueur2tab {
            for ligne in grilleJoueur2tab {
                let ligneString = ligne.joined(separator: " ") // Convertir la ligne en une chaîne en joignant ses éléments avec un espace
                print(ligneString)
            }
        }
        if let positionGrilleJoueur2 = positionGrilleJoueur2 {
            for ligne in positionGrilleJoueur2 {
                let ligneString = ligne.map { String($0) }.joined(separator: " ") // Convertir la ligne en une chaîne en joignant ses éléments avec un espace
                print(ligneString)
            }}
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
