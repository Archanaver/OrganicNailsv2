//
//  InterfaceController.swift
//  estatusAW WatchKit Extension
//
//  Created by user189966 on 11/19/21.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    
    @IBOutlet weak var laTabla: WKInterfaceTable!
    var datos = [Pedido]()
        var pedidoControlador = PedidoController()
    func updateGUI(listaPedidos: [Pedido]) {
           DispatchQueue.main.async {
               self.datos = listaPedidos
               self.laTabla.setNumberOfRows(self.datos.count, withRowType: "renglones")
               for indice in 0 ..< self.datos.count {
                   let elRenglon = self.laTabla.rowController(at:indice) as! ControladorRenglon
                   elRenglon.fecha.setText(self.datos[indice].fecha)
                   elRenglon.productos.setText(self.datos[indice].productos)
               }
           }
       }
       
       func displayError(e:Error) {
           DispatchQueue.main.async {
               print(e)
           }
       }
       
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        pedidoControlador.fetchPedidos { (resultado) in
                    switch resultado {
                    case .success(let listaPedidos):self.updateGUI(listaPedidos: listaPedidos)
                    case .failure(let error):self.displayError(e:error)
                    }
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

}
