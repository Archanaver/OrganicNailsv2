//
//  SignUpViewController.swift
//  OrganicNails
//
//  Created by user189475 on 11/5/21.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var correoTextField: UITextField!
    @IBOutlet weak var telefonoTextField: UITextField!
    @IBOutlet weak var contraTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nombreTextField.delegate = self
        self.correoTextField.delegate = self
        self.telefonoTextField.delegate = self
        self.contraTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nombreTextField.resignFirstResponder()
        correoTextField.resignFirstResponder()
        telefonoTextField.resignFirstResponder()
        contraTextField.resignFirstResponder()
        
        return(true)
    }
    
    func validateFields() -> String?{
      //Todas estan llenas
      if nombreTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || correoTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || telefonoTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || contraTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
        let alerta =  UIAlertController(title: "Error de conexion", message:"Llena todos los espacios", preferredStyle: .alert)
       alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
       self.present(alerta, animated: true, completion: nil)
          return "Llena todas los espacios"
      }
      // contra segura
      
      return nil
    }

    @IBAction func direccionAction(_ sender: Any) {
    }
    
    @IBAction func facturaAction(_ sender: Any) {
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        let error = validateFields()
        if error != nil {
            let alerta =  UIAlertController(title: "Error de conexion", message:"Algo salió mal", preferredStyle: .alert)
           alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
           self.present(alerta, animated: true, completion: nil)
             
        }else {
            //Datos sin white spaces
            let nombre = nombreTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let correo = correoTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let telefono = telefonoTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let contra = contraTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let direccion = ""
            Auth.auth().createUser(withEmail: correo, password: contra) { (result, err) in
                if err != nil {
                    let alerta =  UIAlertController(title: "Error de conexion", message:"Algo salió mal, verifica que la información sea correcta", preferredStyle: .alert)
                   alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
                   self.present(alerta, animated: true, completion: nil)
                }else{
                    //Storing
                    let db = Firestore.firestore()
                    db.collection("clientes").addDocument(data: ["nombre":nombre, "telefono":telefono,"direccion":direccion, "codigoPostal":"","rfc":"", "uid": result!.user.uid]) { (error) in
                        if error != nil{
                            let alerta =  UIAlertController(title: "Error de conexion", message:"Error al crear cuenta", preferredStyle: .alert)
                           alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
                           self.present(alerta, animated: true, completion: nil)
                        }else {
                            let siguienteVista = self.storyboard!.instantiateViewController(withIdentifier: "tabBar") as! UITabBarController
                            siguienteVista.modalPresentationStyle = .pageSheet
                            self.present(siguienteVista, animated: true, completion: nil)
                        }
                    }
                   
                }
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
}
