//
//  Producto.swift
//  OrganicNails
//
//  Created by Archana Verma on 10/3/21.
//

import Foundation
import Firebase

struct Producto: Decodable{
    var nombre:String
    var id:String
    var colores:[String]
    var precio:[Float]
    var descripcion:String
    var tipo: String
    var presentacion: [String]
    var producto: String
    var uso: String
    var descuento:Float
    
    enum CodingKeys: String, CodingKey {
            case nombre
            case descripcion
            case id
            case colores
            case tipo
            case precio
            case descuento
            case uso
            case producto
            case presentacion
        
        }
    init(nombre:String, id:String, colores:[String], precio:[Float], descripcion:String, tipo:String, descuento:Float, uso:String, producto:String, presentacion:[String]){
        self.nombre = nombre
        self.id = id
        self.colores = colores
        self.precio = precio
        self.descripcion = descripcion
        self.tipo = tipo
        self.descuento = descuento
        self.uso = uso
        self.producto = producto
        self.presentacion = presentacion
    }
    init(d:DocumentSnapshot){
        self.id = d.documentID
        self.nombre = d.get("nombre") as? String ?? ""
        self.descripcion = d.get("descripcion") as? String ?? ""
        self.id = d.get("id") as? String ?? ""
        self.colores = d.get("colores") as? [String] ?? []
        self.tipo = d.get("tipo") as? String ?? ""
        self.precio = d.get("precio") as? [Float] ?? []
        self.descuento = d.get("descuento") as? Float ?? 0
        self.uso = d.get("uso") as? String ?? ""
        self.producto = d.get("producto") as? String ?? ""
        self.presentacion = d.get("presentacion") as? [String] ?? []
        
        
    }

}

typealias Productos = [Producto]
