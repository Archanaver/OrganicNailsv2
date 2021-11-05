//
//  LogInControlador.swift
//  OrganicNails
//
//  Created by user189475 on 11/5/21.
//

import Foundation
import Firebase

class LogInControlador{
    typealias finishedLogging = () -> ()
    /*
    func logging(completed : finishedLogging,email : UITextField, contra : UITextField, errorLabel : UILabel ){
        let correo = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = contra.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        
        Auth.auth().signIn(withEmail: correo, password: password) { (result, error) in
            if error != nil {
                let alerta =  UIAlertController(title: "Error de conexion", message:"No existen usuarios con esas credenciales", preferredStyle: .alert)
               alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
               self.present(alerta, animated: true, completion: nil)
            }
            else{
                completed()
            }
        
    }*/
    func isLogged(email : UITextField, contra : UITextField, errorLabel : UILabel, completion: @escaping (Result<String,Error>)->Void){
    let correo = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    let password = contra.text!.trimmingCharacters(in: .whitespacesAndNewlines)

    
    Auth.auth().signIn(withEmail: correo, password: password) { (result, error) in
        if error != nil {
            errorLabel.text = error!.localizedDescription
            completion(.failure(error!))
        }
        else{
            completion(.success("chido"))
        }
    }
}
}
