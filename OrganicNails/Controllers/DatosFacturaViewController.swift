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
    
    @IBAction func eliminarFactura(_ sender: Any) {
        let userID = Auth.auth().currentUser!.uid
        facturaControlador.deleteFactura(uid: userID){
            (resultado) in
            switch resultado{
            case .success(let exito):self.displayExito(mensaje:"Datos de facturación eliminados",exito:exito)

            case .failure(let error):print(error)
            
            }
        }
        
        
    }
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
    
    func validateFields() -> Bool{
      //Todas estan llenas
      if nombreTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || paisTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || estadoTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || delegacionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || cpTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || coloniaTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || calleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || frcTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
        let alerta =  UIAlertController(title: "Error ", message:"Favor de llenar todos los espacios", preferredStyle: .alert)
       alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
       self.present(alerta, animated: true, completion: nil)
          return false
      }
        return true
      }
    
    func displayExito(mensaje:String, exito:String)->String{
         DispatchQueue.main.async {
             let alerta =  UIAlertController(title: mensaje, message: exito, preferredStyle: .alert)
             alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
             self.present(alerta, animated: true, completion: nil)
             
         }
         return exito
         
     }
        
        
    @IBAction func guardarButton(_ sender: Any) {
               if validateFields(){
                   let userID = Auth.auth().currentUser!.uid
                   var cambiosFactura = Factura(id_cliente: userID, nombre: nombreTextField?.text ?? "", rfc: frcTextField?.text ?? "", calle: calleTextField?.text ?? "", colonia: coloniaTextField?.text ?? "", cp: cpTextField?.text ?? "", delegacion: delegacionTextField?.text ?? "", estado: estadoTextField?.text ?? "", pais: paisTextField?.text ?? "")
                   print("holaaaa", cambiosFactura)
                   facturaControlador.updateFactura(uid:userID, factura:cambiosFactura){
                       (resultado) in
                       switch resultado{
                       case .success(let exito):self.displayExito(mensaje: "Datos de facturación modificados", exito:exito)

                       case .failure(let error):print(error)
                       
                   }
                       
                       
                       
               }
               
           /*    let clienteActualizado = Cliente(id: auth.currentUser?.uid ?? "", nombre: cliente!.nombre, direccion: cliente!.direccion, cp: cpTextField.text!, telefono: cliente!.telefono, rfc: rfcTextField.text!)
               controladorCliente.updateClienteFactura(clienteActualizar: clienteActualizado){ (resultado) in
                   switch resultado{
                   case .failure(let err): self.displayError(e: err)
                       
                   case .success(let exito): self.displayExito(exito: exito)
                   }
               }*/
               
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
