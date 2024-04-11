//
//  SelectPlayerController.swift
//  QuizzBoom
//
//  Created by Samy Chennoufi on 09/04/2024.
//

import UIKit

class SelectPlayerController: UIViewController {

    @IBOutlet var grilleJoueur1: [UIImageView]!
    

    @IBOutlet var grilleJoueur2: [UIImageView]!

    @IBOutlet weak var nomJoueur1Outlet: UITextField!
    @IBOutlet weak var nomJoueur2Outlet: UITextField!

    
    @IBOutlet var objetsOutlet: [UIImageView]!
    
    let tailleGrille: Int = 7
    let nbObjets: Int = 5
    
    var nomJoueur1: String = ""
    var nomJoueur2: String = ""
    var nbObjetsPlaces: Int = 0
    
    var objetTouche : Int = -1
    var pointDepart : CGPoint = CGPoint(x:0,y:0)
    
    @IBAction func validerGrilleJ1(_ sender: Any) {
        nomJoueur1 = nomJoueur1Outlet.text!
        print("joueur 1 : \(nomJoueur1)")
    }
    
    @IBAction func validerGrilleJ2(_ sender: Any) {
        nomJoueur2 = nomJoueur2Outlet.text!
        print("joueur 2 : \(nomJoueur2)")
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
                if objet.tag == 1{
                    print("Je suis une voiture")
                    objet.frame.size = CGSize(width: 50, height:150)
                }
                if objet.tag == 2{
                    print("Je suis un avion")
                    objet.frame.size = CGSize(width: 100, height:200)
                }
                if objet.tag == 3{
                    print("Je suis un tank")
                    objet.frame.size = CGSize(width: 100, height:250)
                }
                if objet.tag == 4{
                    print("Je suis un bateau")
                    objet.frame.size = CGSize(width: 50, height:300)
                }
                
                if objet.tag == 6{
                    print("Je suis une voiture")
                    objet.frame.size = CGSize(width: 150, height:50)
                }
                if objet.tag == 7{
                    print("Je suis un avion")
                    objet.frame.size = CGSize(width: 200, height:100)
                }
                if objet.tag == 8{
                    print("Je suis un tank")
                    objet.frame.size = CGSize(width: 250, height:100)
                }
                if objet.tag == 9{
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
        for objet in objetsOutlet {
                if objet.tag>=0 && objet.tag<=4 {
                    objet.frame.size = CGSize(width: 50, height:100)
                } else {
                    objet.frame.size = CGSize(width: 100, height:50)
                }
            }
        
        //replacer l'objet à l'endroit d'origine
        objetsOutlet[objetTouche].center = pointDepart
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        if objetTouche == -1 {
            return
        }
        retourAuDepart ()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
