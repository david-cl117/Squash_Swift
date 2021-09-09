//
//  MenuViewController.swift
//  Squash
//
//  Created by Picho Man on 03/03/18.
//  Copyright © 2018 Picho Man. All rights reserved.
//

import UIKit
import AVFoundation

class MenuViewController: UIViewController, AVAudioPlayerDelegate {
    
    //Para reproducir cancion.
    var player: AVAudioPlayer = AVAudioPlayer()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Cargar cancion.
        do {
            let audioPlayer = Bundle.main.path(forResource: "cancion", ofType: "mp3")
            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPlayer!) as URL)
        }
            
        catch {
            //ERROR
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        player.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        player.stop()
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
