//
//  LogInViewController.swift
//  OrganicNails
//
//  Created by user189475 on 11/5/21.
//

import UIKit
import Firebase
import LocalAuthentication

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
        /*let button = UIButton(frame: CGRect (x: 0, y: 0,
        width: 200, height: 50))
        view.addSubview(button)
        button.center = view.center
        button.setTitle("Authorize",for:.normal)
        button.backgroundColor = .systemGreen
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        //logInButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)*/
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
                    /*let siguienteVista = self.storyboard!.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
                    siguienteVista.modalPresentationStyle = .overFullScreen
                    self.present(siguienteVista, animated: true, completion: nil)*/
                  self.didTapButton()
                }
            }
        }
    }
    
    @objc func didTapButton(){
        let context = LAContext()
        var error: NSError? = nil
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Favor de autorizar con Face ID"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){
                [weak self] succes, error in
                guard succes, error == nil else{
                    //fallo
                    let alert = UIAlertController(title: "Fallo de autenticación", message: "Favor de intentar de nuevo", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(alert, animated: true)
                    return
                }
                DispatchQueue.main.async {
                //Mostar otra pagina en caso de exito
                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc: ViewController = storyboard.instantiateViewController(withIdentifier: "pantallainicial") as! ViewController
                self!.present(vc, animated: true, completion: nil)
            }
            }
        }
        else{
            //no se puede utilizar
            let alert = UIAlertController(title: "No disponible", message: "No puedes usar esta herramienta", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
        }
}

    

}




