//
//  MarcasViewController.swift
//  Squash
//
//  Created by Picho Man on 14/03/18.
//  Copyright © 2018 Picho Man. All rights reserved.
//

import UIKit

class MarcasViewController: UIViewController {
    
    
    @IBOutlet weak var mejorMarca: UILabel!
    @IBOutlet weak var fechaMejor: UILabel!
    
    let puntos = ViewController()
    let fecha = Date()
    
    func guadraMejor() {
        
        //let fecha =
        self.mejorMarca.text = String(self.puntos.score)
    }
    
    
    
    
    
    
    
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
