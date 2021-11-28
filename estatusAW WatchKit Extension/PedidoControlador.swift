//
//  PedidoControlador.swift
//  estatusAW WatchKit Extension
//
//  Created by user189966 on 11/28/21.
//

import Foundation
import Firebase

class PedidoControlador {
    func fetchProductos(completion: @escaping (Result<[Pedido], Error>) ->Void) {
    var listaPedidos = [Pedido]()

    let ref = Database.database().reference()
    ref.observeSingleEvent(of: .value, with: { (snapshot) in
        if let data = snapshot.value as? [String:
            Dictionary<String,String>] {
            let dic = data["pedidos"]!
            for (k,v) in dic {
                let p = Pedido(estatus: v, fecha:k)
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
