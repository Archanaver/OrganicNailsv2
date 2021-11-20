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
    var descuento:Int
    var idDoc:String
    
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
            case idDoc
        
        }
    init(nombre:String, id:String, colores:[String], precio:[Float], descripcion:String, tipo:String, descuento:Int, uso:String, producto:String, presentacion:[String], idDoc:String){
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
        self.idDoc = idDoc
    }
    init(d:DocumentSnapshot){
        self.id = d.documentID
        self.nombre = d.get("nombre") as? String ?? ""
        self.descripcion = d.get("descripcion") as? String ?? ""
        self.id = d.get("id") as? String ?? ""
        self.colores = d.get("colores") as? [String] ?? []
        self.tipo = d.get("tipo") as? String ?? ""
        self.precio = d.get("precio") as? [Float] ?? []
        self.descuento = d.get("descuento") as? Int ?? 0
        self.uso = d.get("uso") as? String ?? ""
        self.producto = d.get("producto") as? String ?? ""
        self.presentacion = d.get("presentacion") as? [String] ?? []
        self.idDoc = d.get("idDoc") as? String ?? ""
        
        
    }
    init(document:DocumentSnapshot){
        self.id = document.documentID
        self.nombre = document.get("nombre_producto") as? String ?? ""
        self.descripcion = document.get("descripcion_producto") as? String ?? ""
        self.id = document.get("id_producto") as? String ?? ""
        self.colores = document.get("color") as? [String] ?? []
        self.tipo = document.get("tipo_producto") as? String ?? ""
        self.precio = document.get("precio_producto") as? [Float] ?? []
        self.descuento = document.get("descuento_producto") as? Int ?? 0
        self.uso = document.get("uso") as? String ?? ""
        self.producto = document.get("cantidad_producto") as? String ?? ""
        self.presentacion = document.get("presentacion") as? [String] ?? []
        self.idDoc = document.get("idDoc") as? String ?? ""
        
        
    }

}

typealias Productos = [Producto]
