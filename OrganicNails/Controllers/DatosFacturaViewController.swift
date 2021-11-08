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
    
    @IBOutlet weak var nombreTextField: UITextField!
    
    @IBOutlet weak var paisTextField: UITextField!
    @IBOutlet weak var estadoTextField: UITextField!
    @IBOutlet weak var delegacionTextField: UITextField!
    @IBOutlet weak var cpTextField: UITextField!
    @IBOutlet weak var coloniaTextField: UITextField!
    @IBOutlet weak var calleTextField: UITextField!
    @IBOutlet weak var frcTextField: UITextField!
    
    let facturaControlador = FacturaControlador()
    override func viewDidLoad() {
        super.viewDidLoad()
        let userID = Auth.auth().currentUser!.uid
        
        //checar si existe factura
        var facturaID:String = ""
        facturaControlador.checarFacturaExistente(uid: userID){
            (resultado) in
            switch resultado{
            case .success(let exito):facturaID = self.getIdFactura(id: exito)
                if facturaID.count != 0 {
                    print("leer factura")
                    //leer factura
                    self.facturaControlador.fetchFactura(uid: userID){
                        (resultado) in
                            switch resultado{
                        case .success(let exito):self.getFactura(facturas:exito)
                            self.nombreTextField.text = exito[0].nombre ?? ""
                            self.paisTextField.text = exito[0].pais
                            self.estadoTextField.text = exito[0].estado
                            self.delegacionTextField.text = exito[0].delegacion
                            self.cpTextField.text = exito[0].cp
                            self.coloniaTextField.text = exito[0].colonia
                            self.calleTextField.text = exito[0].calle
                            self.frcTextField.text = exito[0].rfc
                        case .failure(let error):print(error)
                            }}
                }else{
                    //crear factura
                    print("nueva factura")
                    var nuevaFactura = Factura(id_cliente: userID)
                    self.facturaControlador.crearFactura(nuevaFactura: nuevaFactura ){
                        (resultado) in
                        switch resultado{
                        case .success(let exito):print(exito)
                        case .failure(let error):print( error)
                        }
                        
                    }
                }
            case .failure(let error):print("No se pudo encontrar la factura ",error)
            }

        }
        
    }
    
    func getFactura(facturas:Facturas)->Facturas{
        DispatchQueue.main.async {
        }
        return facturas
    }
        
    func getIdFactura(id:String)->String{
        DispatchQueue.main.async {
        }
        return id
    }
        
        
    @IBAction func guardarButton(_ sender: Any) {
        print("hola")
        
    /*    let clienteActualizado = Cliente(id: auth.currentUser?.uid ?? "", nombre: cliente!.nombre, direccion: cliente!.direccion, cp: cpTextField.text!, telefono: cliente!.telefono, rfc: rfcTextField.text!)
        controladorCliente.updateClienteFactura(clienteActualizar: clienteActualizado){ (resultado) in
            switch resultado{
            case .failure(let err): self.displayError(e: err)
                
            case .success(let exito): self.displayExito(exito: exito)
            }
        }*/
        
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
