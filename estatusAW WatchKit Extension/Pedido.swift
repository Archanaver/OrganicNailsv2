//
//  Pedido.swift
//  estatusAW WatchKit Extension
//
//  Created by user189966 on 11/30/21.
//

import Foundation
struct Pedido{
    var productos:String
    var fecha: String
    
    
    init(fecha:String, productos:String ){
        self.fecha = fecha
        self.productos = productos
    }
}
