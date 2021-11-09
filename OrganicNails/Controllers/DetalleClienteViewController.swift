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
  
    
    @IBOutlet weak var nombreLabel: UITextField!
    
    @IBOutlet weak var telefonoLabel: UITextField!
    
    @IBOutlet weak var cpLabel: UITextField!
    
    @IBOutlet weak var rfcLabel: UITextField!
    
    @IBAction func eliminarCuenta(_ sender: Any) {
        let userID = Auth.auth().currentUser!.uid
        clienteControlador.deleteCliente(uid:userID){
            (resultado) in
            switch resultado{
            case .success(let exito):self.displayExito(mensaje:"Cuenta eliminada",exito:exito)

            case .failure(let error):print(error)
            
            }
        }
        let siguienteVista = self.storyboard!.instantiateViewController(withIdentifier: "inicio") as! UIViewController
        siguienteVista.modalPresentationStyle = .fullScreen
        self.present(siguienteVista, animated: true, completion: nil)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        let userID = Auth.auth().currentUser!.uid
        
        clienteControlador.fetchCliente(uid: userID){
            (resultado) in
            switch resultado{
            case .success(let exito):self.getUsuario(clientes:exito)
                self.nombreLabel.text = exito[0].nombre
                self.telefonoLabel.text = exito[0].telefono
                self.cpLabel.text = exito[0].cp
                self.rfcLabel.text = exito[0].rfc
            case .failure(let error):print(error)
            
            }
        }
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        let userID = Auth.auth().currentUser!.uid
        
        clienteControlador.fetchCliente(uid: userID){
            (resultado) in
            switch resultado{
            case .success(let exito):self.getUsuario(clientes:exito)
                self.nombreLabel.text = exito[0].nombre
                self.telefonoLabel.text = exito[0].telefono
                self.cpLabel.text = exito[0].cp
                self.rfcLabel.text = exito[0].rfc
            case .failure(let error):print(error)
            
            }

        }


        
        
        
        
      /*  clienteControlador.getClienteData(uid : userID){
            (resultado) in
            switch resultado {
            case .success(let exito) :
                
                self.nombreLabel.text = self.getNombre(exito: exito)
          
            case .failure(let error): self.displayError(e: error)
            
            }
        }*/        //print(userID)
        
        
        // Do any additional setup after loading the view.
    

    

    

    }
    
    @IBAction func modificarCliente(_ sender: Any) {
       
        if validateFields(){
            let userID = Auth.auth().currentUser!.uid
            
            var cambiosCliente = Cliente(id: "", nombre: nombreLabel?.text ?? "", direccion:"" , cp: cpLabel?.text ?? "", telefono: telefonoLabel.text ?? "", rfc: rfcLabel?.text ?? "")
            clienteControlador.updateCliente(uid: userID,cliente: cambiosCliente){
                (resultado) in
                switch resultado{
                case .success(let exito):self.displayExito(mensaje: "Datos modificados", exito:exito)

                case .failure(let error):print(error)
                
                }

            }

            
        }
    }
    
    func displayExito(mensaje:String, exito:String)->String{
        DispatchQueue.main.async {
            let alerta =  UIAlertController(title: mensaje, message: exito, preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
            self.present(alerta, animated: true, completion: nil)
            
        }
        return exito
        
    }

    
    func validateFields() -> Bool{
      //Todas estan llenas
      if nombreLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || telefonoLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
        let alerta =  UIAlertController(title: "Error ", message:"Favor de llenar todos los espacios", preferredStyle: .alert)
       alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
       self.present(alerta, animated: true, completion: nil)
          return false
      }
        return true
      }

    
    
    
    
    
    func displayError(e:Error){
        DispatchQueue.main.async {
            let alerta =  UIAlertController(title: "Error al modificar", message: e.localizedDescription, preferredStyle: .alert)
            alerta.addAction(UIAlertAction(title: "Cerrar", style: .default, handler: nil))
            self.present(alerta, animated: true, completion: nil)
        }
        
    }
    
    func getUsuario(clientes:Clientes)->Clientes{
        DispatchQueue.main.async {
        }
        return clientes
    }
    
    func getIdUsuario(cliente:String)->String{
        DispatchQueue.main.async {
        }
        return cliente
    }


    
    
}
    


