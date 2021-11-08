//
//  PerfilViewController.swift
//  OrganicNails
//
//  Created by Archana Verma on 11/7/21.
//

import UIKit
import Firebase

class PerfilViewController: UIViewController {
    let clienteControlador = ClienteControlador()
    
    @IBOutlet weak var nombreLabel: UILabel!
    
    
    @IBOutlet weak var direccionLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        let userID = Auth.auth().currentUser!.uid
        clienteControlador.fetchCliente(uid: userID){
            (resultado) in
            switch resultado{
            case .success(let exito):print(self.getIdUsuario(clientes:exito))
                self.nombreLabel.text = exito[0].nombre
                self.direccionLabel.text = exito[0].direccion
            case .failure(let error):print(error)
            
            }
        }

      }
      
    

    override func viewDidLoad() {
       /* super.viewDidLoad()
        let userID = Auth.auth().currentUser!.uid
        clienteControlador.fetchCliente(uid: userID){
            (resultado) in
            switch resultado{
            case .success(let exito):print(self.getIdUsuario(clientes:exito))
            case .failure(let error):print(error)
            
            }
        }*/

        // Do any additional setup after loading the view.
    }
    


    func getIdUsuario(clientes:Clientes)->Clientes{
        DispatchQueue.main.async {
        }
        return clientes
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
