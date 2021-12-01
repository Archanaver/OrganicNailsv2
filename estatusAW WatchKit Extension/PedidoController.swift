//
//  PedidoController.swift
//  estatusAW WatchKit Extension
//
//  Created by user189966 on 11/30/21.
//

import Foundation
import Firebase

class PedidoController {
    func fetchPedidos(completion: @escaping (Result<[Pedido], Error>)->Void) {
        var listaPedidos = [Pedido]()
        let ref = Database.database().reference()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String:
                Dictionary<String,String>] {
                let dic = data["Pedidos"]!
                for (k,v) in dic {
                    let p = Pedido(fecha:k, productos:v)
                    listaPedidos.append(p)
                }
                completion(.success(listaPedidos))
            }
        }){
            (error) in
            completion(.failure(error))
            print(error.localizedDescription)
        }
    }
}
