//
//  SelectPlayerController.swift
//  QuizzBoom
//
//  Created by Samy Chennoufi on 09/04/2024.
//

import UIKit

class SelectPlayerController: UIViewController {

    var nomJoueur1: String = ""
    var nomJoueur2: String = ""
    @IBOutlet var grilleJoueur1: [UIImageView]!
    

    @IBOutlet var grilleJoueur2: [UIImageView]!

    @IBOutlet weak var nomJoueur1Outlet: UITextField!
    @IBOutlet weak var nomJoueur2Outlet: UITextField!

    
    @IBOutlet var objetsOutlet: [UIImageView]!
    
    var positionGrilleJoueur1 = [[Int]]()
    var positionGrilleJoueur2 = [[Int]]()
    var grilleJoueur1tab = [[String]]()
    var grilleJoueur2tab = [[String]]()
    var objetsPlacesJ1 : Int = 0
    var objetsPlacesJ2 : Int = 0
    let tailleGrille: Int = 7
    let nbObjets: Int = 5
    let grilleSize = CGSize(width: 350, height: 350) // Taille de la grille
    let caseSize = CGSize(width: 50, height: 50) // Taille d'une case de la grille
    //git est passé par là
    
    // pour quand on place 5 objets les autres deviennent hide
    var nbObjetsPlaces: Int = 0
    
    var objetTouche : Int = -1
    var pointDepart : CGPoint = CGPoint(x:0,y:0)
    
    @IBAction func validerGrilleJ1(_ sender: UIButton) {
        nomJoueur1 = nomJoueur1Outlet.text!
        print("joueur 1 : \(nomJoueur1)")
        UserDefaults.standard.set(nomJoueur1, forKey: "nomJoueur1Value")
    }
    
    @IBAction func validerGrilleJ2(_ sender: UIButton) {
        nomJoueur2 = nomJoueur2Outlet.text!
        print("joueur 2 : \(nomJoueur2)")
        UserDefaults.standard.set(nomJoueur2, forKey: "nomJoueur2Value")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.randomElement()!
        let p = t.location(in: view)
        print("Vous avez touché l'écran en \(p.x), \(p.y)")
        var i = 0
        for objet in objetsOutlet {
            if objet.frame.contains(p) {
                print("Vous avez touché l'objet \(i)")
                objetTouche = i // on mémorise le numéro de l'objet touché
                pointDepart = objet.center // on mémorise sa position
                
                
                //Augmenter la taille des objets afin de pouvoir les mettre correctement sur la grille
                if (objet.tag == 1) || (objet.tag == 11){
                    print("Je suis une voiture")
                    objet.frame.size = CGSize(width: 50, height:150)
                }
                if (objet.tag == 2) || (objet.tag == 12){
                    print("Je suis un avion")
                    objet.frame.size = CGSize(width: 100, height:200)
                }
                if (objet.tag == 3) || (objet.tag == 13){
                    print("Je suis un tank")
                    objet.frame.size = CGSize(width: 100, height:250)
                }
                if (objet.tag == 4) || (objet.tag == 14){
                    print("Je suis un bateau")
                    objet.frame.size = CGSize(width: 50, height:300)
                }
                
                if (objet.tag == 6) || (objet.tag == 16){
                    print("Je suis une voiture")
                    objet.frame.size = CGSize(width: 150, height:50)
                }
                if (objet.tag == 7) || (objet.tag == 17){
                    print("Je suis un avion")
                    objet.frame.size = CGSize(width: 200, height:100)
                }
                if (objet.tag == 8) || (objet.tag == 18){
                    print("Je suis un tank")
                    objet.frame.size = CGSize(width: 250, height:100)
                }
                if (objet.tag == 9) || (objet.tag == 19){
                    print("Je suis un bateau")
                    objet.frame.size = CGSize(width: 300, height:50)
                }
                return
            }

            i += 1
        }
        objetTouche = -1 // le doigt n'est pas dans un objet
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let t = touches.randomElement()!
        let p = t.location(in: view)
        if objetTouche != -1 {
            objetsOutlet[objetTouche].center = p // on place l'objet touché aux coordonnées du doigt
            }
        
        }
    
    func retourAuDepart () {
        // Quand on lache un objet, on le rend petit
                if (objetsOutlet[objetTouche].tag>=0 && objetsOutlet[objetTouche].tag<=4) || (objetsOutlet[objetTouche].tag>=10 && objetsOutlet[objetTouche].tag<=14) {
                    
                    objetsOutlet[objetTouche].frame.size = CGSize(width: 50, height:100)
                } else {
                    objetsOutlet[objetTouche].frame.size = CGSize(width: 100, height:50)
                }
        //replacer l'objet à l'endroit d'origine
        objetsOutlet[objetTouche].center = pointDepart
    }
    
    func creerGrille(grilleJoueur : inout[[String]]){
        
        for _ in 0...tailleGrille - 1{
            var ligne = [String]()
            for _ in 0...tailleGrille - 1{
                ligne.append(".")
            }
            grilleJoueur.append(ligne)
        }
    }
    
    
    func validerPlaceObjet(ligneDepart : Int,ligneFin : Int, colonneDepart : Int,colonneFin : Int, grilleJoueur : inout [[String]], positionGrilleJoueur : inout [[Int]]) -> Bool{
        
        var valide = true
        var sortieDuFor = false
        for l in ligneDepart...ligneFin{
            for c in colonneDepart...colonneFin{
                if grilleJoueur[l][c] != "." {
                    valide = false
                    sortieDuFor = true
                    break
                }
            }
            if sortieDuFor == true{
                break
            }
        }
        if valide == true{
            positionGrilleJoueur.append([ligneDepart,ligneFin,colonneDepart,colonneFin])
            for l in ligneDepart...ligneFin{
                for c in colonneDepart...colonneFin{
                    grilleJoueur[l][c] = "O"
                }
        }
    }
        return valide
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var ligneDepart = -1
        var ligneFin = -1
        var colonneDepart = -1
        var colonneFin = -1
        let touch = touches.randomElement()!
        let touchLocation = touch.location(in: view)
        if objetTouche == -1 {
            return
        }
        if (objetTouche != -1) && (touchLocation.x < 350) && (touchLocation.y < 500 && touchLocation.y > 200 ) && ((objetsOutlet[objetTouche].tag >= 0 && objetsOutlet[objetTouche].tag <= 4) || (objetsOutlet[objetTouche].tag>=10 && objetsOutlet[objetTouche].tag<=14)){
            
            print("calculs objet")
            //recuperer largeur objet et le diviser par 2
            let largeurObjet = objetsOutlet[objetTouche].frame.width / 2
            
            //recuperer hauteur objet et le diviser par 2
            let hauteurObjet = objetsOutlet[objetTouche].frame.height / 2
            
            // rendre coordonée X un multiple de 50
            var xCorrigee = (((Int(touchLocation.x) - 25) / 50) * 50) + 25 // loation - difference / 50 * 50 + diiference
            
            var yCorrigee = (((Int(touchLocation.y) - 200) / 50) * 50) + 200
            
            //Ajouter la moitié de la largeur de l'objet à la coordonnée X
            xCorrigee = xCorrigee + Int(largeurObjet)
            
            //Ajouter la moitié de l'hauteur de l'objet à la coordonnée Y
            yCorrigee = yCorrigee + Int(hauteurObjet)
            
            ligneDepart = ((yCorrigee - 200) / 50) - 1
            ligneFin = (((yCorrigee - 200) + Int(hauteurObjet)) / 50) - 1
            colonneDepart = (xCorrigee / 50) - 1
            colonneFin = (((xCorrigee - 50) + Int(largeurObjet) * 2) / 50) - 1
            
            print("x : \(xCorrigee), y : \(yCorrigee)")
            print("ligneDepart : \(ligneDepart), ligneFin : \(ligneFin)")
            print("colonneDepart : \(colonneDepart), colonneFin : \(colonneFin)")
            
            //Si on est sur la view du Joueur 1 et validerPlaceObjet == true
            if (self.restorationIdentifier == "1"){
                if (validerPlaceObjet(ligneDepart: ligneDepart, ligneFin: ligneFin, colonneDepart: colonneDepart, colonneFin: colonneFin, grilleJoueur: &grilleJoueur1tab, positionGrilleJoueur: &positionGrilleJoueur1) == true) {
                    //Placer l'objet
                    let casePosition = CGPoint(x: xCorrigee, y: yCorrigee)
                    objetsOutlet[objetTouche].center = casePosition
                }else { print("ne pas placer")
                    retourAuDepart() }
            }
            //Si on est sur la view du Joueur 2 et validerPlaceObjet == true
            else if (self.restorationIdentifier == "2"){
                
                if (validerPlaceObjet(ligneDepart: ligneDepart, ligneFin: ligneFin, colonneDepart: colonneDepart, colonneFin: colonneFin, grilleJoueur: &grilleJoueur2tab, positionGrilleJoueur: &positionGrilleJoueur2) == true) {
                    
                    //Placer l'objet
                    let casePosition = CGPoint(x: xCorrigee, y: yCorrigee)
                    objetsOutlet[objetTouche].center = casePosition
                }else {retourAuDepart() }
                
            }else {
                print("ne pas calculer")
                retourAuDepart() }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nomJoueur1 = UserDefaults.standard.string(forKey: "nomJoueur1Value") ?? ""
        nomJoueur2 = UserDefaults.standard.string(forKey: "nomJoueur2Value") ?? ""
        
        creerGrille(grilleJoueur : &grilleJoueur1tab)
        creerGrille(grilleJoueur : &grilleJoueur2tab)
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
