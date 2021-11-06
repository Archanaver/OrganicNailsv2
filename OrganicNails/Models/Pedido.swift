//
//  Pedido.swift
//  OrganicNails
//
//  Created by Archana Verma on 11/3/21.
//

import Foundation
import Firebase

/*struct CursoP:Decodable{
    var id_curso: String
    var instructor: String
    var nombre_curso:String
    var precio_curso:String
    
}*/
struct ProductoP:Decodable{
    var cantidad_producto: Int
    var color:String
    var descripcion_producto:String
    var descuento_producto:Float
    var id_producto:String
    var nombre_producto:String
    var precio_producto:Float
    var presentacion: String
    var tipo_producto: String
    var uso: String
    
    func CantidadProducto()->Int {
        return cantidad_producto
    }
    func Color()->String {
        return color
    }
    func DescripcionProducto()->String {
        return descripcion_producto
    }
    func DescuentoProducto()->Float {
        return descuento_producto
    }
    func IdProducto()->String {
        return id_producto
    }
    func NombreProducto()->String {
        return nombre_producto
    }
    func PrecioProducto()->Float {
        return precio_producto
    }
    func Presentacion()->String {
        return presentacion
    }
    func TipoProducto()->String {
        return tipo_producto
    }
    func Uso()->String {
        return uso
    }
    

}

struct Pedido: Decodable{
    var activo:Bool
    var cliente_id: String
    var direccion:String
    var estatus: String
    var fecha: String
    var id:String
    var productos:[ProductoP]
    //var cursos:[CursoP]
    

    
    enum CodingKeys: String, CodingKey {
        case activo
        case cliente_id
        case direccion
        case estatus
        case fecha
        case id
        case productos
        //case cursos
        
    }
    
    
    init(activo:Bool, estatus:String, productos:[ProductoP] ){
        self.activo = activo
        self.cliente_id = "0"
        self.direccion = ""
        self.estatus = estatus
        self.fecha = ""
        self.id = "0"
        self.productos = productos
        //self.cursos = []
        
    }
    init(d:DocumentSnapshot){
            self.id = d.documentID
            self.activo = d.get("activo") as? Bool ?? false
            self.cliente_id = d.get("cliente_id") as? String ?? ""
            self.direccion = d.get("direccion") as? String ?? ""
            self.estatus = d.get("estatus") as? String ?? ""
            self.fecha = d.get("fecha") as? String ?? ""
            self.id = d.get("id") as? String ?? ""
            self.productos = d.get("productos") as? [ProductoP] ?? []
            //self.cursos = d.get("cursos") as? [CursoP] ?? []
        }
    

}




typealias Pedidos = [Pedido]
