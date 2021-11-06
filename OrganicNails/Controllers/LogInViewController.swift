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
      

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
    }
    
    func logging(completed : finishedLogging){
        let correo = correoTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = contraTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        
        Auth.auth().signIn(withEmail: correo, password: password) { (result, error) in
            if error != nil {
                let alerta =  UIAlertController(title: "Error de conexion", message:"No existen usuarios con esas credenciales", preferredStyle: .alert)
               alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
               self.present(alerta, animated: true, completion: nil)
            }
            else{
                
            }
        
    }
        completed()
    }
        
    @IBAction func iniciandoSesion(_ sender: Any) {
        let error = validateFields()
        if error != nil {
            let alerta =  UIAlertController(title: "Error de conexion", message: "Llena todos espacios", preferredStyle: .alert)
           alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
           self.present(alerta, animated: true, completion: nil)
            print("hay un error al crear una cuenta")
            
           
        }else {
            logging {() -> () in
                print("aaaaaaaaaaaaaaaaaa")
            }
        }
    }
    
    
    func displayError(e:Error){
        DispatchQueue.main.async {
             let alerta =  UIAlertController(title: "Error de conexion", message: e.localizedDescription, preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
            self.present(alerta, animated: true, completion: nil)
        }
    }
    
    func displayExito(exito:String){
        DispatchQueue.main.async {
            self.errorLabel.text = "Todo bien"
        }
        
    }

    
    /*func checarCarritoActivo(completion: @escaping (Result<String,Error>)->Void){
     db.collection("pedidos").whereField("activo", isEqualTo: true)
       .getDocuments() { (querySnapshot, err) in
         if let err = err {
             print("Error obteniendo pedido activo: \(err)")
             completion(.failure(err))
         } else {
             var documentoID:String = ""
             for document in querySnapshot!.documents {
                 print("\(document.documentID) => \(document.data())")
                 documentoID = document.documentID
             }
             completion(.success(documentoID))
             
         }
     }*/
}




