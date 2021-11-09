//
//  LogInViewController.swift
//  OrganicNails
//
//  Created by user189475 on 11/5/21.
//

import UIKit
import Firebase

class LogInViewController: UIViewController, UITextFieldDelegate    {
    
    @IBOutlet weak var correoTextField: UITextField!
    
    @IBOutlet weak var contraTextField: UITextField!
    
    @IBOutlet weak var logInButton: UIButton!
    
    @IBOutlet weak var contraOlvidadaButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    let logInControlador = LogInControlador()
    typealias finishedLogging = () -> ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.correoTextField.delegate = self
        self.contraTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        correoTextField.resignFirstResponder()
       
        contraTextField.resignFirstResponder()
       
        
        return(true)
    }
  
    func validateFields() -> String?{
      //Todas estan llenas
      if correoTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||  contraTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
        return "Llena todas los espacios"
      }
      // contra segura
      
      return nil
    }
    
    
        
    @IBAction func iniciandoSesion(_ sender: Any) {
        let error = validateFields()
        if error != nil {
             let alerta =  UIAlertController(title: "Error de conexion", message: "Llena todos los espacios", preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
            self.present(alerta, animated: true, completion: nil)
            
        }else {
            let email = correoTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let contra = contraTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().signIn(withEmail: email, password: contra) { (result, error) in
                if error != nil {
                    let alerta =  UIAlertController(title: "Error ", message: "Credenciales incorrectar", preferredStyle: .alert)
                   alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
                   self.present(alerta, animated: true, completion: nil)
                    
                }
                else{
                    let siguienteVista = self.storyboard!.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
                    siguienteVista.modalPresentationStyle = .overFullScreen
                    self.present(siguienteVista, animated: true, completion: nil)
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguiente = segue.destination as? ViewController
        print("USUARIOINICIOSESION", usuarioCurso)
        siguiente?.usuario = usuarioCurso
        
    }
    */

}




