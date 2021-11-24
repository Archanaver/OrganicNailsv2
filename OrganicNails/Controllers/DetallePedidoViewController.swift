//
//  DetallePedidoViewController.swift
//  OrganicNails
//
//  Created by Archana Verma on 11/23/21.
//

import UIKit

class DetallePedidoViewController: UIViewController {
    var total:Float = 0
    var ahorro:Float = 0
    var envio:Float = 0
    
    let pedidoControllador = PedidoControlador()

    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var envioLabel: UILabel!
    @IBOutlet weak var ahorroLabel: UILabel!
    @IBOutlet weak var totalCompletoLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(total, ahorro)
        
        totalLabel.text = "Costo de productos/cursos: $" + String( format: "%.2f",total)
        envioLabel.text = "Costo de envío: $" + String( format: "%.2f",envio)
        if ahorro != 0 {
            ahorroLabel.isHidden = false
            ahorroLabel.text = "Ahorro: $" + String( format: "%.2f",ahorro)
            
        }
        
        let totalCompleto = total + envio
        totalCompletoLabel.text = "Total: $" + String( format:"%.2f", totalCompleto)
       
          

        // Do any additional setup after loading the view.
    }
    
    @IBAction func comprarButton(_ sender: Any) {
        pedidoControllador.checarCarrito(){
                (resultado) in
                      switch resultado{
                      case .success(let exito):print(exito)
                        self.pedidoControllador.updatePedidoCompraHecha(idPedido: exito){
                            (resultado) in
                                  switch resultado{
                                  case .success(let exito):self.displayExito(exito: exito)
                                  case .failure(let error):print(error)
                                  }
                        
                        }
                      case .failure(let error): print(error)
                      }
        }
    }
    
    
    func displayExito(exito:String){
        DispatchQueue.main.async {
            let alerta =  UIAlertController(title: "Compra realizada", message: exito, preferredStyle: .alert)
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
