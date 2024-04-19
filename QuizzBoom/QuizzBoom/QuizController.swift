//
//  QuizController.swift
//  QuizzBoom
//
//  Created by Samy Chennoufi on 09/04/2024.
//

import UIKit

struct contenuQuiz{
    let question : String
    let image : UIImage?
    let reponses : [String]
    let reponseCorrecte: Int
}

class QuizController: UIViewController {
    
    //choix du joueur de la difficulte de la question (envvoyée par laa classe AttaquerController
    var choixDifficulte = UserDefaults.standard.string(forKey: "choixDifficulte")
    
    //Tableau pour stocker les quesitons en fonction de leur difficulte
    var questionsFaciles:[contenuQuiz] =  []
    var questionsMoyennes:[contenuQuiz] =  []
    var questionsDifficiles:[contenuQuiz] =  []
    
    var questionCourante : contenuQuiz!
    var bonneReponse : Int = 0
    
    //Compteur pour savoir combien de bombes le joueur peut placer
    var compteur : Int = 0
    
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    
    @IBOutlet var reponses: [UILabel]!
    var estTourJoueur1: Bool{
        get {
            // Récupérer la valeur de estTourJoueur1 depuis UserDefaults
            return UserDefaults.standard.bool(forKey: "estTourJoueur1")
        }
        set {
            // Sauvegarder la nouvelle valeur de estTourJoueur1 dans UserDefaults
            UserDefaults.standard.set(newValue, forKey: "estTourJoueur1")
        }
    }
    @IBAction func reponse(_ sender: UIButton) {
        
        // Si bonne reponse, on change la couleur du texte en vert et on affiche un alert de felicitations
        if sender.tag == bonneReponse {
            reponses[sender.tag].textColor = UIColor.green
            let alert = UIAlertController(title: "Bravooo ", message: "C'est la bonne réponse !", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                   
                // Changer le compteur en fonction de la difficulté de la question
                switch self.choixDifficulte {
                    case "facile":
                       self.compteur = 1
                   case "moyenne":
                       self.compteur = 2
                   case "difficile":
                       self.compteur = 3
                   default:
                       break
                   }
                   
                //Recuperer la valeur du comtpeur
                UserDefaults.standard.set(self.compteur, forKey: "compteurValue")
                   
                // Transition vers la vue d'attaque appropriée en fonction du tour du joueur
                if self.estTourJoueur1 {
                    if let joueur1AttaqueViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Joueur1attaque") as? AttaquerController {
                        self.navigationController?.pushViewController(joueur1AttaqueViewController, animated: true)
                    }
                } else {
                    if let joueur2AttaqueViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Joueur2attaque") as? AttaquerController {
                        self.navigationController?.pushViewController(joueur2AttaqueViewController, animated: true)
                    }
                }
                // Inverser tour joueur
                self.estTourJoueur1.toggle()
            }))
            self.present(alert, animated: true, completion: nil)
        } else { // Si mauvaise reponse on affiche une alert d'echec
            let alert = UIAlertController(title: "Dommage !", message: "Ce n'est pas la bonne réponse", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                           
                        // Transition vers la vue d'attaque appropriée en fonction du tour du joueur
                        if self.estTourJoueur1 {
                            self.estTourJoueur1 = false // Passer au tour du joueur 2
                            print("mauvaise reponse et j1 \(self.estTourJoueur1)")
                            if let joueur2AttaqueViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Joueur2attaque") as? AttaquerController {
                                self.navigationController?.pushViewController(joueur2AttaqueViewController, animated: true)
                                   
                                // Charger un nouveau quiz pour le joueur 2
                                self.affichageQuestion(difficulte: self.choixDifficulte!)
                            }
                        } else {
                            self.estTourJoueur1 = true // Passer au tour du joueur 1
                            print("mauvaise reponse et j2 \(self.estTourJoueur1)")
                            if let joueur1AttaqueViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Joueur1attaque") as? AttaquerController {
                                self.navigationController?.pushViewController(joueur1AttaqueViewController, animated: true)
                                   
                                // Charger un nouveau quiz pour le joueur 1
                                self.affichageQuestion(difficulte: self.choixDifficulte!)
                            }
                        }
                    }))
            
                    // Afficher les alert
                    self.present(alert, animated: true, completion: nil)
                }
            }
    
    
    func affichageQuestion(difficulte : String){
        
        // choix question de manniere random
        if  difficulte == "facile"{
            questionCourante = questionsFaciles.randomElement()
        }else if  difficulte == "moyenne"{
            questionCourante = questionsMoyennes.randomElement()
        }else {
            questionCourante = questionsDifficiles.randomElement()
        }
        
        //initialisation labels
        question.text = questionCourante.question
        reponses[0].text = questionCourante.reponses[0]
        reponses[1].text = questionCourante.reponses[1]
        reponses[2].text = questionCourante.reponses[2]
        reponses[3].text = questionCourante.reponses[3]
        bonneReponse = questionCourante.reponseCorrecte
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Vérifier si estTourJoueur1 n'a pas été initialisé dans UserDefaults
        if UserDefaults.standard.object(forKey: "estTourJoueur1") == nil {
            // Initialiser estTourJoueur1 à true
            estTourJoueur1 = true
        }
        
        // Création des questions dans un dictionnaire
        let question1 = contenuQuiz(question: "Quel est la capitale de la France ?", image: nil, reponses: ["Londres", "Berlin", "Paris", "Rome"], reponseCorrecte: 2)
        let question2 = contenuQuiz(question: "Quel est le nombre de jours dans une année bissextile ?", image: nil, reponses: ["364", "365", "366", "367"], reponseCorrecte: 2)
        let question3 = contenuQuiz(question: "Quel est le plus grand animal terrestre ?", image: nil, reponses: ["Éléphant", "Girafe", "Hippopotame", "Rhinocéros"], reponseCorrecte: 0)
        let question4 = contenuQuiz(question: "Quel est le nom de la rivière qui traverse Paris ?", image: nil, reponses: ["Seine", "Loire", "Garonne", "Rhône"], reponseCorrecte: 0)
        let question5 = contenuQuiz(question: "Quel est le nom du premier président des États-Unis ?", image: nil, reponses: ["Abraham Lincoln", "George Washington", "Thomas Jefferson", "Andrew Jackson"], reponseCorrecte: 1)
        let question6 = contenuQuiz(question: "Quelle est la formule chimique de l'eau ?", image: nil, reponses: [ "NaCl", "CO2","H2O", "N2"], reponseCorrecte: 2)
        let question7 = contenuQuiz(question: "Quel est le nom de la plus haute montagne du monde ?", image: UIImage(named: "montagne"), reponses: ["K2","Mont Everest", "Kangchenjunga", "Lhotse"], reponseCorrecte: 1)
        let question8 = contenuQuiz(question: "Quel est le nom de la plus petite particule subatomique ?", image: nil, reponses: ["Électron", "Photon", "Neutrino","Quark"], reponseCorrecte: 3)
        let question9 = contenuQuiz(question: "Quel est le nom de la théorie scientifique qui explique l'origine de l'univers ?", image: UIImage(named: "guerre"), reponses: ["Big Bang", "Théorie des cordes", "Mécanique quantique", "Relativité générale"], reponseCorrecte: 0)
                
        // Ajout des questions dans les tableaux correspondants
        questionsFaciles.append(contentsOf: [question1, question2, question3])
        questionsMoyennes.append(contentsOf: [question4, question5, question6])
        questionsDifficiles.append(contentsOf: [question7, question8, question9])
        
        //Afficher question
        affichageQuestion(difficulte: choixDifficulte!)
        
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
