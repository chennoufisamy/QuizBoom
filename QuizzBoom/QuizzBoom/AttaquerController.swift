//
//  AttaquerController.swift
//  QuizzBoom
//
//  Created by Samy Chennoufi on 11/04/2024.
//

import UIKit

class AttaquerController: UIViewController {
    
    let nbObjets: Int = 1 //On met nbObjets à 1 au lieu que 5 afin de rendle le test plus rapide et pouvoir arriver à l'écran de "Game Over" plus rapidement (généralement il est à 5)
    
    var gameOver : Bool = false
    var compteur : Int = UserDefaults.standard.integer(forKey: "compteurValue")
    var nomJoueur1 = UserDefaults.standard.string(forKey: "nomJoueur1Value")
    var nomJoueur2 = UserDefaults.standard.string(forKey: "nomJoueur2Value")
    var nbObjetsAbbatusJ1 : Int = 0
    var nbObjetsAbbatusJ2 : Int = 0
    var grilleJoueur1tab: [[String]] = UserDefaults.standard.array(forKey: "grilleJoueur1tab") as? [[String]] ?? [[]]
    var grilleJoueur2tab: [[String]] = UserDefaults.standard.array(forKey: "grilleJoueur2tab") as? [[String]] ?? [[]]
    var positionGrilleJoueur1 : [[Int]] = UserDefaults.standard.array(forKey: "positionGrilleJoueur1") as? [[Int]] ?? [[]]
    var positionGrilleJoueur2 : [[Int]] = UserDefaults.standard.array(forKey: "positionGrilleJoueur2") as? [[Int]] ?? [[]]
    var estTourJoueur1: Bool = UserDefaults.standard.bool(forKey: "estTourJoueur1")
    var remainingTouches: Int = 0
    
    @IBOutlet weak var joueur1MessageLabel: UILabel!
    
    @IBOutlet weak var joueur2messageLabel: UILabel!

    @IBOutlet weak var compteurLabelJoueur1: UILabel!
    
    @IBOutlet weak var compteurLabelJoueur2: UILabel!
    
    var choixDifficulte : String = ""
    
    // Récupérer la difficultée choisie par l'utilisateur et la stocker
    @IBAction func choixDifficulte(_ sender: UIButton) {
        if sender.tag == 0{
            choixDifficulte = "facile"
            UserDefaults.standard.set(choixDifficulte, forKey: "choixDifficulte")
        }else if sender.tag == 1{
            choixDifficulte = "moyenne"
            UserDefaults.standard.set(choixDifficulte, forKey: "choixDifficulte")
        }else{
            choixDifficulte = "difficile"
            UserDefaults.standard.set(choixDifficulte, forKey: "choixDifficulte")
        }
    }
    
    // Changer de joueur (passer d'une vue à l'autre
    func changementJoueur(compteur : Int){
        if (compteur == 0){
            if (self.estTourJoueur1){
            self.estTourJoueur1 = false // Passer au tour du joueur 2
            if let joueur2AttaqueViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Joueur2attaque") as? AttaquerController {
                self.navigationController?.pushViewController(joueur2AttaqueViewController, animated: true)
            }
        }else {
            self.estTourJoueur1 = true // Passer au tour du joueur 1
            if let joueur1AttaqueViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Joueur1attaque") as? AttaquerController {
                self.navigationController?.pushViewController(joueur1AttaqueViewController, animated: true)
            }
        }
        }
        
    }
    
    // Verifier si l'objet est abbatu
    func verifObjetAbbatu(ligne: Int,colonne : Int,positionGrilleJoueur : [[Int]],grilleJoueur : [[String]]) -> Bool {
        
        // A l'aide des positions des objets dans la grille, on vérifie que ces position sont toutes des "X". Si c'est le cas on retur true sinon c'est false
        for position in positionGrilleJoueur{
            print("verif abattu") 
            let ligneDepart = position[0]
            let ligneFin = position[1]
            let colonneDepart = position[2]
            let colonneFin = position[3]
            if (ligneDepart <= ligne) && (ligne <= ligneFin) && (colonneDepart <= colonne) && (colonne <= colonneFin){
                for l in ligneDepart...ligneFin{
                    for c in colonneDepart...colonneFin{
                        if grilleJoueur[l][c] != "X"{
                            return false
                        }
                    }
                }
            }
        }
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        remainingTouches = compteur
        // Appel de la fonction attaquer avec l'ensemble de touches reçu en paramètre
        if estTourJoueur1{
            // Appel de la fonction attaquer et sauvegarde de l'avancement de la grille
            attaquer(grilleJoueur : &grilleJoueur1tab, positionGrilleJoueur : &positionGrilleJoueur1, nbObjetsAbbatus : &nbObjetsAbbatusJ1, compteur : self.compteur,compteurLabelJoueur: compteurLabelJoueur1, touches: touches)
            UserDefaults.standard.set(grilleJoueur1tab, forKey: "grilleJoueur1tab")
            UserDefaults.standard.synchronize() // Pour que le sauvegarde est fait immediatement

        }else {
            // Appel de la fonction attaquer et sauvegarde de l'avancement de la grille
            attaquer(grilleJoueur : &grilleJoueur2tab, positionGrilleJoueur : &positionGrilleJoueur2, nbObjetsAbbatus : &nbObjetsAbbatusJ1, compteur : self.compteur,compteurLabelJoueur: compteurLabelJoueur2, touches: touches)
            UserDefaults.standard.set(grilleJoueur2tab, forKey: "grilleJoueur2tab")
            UserDefaults.standard.synchronize() // Pour que le sauvegarde est fait immediatement

        }
    }
    
    // Recuperer la case que le joueur veut attaquer
    func attaquerCase(_ touches: Set<UITouch>) -> (Int,Int){
        let touch = touches.randomElement()!
        let touchLocation = touch.location(in: view)
        
        // rendre coordonée X un multiple de 50
        var x = (((Int(touchLocation.x) - 25) / 50) * 50)
        
        // rendre coordonée Y un multiple de 50
        var y = (((Int(touchLocation.y) - 200) / 50) * 50)
        
        //Diviser par 50 pour avoir la ligne et la colonne
        x = (x / 50)
        y = (y / 50)
        
        return (y,x)
    }
    
    // Fonction qui gère la partie de l'attaque pour chaque joueur
    func attaquer(grilleJoueur : inout [[String]], positionGrilleJoueur : inout [[Int]], nbObjetsAbbatus : inout Int,compteur :  Int,compteurLabelJoueur : UILabel, touches: Set<UITouch>){
        guard compteur > 0 else {
                // Si compteur est <= 0, la fonction ne fait rien
                return
            }
        // Réduire le compteur de touches restantes afin d'empecher à un joueur d'attaquer s'il n'a plus de bombes
            remainingTouches -= 1
        if remainingTouches >= 0 {
            compteurLabelJoueur.text = "Nombre de bombes : \(remainingTouches)" // Changement affichage nombre de bombes
        
            var ligne : Int = -1
            var colonne : Int = -1
            
            // Fonction qui permet à l'utilisateur de choisir une case à attaquer et qui return la ligne et la colonne de la case choisie
            let (l, c) = attaquerCase(touches)
            ligne = l
            colonne = c
            
            // Si aucun objet placé sur cette case
            if grilleJoueur[ligne][colonne] == "."{
                print("case vide")
                grilleJoueur[ligne][colonne] = "#" // On change la case avec # pour savoir que la case a été attaquée et la rendre inattaquable une autre fois
                
                // Afficher l'alert
                let alert = UIAlertController(title: "Attaque échoué", message: "Case vide, aucun objet n'a été touché", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        self.compteur -= 1 // Diminuer compteur
                        self.changementJoueur(compteur: self.compteur) // Changer de joueur donc de vue
                        UserDefaults.standard.set(self.compteur, forKey: "compteurValue") // Sauvegarde changements compteur
                        UserDefaults.standard.synchronize()

                }))
                self.present(alert, animated: true, completion: nil) // Affichage alert
            }else if grilleJoueur[ligne][colonne] == "O"{ // Si objet placé
                grilleJoueur[ligne][colonne] = "X" // On change la case avec X pour savoir que la case a été attaquée et la rendre inattaquable une autre fois
                if self.verifObjetAbbatu(ligne: ligne,colonne: colonne, positionGrilleJoueur: positionGrilleJoueur, grilleJoueur: grilleJoueur){ //Si objet abbatu
                    nbObjetsAbbatus += 1 // Augmenter compteur objets abbatus
                    verifGameOver(nbObjetsAbbatus: nbObjetsAbbatus) // Verifier si la partie est finie
                
                    // Alert objet détrui
                    let alert = UIAlertController(title: "Objet détrui!", message: "Un objet a été détrui.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {_ in
                    self.compteur -= 1 // Diminuer compteur
                    UserDefaults.standard.set(self.compteur, forKey: "compteurValue") // Sauvegarde changements compteur
                    self.changementJoueur(compteur: self.compteur) // Cahnger joueur
                    UserDefaults.standard.synchronize()
                    }))
                    self.present(alert, animated: true, completion: nil) // Affichage alert
                }else{ // Objet touché mais pas détruit
                    let alert = UIAlertController(title: "Attaque réussi!", message: "Bingo, tu as touché un objet!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {_ in
                    self.compteur -= 1 // Diminuer compteur
                    UserDefaults.standard.set(self.compteur, forKey: "compteurValue") // Sauvegarde changements compteur
                    self.changementJoueur(compteur: self.compteur) // Cahnger joueur
                    UserDefaults.standard.synchronize()
                    
                }))
                // Afficher les alert
                self.present(alert, animated: true, completion: nil)
                }
            }

        }
    }
    
     func verifGameOver(nbObjetsAbbatus : Int){
        if nbObjets == nbObjetsAbbatus{ // Si tous les objets abbatus
            gameOver = true //game over devient true
            
            // Affichage alert de congratulations
            let alert = UIAlertController(title: "Game Over", message: "Tu as gagné!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Revenir à l'accueil", comment: "Default action"), style: .default, handler: {_ in
                // Retour à l'écran d'accueil
                if let accueil = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "entreeApp") as? UIViewController {
                            self.navigationController?.pushViewController(accueil, animated: true)

                }
            }))
            
            // Affichage alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        /*compteur = UserDefaults.standard.integer(forKey: "compteurValue")*/
        /*print("ciao \(nomJoueur1 ?? "")")
        print("ciao \(nomJoueur2 ?? "")")*/
        
        // Modification du label joueur 1 et joueur 2 si ils ont inséré leur noms ou pas
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
        
        
        // Print des grilles. ça sera plus facile suivre le jeu
        print("grille j1")
            for ligne in grilleJoueur1tab {
                let ligneString = ligne.joined(separator: " ") // Convertir la ligne en une chaîne en joignant ses éléments avec un espace
                print(ligneString)
            }
        
            for ligne in positionGrilleJoueur1 {
                let ligneString = ligne.map { String($0) }.joined(separator: " ")
                print(ligneString)
            }
        print("grille j2")
            for ligne in grilleJoueur2tab {
                let ligneString = ligne.joined(separator: " ") // Convertir la ligne en une chaîne en joignant ses éléments avec un espace
                print(ligneString)
            }
            for ligne in positionGrilleJoueur2 {
                let ligneString = ligne.map { String($0) }.joined(separator: " ") // Convertir la ligne en une chaîne en joignant ses éléments avec un espace
                print(ligneString)
            }
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
