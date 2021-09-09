//
//  ViewController.swift
//  Squash
//
//  Created by Picho Man on 28/02/18.
//  Copyright © 2018 Picho Man. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollisionBehaviorDelegate, AVAudioPlayerDelegate {
    
    //Raquetas
    @IBOutlet weak var raqueta1: UIView!
    @IBOutlet weak var raqueta2: UIView!
    
    //paredes
    @IBOutlet weak var paredIzquierda: UIView!
    @IBOutlet weak var paredDerecha: UIView!
    
    //pelota
    @IBOutlet weak var pelotita: UIView!
    
    //Label de score.
    @IBOutlet weak var puntos: UILabel!
    
    //vistas
    var obs, obs2, obs3: UIView!
    
    //Para utilizar el modulo de obstaculos.
    let obstac = obstacles()
    
    //Para reproducir sonido.
    var player: AVAudioPlayer = AVAudioPlayer()
    
    
    //para las animaciones y propiedades.
    var animador : UIDynamicAnimator!
    var gravedad : UIGravityBehavior! //Se caen los items (labels)
    var colision : UICollisionBehavior! //items colisionan
    var propiedadesAnimacion : UIDynamicItemBehavior! //Cambiar propiedades de items
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.animador = UIDynamicAnimator(referenceView: self.view)
        self.colision = UICollisionBehavior()
        //Campo Gravitacional(Animacion)
        self.gravedad = UIGravityBehavior()

        
        //Añadimos una barrera invisible en la raqueta1.
        //barrera central.
        self.colision.addBoundary(withIdentifier: "raq1center" as NSString, from: CGPoint(x: self.raqueta1.frame.midX-15, y: self.raqueta1.frame.minY), to: CGPoint(x: self.raqueta1.frame.midX+15, y: self.raqueta1.frame.minY))
        
        //barrera izquierda
        self.colision.addBoundary(withIdentifier: "raq1izq" as NSString, from: CGPoint(x: self.raqueta1.frame.minX, y: self.raqueta1.frame.minY), to: CGPoint(x: self.raqueta1.frame.minX+29, y: self.raqueta1.frame.minY))
        
        //Barrera derecha
        self.colision.addBoundary(withIdentifier: "raq1der" as NSString, from: CGPoint(x: self.raqueta1.frame.maxX-29, y: self.raqueta1.frame.minY), to: CGPoint(x: self.raqueta1.frame.maxX, y: self.raqueta1.frame.minY))
        
        
        //Añadimos una barrera invisible en la raqueta2.
        //barrera central.
        self.colision.addBoundary(withIdentifier: "raq2center" as NSString, from: CGPoint(x: self.raqueta2.frame.midX-15, y: self.raqueta2.frame.maxY), to: CGPoint(x: self.raqueta2.frame.midX+15, y: self.raqueta2.frame.maxY))
        
        //barrera izquierda
        self.colision.addBoundary(withIdentifier: "raq2izq" as NSString, from: CGPoint(x: self.raqueta2.frame.minX, y: self.raqueta2.frame.maxY), to: CGPoint(x: self.raqueta2.frame.minX+29, y: self.raqueta2.frame.maxY))
        
        //Barrera derecha
        self.colision.addBoundary(withIdentifier: "raq2der" as NSString, from: CGPoint(x: self.raqueta2.frame.maxX-29, y: self.raqueta2.frame.minY), to: CGPoint(x: self.raqueta2.frame.maxX, y: self.raqueta2.frame.maxY))
        
 
        
        //añadimos una barrera invisible en la pared izq
        self.colision.addBoundary(withIdentifier: "izq" as NSString, for: UIBezierPath(rect: self.paredIzquierda.frame))
        
        //añadimos una barrera invisible en la pared der
        self.colision.addBoundary(withIdentifier: "der" as NSString, for: UIBezierPath(rect: self.paredDerecha.frame))
        
        //Añadimos una barrera invisible en la paredde arriba
        self.colision.addBoundary(withIdentifier: "arriba" as NSString, from: CGPoint(x: self.view.bounds.minX , y: self.view.bounds.maxY), to: CGPoint(x: self.view.bounds.maxX, y: self.view.bounds.maxY))
        
        //añadimos una barrera invisible en la pared de abajo
        self.colision.addBoundary(withIdentifier: "abajo" as NSString, from: CGPoint(x: self.view.bounds.minX , y: self.view.bounds.minY), to: CGPoint(x: self.view.bounds.maxX, y: self.view.bounds.minY))
       
    
        
        self.colision.collisionDelegate = self
        
        
        self.propiedadesAnimacion = UIDynamicItemBehavior()
        self.propiedadesAnimacion.elasticity = 0.5
        
        self.animador.addBehavior(propiedadesAnimacion)
        self.animador.addBehavior(self.gravedad)
        self.animador.addBehavior(self.colision)
        // Do any additional setup after loading the view.
        
        //Cargar sonido.
        do {
            let audioPlayer = Bundle.main.path(forResource: "ball", ofType: "mp3")
            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPlayer!) as URL)
        }
        
        catch {
            //ERROR
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func drag(_ sender: UIPanGestureRecognizer) {
        
        let traslado = sender.translation(in: self.view)
        
        //removemos el boundaries raqu1
        self.colision.removeBoundary(withIdentifier: "raq1center" as NSString)
        self.colision.removeBoundary(withIdentifier: "raq1izq" as NSString)
        self.colision.removeBoundary(withIdentifier: "raq1der" as NSString)
        
        //removemos el boundaries raqu2
        self.colision.removeBoundary(withIdentifier: "raq2center" as NSString)
        self.colision.removeBoundary(withIdentifier: "raq2izq" as NSString)
        self.colision.removeBoundary(withIdentifier: "raq2der" as NSString)
       
        //Movemos raquetas y actualizamos sus centros
        raqueta1.center = CGPoint(x: raqueta1.center.x + (traslado.x), y: raqueta1.center.y)
            
        raqueta2.center = CGPoint(x: raqueta2.center.x + traslado.x, y: raqueta2.center.y)
        
        //Actualizamos el centro
        sender.setTranslation(CGPoint.zero, in: raqueta1)
        
        
        //Añadimos una barrera invisible en la raqueta1.
        //barrera central.
        self.colision.addBoundary(withIdentifier: "raq1center" as NSString, from: CGPoint(x: self.raqueta1.frame.midX-15, y: self.raqueta1.frame.minY), to: CGPoint(x: self.raqueta1.frame.midX+15, y: self.raqueta1.frame.minY))
        
        //barrera izquierda
        self.colision.addBoundary(withIdentifier: "raq1izq" as NSString, from: CGPoint(x: self.raqueta1.frame.minX, y: self.raqueta1.frame.minY), to: CGPoint(x: self.raqueta1.frame.minX+29, y: self.raqueta1.frame.minY))
        
        //Barrera derecha
        self.colision.addBoundary(withIdentifier: "raq1der" as NSString, from: CGPoint(x: self.raqueta1.frame.maxX-29, y: self.raqueta1.frame.minY), to: CGPoint(x: self.raqueta1.frame.maxX, y: self.raqueta1.frame.minY))
        
       
        //Añadimos una barrera invisible en la raqueta2.
        //barrera central.
        self.colision.addBoundary(withIdentifier: "raq2center" as NSString, from: CGPoint(x: self.raqueta2.frame.midX-15, y: self.raqueta2.frame.maxY), to: CGPoint(x: self.raqueta2.frame.midX+15, y: self.raqueta2.frame.maxY))
        
        //barrera izquierda
        self.colision.addBoundary(withIdentifier: "raq2izq" as NSString, from: CGPoint(x: self.raqueta2.frame.minX, y: self.raqueta2.frame.maxY), to: CGPoint(x: self.raqueta2.frame.minX+29, y: self.raqueta2.frame.maxY))
        
        //Barrera derecha
        self.colision.addBoundary(withIdentifier: "raq2der" as NSString, from: CGPoint(x: self.raqueta2.frame.maxX-29, y: self.raqueta2.frame.maxY), to: CGPoint(x: self.raqueta2.frame.maxX, y: self.raqueta2.frame.maxY))
    
      
     
        //Validacion para que las raquetas no pasen de los bordes
        //Para borde derecho
        if self.raqueta1.center.x >= self.view.bounds.maxX-self.raqueta1.bounds.width/2 {
            
            self.raqueta1.center.x = self.view.bounds.maxX-self.raqueta1.bounds.width/2
            self.raqueta2.center.x = self.view.bounds.maxX-self.raqueta2.bounds.width/2
        }
        
            //para borde izquierdo
        else if self.raqueta1.center.x <= self.view.bounds.minX+self.raqueta1.bounds.width/2 {
            
            self.raqueta1.center.x = self.view.bounds.minX+self.raqueta1.bounds.width/2
            self.raqueta2.center.x = self.view.bounds.minX+self.raqueta2.bounds.width/2
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Hacer aparecer la pelota
        UIView.animate(withDuration: 3.0,
                       animations: {
                        self.pelotita.alpha = 1.0
                        },
                       completion: {
                        finalizo in
            
                        self.gravedad.addItem(self.pelotita)
                        self.colision.addItem(self.pelotita)
                        self.propiedadesAnimacion.addItem(self.pelotita)
                        
        })
        print(self.pelotita.center)
    }
    

    var score = 0 //Variable de score
    var cont = 0
    
    //Funcion que nos indica cuando hubo una colision. Modificamos el comportaiento de la gravedad.
    func collisionBehavior(_ behavior: UICollisionBehavior, endedContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?) {
        
      
        //Esta funcion se ejecuta cada vez que haya una colision.
        
        let elementoColision = identifier as! String
        
        print("COLISION!")
        
        player.play()
    
        
        if (elementoColision == "raq1center") {
            
            //Incrementamos score en uno
            self.score += 1
            
            //Ponemos el score en el label
            self.puntos.text = String(score)
            
            //Invertimos la gravedad cada vez que se ejecuta la funcion
            self.gravedad.gravityDirection = CGVector(dx:0.0, dy:-0.3)
        }
            
        else if elementoColision == "raq1izq" {
            //Incrementamos score en uno
            self.score += 1
            
            //Ponemos el score en el label
            self.puntos.text = String(score)
            
            //Invertimos la gravedad cada vez que se ejecuta la funcion
            self.gravedad.gravityDirection = CGVector(dx:-0.4, dy:-0.3)
            
        }
            
        else if elementoColision == "raq1der" {
            //Incrementamos score en uno
            self.score += 1
            
            //Ponemos el score en el label
            self.puntos.text = String(score)
            
            //Invertimos la gravedad cada vez que se ejecuta la funcion
            self.gravedad.gravityDirection = CGVector(dx:0.4, dy:-0.3)
        }
            
        else if elementoColision == "raq2center" {
            //Incrementamos score en uno
            self.score += 1
            
            //Ponemos el score en el label
            self.puntos.text = String(score)
            
            //Invertimos la gravedad cada vez que se ejecuta la funcion
            self.gravedad.gravityDirection = CGVector(dx:0.0, dy:0.3)
            
        }
            
        else if elementoColision == "raq2izq" {
            //Incrementamos score en uno
            self.score += 1
            
            //Ponemos el score en el label
            self.puntos.text = String(score)
            
            //Invertimos la gravedad cada vez que se ejecuta la funcion
            self.gravedad.gravityDirection = CGVector(dx:-0.4, dy:0.3)
        }
            
        else if elementoColision == "raq2der" {
            //Incrementamos score en uno
            self.score += 1
            
            //Ponemos el score en el label
            self.puntos.text = String(score)
            
            //Invertimos la gravedad cada vez que se ejecuta la funcion
            self.gravedad.gravityDirection = CGVector(dx:0.4, dy:0.3)
        }
            
            //Pared derecha
        else if elementoColision == "der" {
            
            if self.gravedad.gravityDirection == CGVector(dx: 0.4, dy: -0.3) {
                self.gravedad.gravityDirection = CGVector(dx: -0.4, dy: -0.3)
            }
            
            else if self.gravedad.gravityDirection == CGVector(dx: 0.4, dy: 0.3) {
                self.gravedad.gravityDirection = CGVector(dx: -0.4, dy: 0.3)
            }
        }
            
                //Pared izquierda
        else if elementoColision == "izq" {
                
            if self.gravedad.gravityDirection == CGVector(dx: -0.4, dy: -0.3) {
                self.gravedad.gravityDirection = CGVector(dx: 0.4, dy: -0.3)
            }
                    
            else if self.gravedad.gravityDirection == CGVector(dx: -0.4, dy: 0.3) {
                self.gravedad.gravityDirection = CGVector(dx: 0.4, dy: 0.3)
            }
        }

            //Si la pelota pasa los limites
        else if (elementoColision == "arriba") || (elementoColision == "abajo") {
            
            //quitamos la propiedad de colision a la pelota
            self.colision.removeItem(pelotita)
            
            
            //Alerta
            let alerta = UIAlertController(title: "¡Perdiste!", message: "Score partida: \(score)", preferredStyle: .alert)
            
            print("PERDISTE!")
            //Acion de la alerta
            let accion = UIAlertAction(title: "Ver marcadores", style: .cancel, handler: nil)
            alerta.addAction(accion)
            
            self.present(alerta, animated: true, completion: nil)
        }
        
        
        let randx = Int(arc4random_uniform(UInt32(self.view.bounds.maxX)))
        let randy = Int(arc4random_uniform(UInt32(self.view.bounds.maxY)))
        
        let rojo = Float(arc4random_uniform(100))/100
        let verde = Float(arc4random_uniform(100))/100
        let azul = Float(arc4random_uniform(100))/100
        
        if score%8 == 0 {
            self.pelotita.backgroundColor = UIColor(red: CGFloat(rojo), green: CGFloat(verde), blue: CGFloat(azul), alpha: 1.0)
        }
        
        
        else if score%10 == 0 {
            //Incrementamos contador en 1
            self.cont +=  1
            
            if self.cont == 1 { //obstaculo1
                //Creamos vista
                
                self.obs = UIView(frame: CGRect(x: randx-self.obstac.obstaculos1(), y: randy-10, width: self.obstac.obstaculos1(), height: 10))
                
                if self.obs.center.y <= self.view.bounds.minY+90 {
                    self.obs.center.y = self.view.bounds.minY+90
                }
                else if self.obs.center.y >= self.view.bounds.maxY-60 {
                    self.obs.center.y = self.view.bounds.maxY-60
                }
                //Agregamos boundary a la vista
                self.colision.addBoundary(withIdentifier: "obstacle" as NSString, from: CGPoint(x: self.obs.frame.minX, y: self.obs.frame.minY), to: CGPoint(x: self.obs.frame.maxX, y: self.obs.frame.maxY))
                
                self.obs.backgroundColor = .yellow
                self.view.addSubview(obs)//Agregamos subvista a la vista
            }
            
            else if self.cont == 2 { //Obstaculo2
                //Creamos vista
                self.obs2 = UIView(frame: CGRect(x: randx-self.obstac.obstaculo2(), y: randy-10, width: self.obstac.obstaculo2(), height: 10))
                
                if self.obs2.center.y <= self.view.bounds.minY+90 {
                    self.obs2.center.y = self.view.bounds.minY+90
                }
                else if self.obs2.center.y >= self.view.bounds.maxY-60 {
                    self.obs2.center.y = self.view.bounds.maxY-60
                }
                
                //Agregamos boundary a la vista
                self.colision.addBoundary(withIdentifier: "obstacle" as NSString, from: CGPoint(x: self.obs2.frame.minX, y: self.obs2.frame.minY), to: CGPoint(x: self.obs2.frame.maxX, y: self.obs2.frame.maxY))
                
                self.obs2.backgroundColor = .red
                self.view.addSubview(obs2)//Agregamos subvista a la vista
                
            }
            
            else if self.cont == 3 { //Obstaculo2
                
                self.cont = 0 //Reiniciamos contador
                //Creamos vista
                self.obs3 = UIView(frame: CGRect(x: randx-self.obstac.obstaculo3(), y: randy-10, width: self.obstac.obstaculo3(), height: 10))
                
                if self.obs3.center.y <= self.view.bounds.minY+90 {
                    self.obs3.center.y = self.view.bounds.minY+90
                }
                else if self.obs3.center.y >= self.view.bounds.maxY-60 {
                    self.obs3.center.y = self.view.bounds.maxY-60
                }
                
                //Agregamos boundary a la vista
                self.colision.addBoundary(withIdentifier: "obstacle" as NSString, from: CGPoint(x: self.obs3.frame.minX, y: self.obs3.frame.minY), to: CGPoint(x: self.obs3.frame.maxX, y: self.obs3.frame.maxY))
                
                self.obs3.backgroundColor = .blue
                self.view.addSubview(obs3)//Agregamos subvista a la vista
                
            }
            
        }
        
        _ = self.score
    }
    
    
   
    override func viewWillAppear(_ animated: Bool) {
        self.pelotita.alpha = 0.0
        

    }
    
}
