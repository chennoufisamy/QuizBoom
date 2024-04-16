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
    var difficulte: String = ""
    var questionsFaciles:[contenuQuiz] =  []
    var questionsMoyennes:[contenuQuiz] =  []
    var questionsDifficiles:[contenuQuiz] =  []
    
    var questionCourante : contenuQuiz!
    var bonneReponse : Int = 0
    var compteur : Int = 0
    
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    
    @IBOutlet var reponses: [UILabel]!
    
    @IBAction func reponse(_ sender: UIButton) {
        print("Bouton \(sender.tag)")
                   if sender.tag == bonneReponse {
                       reponses[sender.tag].textColor = UIColor.green
                       let alert = UIAlertController(title: "Bravooo ", message: "C'est la bonne réponse !", preferredStyle: .alert)
                       alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                           NSLog("The \"OK\" alert occured.")
                           
                           // Augmenter le compteur en fonction de la difficulté de la question
                           switch self.difficulte {
                           case "facile":
                               // Ajouter 1 au compteur
                               // Supposons que "counter" est une variable de votre ViewController qui garde la trace du score
                               self.compteur += 1
                           case "moyenne":
                               // Ajouter 2 au compteur
                               self.compteur += 2
                           case "difficile":
                               // Ajouter 3 au compteur
                               self.compteur += 3
                               
                           default:
                               break
                           }
                           // Déclencher la transition vers la vue suivante
                           if let joueur1AttaqueViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Joueur1attaque") as? AttaquerController {
                               self.navigationController?.pushViewController(joueur1AttaqueViewController, animated: true)
                           }
                       }))
                       self.present(alert, animated: true, completion: nil)
                   } else {
                       // Au lieu de déclencher la transition vers le QuizController, on déclenche la transition vers la vue "joueur 2 attaque"
                       let alert = UIAlertController(title: "Dommage !", message: "Ce n'est pas la bonne réponse", preferredStyle: .alert)
                       alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                           NSLog("The \"OK\" alert occured.")
                           if let joueur2AttaqueViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Joueur2attaque") as? AttaquerController {
                               self.navigationController?.pushViewController(joueur2AttaqueViewController, animated: true)
                           } 
                       }))
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

        let question1 = contenuQuiz(question: "Quel est la capitale de la France ?", image: nil, reponses: ["Londres", "Berlin", "Paris", "Rome"], reponseCorrecte: 2)
        let question2 = contenuQuiz(question: "Quel est le nombre de jours dans une année bissextile ?", image: nil, reponses: ["364", "365", "366", "367"], reponseCorrecte: 2)
        let question3 = contenuQuiz(question: "Quel est le plus grand animal terrestre ?", image: nil, reponses: ["Éléphant", "Girafe", "Hippopotame", "Rhinocéros"], reponseCorrecte: 0)
        let question4 = contenuQuiz(question: "Quel est le nom de la rivière qui traverse Paris ?", image: nil, reponses: ["Seine", "Loire", "Garonne", "Rhône"], reponseCorrecte: 0)
        let question5 = contenuQuiz(question: "Quel est le nom du premier président des États-Unis ?", image: nil, reponses: ["Abraham Lincoln", "George Washington", "Thomas Jefferson", "Andrew Jackson"], reponseCorrecte: 1)
        let question6 = contenuQuiz(question: "Quelle est la formule chimique de l'eau ?", image: nil, reponses: [ "NaCl", "CO2","H2O", "N2"], reponseCorrecte: 2)
        let question7 = contenuQuiz(question: "Quel est le nom de la plus haute montagne du monde ?", image: nil, reponses: ["K2","Mont Everest", "Kangchenjunga", "Lhotse"], reponseCorrecte: 1)
        let question8 = contenuQuiz(question: "Quel est le nom de la plus petite particule subatomique ?", image: nil, reponses: ["Électron", "Photon", "Neutrino","Quark"], reponseCorrecte: 3)
        let question9 = contenuQuiz(question: "Quel est le nom de la théorie scientifique qui explique l'origine de l'univers ?", image: nil, reponses: ["Big Bang", "Théorie des cordes", "Mécanique quantique", "Relativité générale"], reponseCorrecte: 0)
                
        // Ajout des questions dans les tableaux correspondants
        questionsFaciles.append(contentsOf: [question1, question2, question3])
        questionsMoyennes.append(contentsOf: [question4, question5, question6])
        questionsDifficiles.append(contentsOf: [question7, question8, question9])
        affichageQuestion(difficulte: difficulte)
        
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
