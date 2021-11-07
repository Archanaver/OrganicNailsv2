//
//  DetalleClienteViewController.swift
//  OrganicNails
//
//  Created by user189475 on 10/25/21.
//

import UIKit
import FirebaseAuth

class DetalleClienteViewController: UIViewController {
    
    let clienteControlador = ClienteControlador()
    let usuarioCliente = UsuarioControlador()
    
   
    var cliente:Cliente?
    
    @IBOutlet weak var nombreLabel: UILabel!
   
    override func viewDidLoad() {
        let userID = Auth.auth().currentUser!.uid
        super.viewDidLoad()
        
        clienteControlador.getClienteData(uid : userID){
            (resultado) in
            switch resultado {
            case .success(let exito) :
                
                self.nombreLabel.text = self.getNombre(exito: exito)
          
            case .failure(let error): self.displayError(e: error)
            
            }
        }        //print(userID)
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func updateCliente(_ sender: Any) {
        
    }
    func displayError(e:Error){
        DispatchQueue.main.async {
            let alerta =  UIAlertController(title: "Error al obtener el usuario", message: e.localizedDescription, preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
            self.present(alerta, animated: true, completion: nil)
        }
        
    }
    
    func getNombre(exito:String) -> String{
        DispatchQueue.main.async {
           
        }
        return exito
        
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
