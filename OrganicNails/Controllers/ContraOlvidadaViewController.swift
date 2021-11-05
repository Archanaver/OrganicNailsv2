//
//  ContraOlvidadaViewController.swift
//  OrganicNails
//
//  Created by user189475 on 11/5/21.
//

import UIKit
import Firebase

class ContraOlvidadaViewController: UIViewController {

    @IBOutlet weak var correoTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func confirmarButton(_ sender: Any) {
        let auth = Auth.auth()
        auth.sendPasswordReset(withEmail: correoTextField.text!) { (error) in
            if  error != nil {
                let alerta =  UIAlertController(title: "Error de conexion", message: "Algo salió mal", preferredStyle: .alert)
               alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
               self.present(alerta, animated: true, completion: nil)
            }
            else{
                let alerta =  UIAlertController(title: "Correo enviado", message: "Revisa tu bandeja de entrada", preferredStyle: .alert)
               alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
               self.present(alerta, animated: true, completion: nil)
                
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
