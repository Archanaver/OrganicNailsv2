//
//  DatosFacturaViewController.swift
//  OrganicNails
//
//  Created by user189475 on 11/5/21.
//

import UIKit
import Firebase
import FirebaseAuth

class DatosFacturaViewController: UIViewController{
    
    var cliente:Cliente?
    var controladorCliente = ClienteControlador()
    let auth = Auth.auth()
    
    @IBOutlet weak var rfcTextField: UITextField!
    
    @IBOutlet weak var cpTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func guardarButton(_ sender: Any) {
        
        let clienteActualizado = Cliente(id: auth.currentUser?.uid ?? "", nombre: cliente!.nombre, direccion: cliente!.direccion, cp: cpTextField.text!, telefono: cliente!.telefono, rfc: rfcTextField.text!)
        controladorCliente.updateClienteFactura(clienteActualizar: clienteActualizado){ (resultado) in
            switch resultado{
            case .failure(let err): self.displayError(e: err)
                
            case .success(let exito): self.displayExito(exito: exito)
            }
        }
        
    }
    
    func displayError(e:Error){
        DispatchQueue.main.async {
            let alerta =  UIAlertController(title: "Error al actualizar", message: e.localizedDescription, preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
            self.present(alerta, animated: true, completion: nil)
        }
        
    }
    
    func displayExito(exito:String){
        DispatchQueue.main.async {
            let alerta =  UIAlertController(title: "Datos de factura guardados", message: exito, preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
            self.present(alerta, animated: true, completion: nil)
            
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
