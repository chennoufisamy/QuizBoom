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
    var compteur : Int = 0
    var nomJoueur1 = UserDefaults.standard.string(forKey: "nomJoueur1Value")
    var nomJoueur2 = UserDefaults.standard.string(forKey: "nomJoueur2Value")
    var nbObjetAbbatusJ1 : Int = 0
    var nbObjetAbbatusJ2 : Int = 0
    @IBOutlet weak var joueur1MessageLabel: UILabel!
    
    @IBOutlet weak var joueur2messageLabel: UILabel!
    
    @IBOutlet weak var compteurLabelJoueur1: UILabel!
    
    @IBOutlet weak var compteurLabelJoueur2: UILabel!
    var choixDifficulte : String = ""
    @IBAction func choixDifficulte(_ sender: UIButton) {
        compteur = 0
        if sender.tag == 0{
            choixDifficulte = "facile"
            compteur = 1
        }else if sender.tag == 1{
            choixDifficulte = "moyenne"
            compteur = 2
        }else{
            choixDifficulte = "difficile"
            compteur = 3
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
    
   /* func verifObjetAbbatu(_ : ligne, _ : colonne, _ : positionGrilleJoueur, _ : grilleJoueur) -> Bool {
        for position in positionGrilleJoueur{
            var debut_ligne = position[0]
            var fin_ligne = position[1]
            var debut_colonne = position[2]
            var fin_colonne = position[3]
            if debut_ligne <= ligne <= fin_ligne && debut_colonne <= colonne <= fin_colonne{
                for l in debut_ligne...fin_ligne{
                    for c in debut_colonne...fin_colonne{
                        if grilleJoueur[l][c] != "X"{
                            return false
                        }
                    }
                }
            }
        }
        return true
    }
    
    func attaquer(_ : grilleJoueur, _ : nbObjetsAbbatus, _: compteur ){
        
        var ligne : Int = -1
        var colonne : Int = -1
        while compteur > 0 {
            
            // fonction qui permet à l'utilisateur de choisir une case à attaquer et qui return la ligne et la colonne de la case choisie
            (ligne, colonne) = attaquerCase()
            
            /// Si aucun objet placé sur cette case
            if grilleJoueur[ligne][colonne] == "."{
                grilleJoueur[ligne][colonne] = "#"
                let alert = UIAlertController(title: "Attaque échoué", message: "Case vide, aucun objet n'a été touché", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {_ in }))
            }else if grilleJoueur[ligne][colonne] == "O"{ // Si objet placé
                grilleJoueur[ligne][colonne] = "X"
                let alert = UIAlertController(title: "Attaque réussi!", message: "Bingo, tu as touché un objet!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {_ in
                    if verifObjetAbbatu(ligne,colonne,positionGrilleJoueur,grilleJoueur){ //Si objet abbatu
                        let alert = UIAlertController(title: "Objet détrui!", message: "Un objet a été détrui.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {_ in}))
                        nbObjetAbbatus += 1
                    }
                }))
            }
            compteur -= 1
        }
        
    }
    
    func verifGameOver(_ : nbObjetsAbbatus){
        if nbObjets == nbObjetAbbatus{
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
    }*/
    override func viewDidLoad() {
        super.viewDidLoad()
        compteur = UserDefaults.standard.integer(forKey: "compteurValue")
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
/*
 Code avec la focntion qui crée des grilles, fonctions à remettre en Swift certainement grace à l'IA
 
 import random
 import time

 """
     -------BATTLESHIPS-------
     Pre-reqs: Loops, Strings, Arrays, 2D Arrays, Global Variables, Methods
     How it will work:
     1. A 10x10 grid will have 8 ships of variable length randomly placed about
     2. You will have 50 bullets to take down the ships that are placed down
     3. You can choose a row and column such as A3 to indicate where to shoot
     4. For every shot that hits or misses it will show up in the grid
     5. A ship cannot be placed diagonally, so if a shot hits the rest of
         the ship is in one of 4 directions, left, right, up, and down
     6. If all ships are unearthed before using up all bullets, you win
         else, you lose

     Legend:
     1. "." = water or empty space
     2. "O" = part of ship
     3. "X" = part of ship that was hit with bullet
     4. "#" = water that was shot with bullet, a miss because it hit no ship
 """

 # Global variable for grid
 grid = [[]]
 # Global variable for grid size
 grid_size = 10
 # Global variable for number of ships to place
 num_of_ships = 2
 # Global variable for bullets left
 bullets_left = 50
 # Global variable for game over
 game_over = False
 # Global variable for number of ships sunk
 num_of_ships_sunk = 0
 # Global variable for ship positions
 ship_positions = [[]]
 # Global variable for alphabet
 alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"


 def validate_grid_and_place_ship(start_row, end_row, start_col, end_col):
     """Will check the row or column to see if it is safe to place a ship there"""
     global grid
     global ship_positions

     all_valid = True
     for r in range(start_row, end_row):
         for c in range(start_col, end_col):
             if grid[r][c] != ".":
                 all_valid = False
                 break
     if all_valid:
         ship_positions.append([start_row, end_row, start_col, end_col])
         for r in range(start_row, end_row):
             for c in range(start_col, end_col):
                 grid[r][c] = "O"
     return all_valid


 def try_to_place_ship_on_grid(row, col, direction, length):
     """Based on direction will call helper method to try and place a ship on the grid"""
     global grid_size

     start_row, end_row, start_col, end_col = row, row + 1, col, col + 1
     if direction == "left":
         if col - length < 0:
             return False
         start_col = col - length + 1

     elif direction == "right":
         if col + length >= grid_size:
             return False
         end_col = col + length

     elif direction == "up":
         if row - length < 0:
             return False
         start_row = row - length + 1

     elif direction == "down":
         if row + length >= grid_size:
             return False
         end_row = row + length

     return validate_grid_and_place_ship(start_row, end_row, start_col, end_col)


 def create_grid():
     """Will create a 10x10 grid and randomly place down ships
        of different sizes in different directions"""
     global grid
     global grid_size
     global num_of_ships
     global ship_positions

     random.seed(time.time())

     rows, cols = (grid_size, grid_size)

     grid = []
     for r in range(rows):
         row = []
         for c in range(cols):
             row.append(".")
         grid.append(row)

     num_of_ships_placed = 0

     ship_positions = []

     while num_of_ships_placed != num_of_ships:
         random_row = random.randint(0, rows - 1)
         random_col = random.randint(0, cols - 1)
         direction = random.choice(["left", "right", "up", "down"])
         ship_size = random.randint(3, 5)
         if try_to_place_ship_on_grid(random_row, random_col, direction, ship_size):
             num_of_ships_placed += 1


 def print_grid():
     """Will print the grid with rows A-J and columns 0-9"""
     global grid
     global alphabet

     debug_mode = True

     alphabet = alphabet[0: len(grid) + 1]

     for row in range(len(grid)):
         print(alphabet[row], end=") ")
         for col in range(len(grid[row])):
             if grid[row][col] == "O":
                 if debug_mode:
                     print("O", end=" ")
                 else:
                     print(".", end=" ")
             else:
                 print(grid[row][col], end=" ")
         print("")

     print("  ", end=" ")
     for i in range(len(grid[0])):
         print(str(i), end=" ")
     print("")


 def accept_valid_bullet_placement():
     """Will get valid row and column to place bullet shot"""
     global alphabet
     global grid

     is_valid_placement = False
     row = -1
     col = -1
     while is_valid_placement is False:
         placement = input("Enter row (A-J) and column (0-9) such as A3: ")
         placement = placement.upper()
         if len(placement) <= 0 or len(placement) > 2:
             print("Error: Please enter only one row and column such as A3")
             continue
         row = placement[0]
         col = placement[1]
         if not row.isalpha() or not col.isnumeric():
             print("Error: Please enter letter (A-J) for row and (0-9) for column")
             continue
         row = alphabet.find(row)
         if not (-1 < row < grid_size):
             print("Error: Please enter letter (A-J) for row and (0-9) for column")
             continue
         col = int(col)
         if not (-1 < col < grid_size):
             print("Error: Please enter letter (A-J) for row and (0-9) for column")
             continue
         if grid[row][col] == "#" or grid[row][col] == "X":
             print("You have already shot a bullet here, pick somewhere else")
             continue
         if grid[row][col] == "." or grid[row][col] == "O":
             is_valid_placement = True

     return row, col


 def check_for_ship_sunk(row, col):
     """If all parts of a shit have been shot it is sunk and we later increment ships sunk"""
     global ship_positions
     global grid

     for position in ship_positions:
         start_row = position[0]
         end_row = position[1]
         start_col = position[2]
         end_col = position[3]
         if start_row <= row <= end_row and start_col <= col <= end_col:
             # Ship found, now check if its all sunk
             for r in range(start_row, end_row):
                 for c in range(start_col, end_col):
                     if grid[r][c] != "X":
                         return False
     return True


 def shoot_bullet():
     """Updates grid and ships based on where the bullet was shot"""
     global grid
     global num_of_ships_sunk
     global bullets_left

     row, col = accept_valid_bullet_placement()
     print("")
     print("----------------------------")

     if grid[row][col] == ".":
         print("You missed, no ship was shot")
         grid[row][col] = "#"
     elif grid[row][col] == "O":
         print("You hit!", end=" ")
         grid[row][col] = "X"
         if check_for_ship_sunk(row, col):
             print("A ship was completely sunk!")
             num_of_ships_sunk += 1
         else:
             print("A ship was shot")

     bullets_left -= 1


 def check_for_game_over():
     """If all ships have been sunk or we run out of bullets its game over"""
     global num_of_ships_sunk
     global num_of_ships
     global bullets_left
     global game_over

     if num_of_ships == num_of_ships_sunk:
         print("Congrats you won!")
         game_over = True
     elif bullets_left <= 0:
         print("Sorry, you lost! You ran out of bullets, try again next time!")
         game_over = True


 def main():
     """Main entry point of application that runs the game loop"""
     global game_over

     print("-----Welcome to Battleships-----")
     print("You have 50 bullets to take down 8 ships, may the battle begin!")

     create_grid()

     while game_over is False:
         print_grid()
         print("Number of ships remaining: " + str(num_of_ships - num_of_ships_sunk))
         print("Number of bullets left: " + str(bullets_left))
         shoot_bullet()
         print("----------------------------")
         print("")
         check_for_game_over()


 if __name__ == '__main__':
     """Will only be called when program is run from terminal or an IDE like PyCharms"""
     main()
 */
