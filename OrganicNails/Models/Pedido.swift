//
//  Pedido.swift
//  OrganicNails
//
//  Created by Archana Verma on 11/3/21.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct CursoP:Decodable{
    var id_curso: String
    var instructor: String
    var nombre_curso:String
    var precio_curso:String
    var fecha_curso:String
    var descripcion_curso:String
    
    init(id_curso:String, instructor:String,nombre_curso:String, precio_curso:String, fecha_curso:String, descripcion_curso:String){
            self.id_curso = id_curso
            self.instructor = instructor
            self.nombre_curso = nombre_curso
            self.precio_curso = precio_curso
            self.fecha_curso = fecha_curso
            self.descripcion_curso = descripcion_curso
      
            
        }
        
        init(d:DocumentSnapshot){
            self.id_curso = d.get("id_curso") as? String ?? ""
            self.instructor = d.get("instructor") as? String ?? ""
            self.nombre_curso = d.get("nombre_curso") as? String ?? ""
            self.precio_curso = d.get("precio_curso") as? String ?? ""
            self.fecha_curso = d.get("fecha_curso") as? String ?? ""
            self.descripcion_curso = d.get("descripcion_curso") as? String ?? ""
        }
    
    func IdCurso()->String {
        return id_curso
    }
    func Instructor()->String {
        return instructor
    }
    func NombreCurso()->String {
        return nombre_curso
    }
    func PrecioCurso()->String {
        return precio_curso
    }
    func FechaCurso()->String {
        return fecha_curso
    }
    func DescripcionCurso()->String {
        return descripcion_curso
    }
}
struct ProductoP:Decodable{
    var cantidad_producto: Int
    var color:String
    var descripcion_producto:String
    var descuento_producto:Int
    var id_producto:String
    var nombre_producto:String
    var precio_producto:Float
    var presentacion: String
    var tipo_producto: String
    var uso: String
    
    enum CodingKeys: String, CodingKey {
            case cantidad_producto
            case color
            case descripcion_producto
            case descuento_producto
            case id_producto
            case nombre_producto
            case precio_producto
            case presentacion
            case tipo_producto
            case uso
        
        }
    init(cantidad_producto:Int, color:String, descripcion_producto:String, descuento_producto:Int, id_producto:String, nombre_producto:String, precio_producto:Float, presentacion:String, tipo_producto:String, uso:String){
        self.cantidad_producto = cantidad_producto
        self.color = color
        self.descripcion_producto = descripcion_producto
        self.descuento_producto = descuento_producto
        self.id_producto = id_producto
        self.nombre_producto = nombre_producto
        self.precio_producto = precio_producto
        self.presentacion = presentacion
        self.tipo_producto = tipo_producto
        self.uso = uso
        
    }
    init(d:DocumentSnapshot){
        self.cantidad_producto = d.get("cantidad_producto") as? Int ?? 0
        self.color = d.get("color") as? String ?? ""
        self.descripcion_producto = d.get("descripcion_producto") as? String ?? ""
        self.descuento_producto = d.get("descuento_producto") as? Int ?? 0
        self.id_producto = d.get("id_producto") as? String ?? ""
        self.nombre_producto = d.get("nombre_producto") as? String ?? ""
        self.precio_producto = d.get("precio_producto") as? Float ?? 0.0
        self.presentacion = d.get("presentacion") as? String ?? ""
        self.tipo_producto = d.get("tipo_producto") as? String ?? ""
        self.uso = d.get("uso") as? String ?? ""
        
        
    }
    
    
    func CantidadProducto()->Int {
        return cantidad_producto
    }
    func Color()->String {
        return color
    }
    func DescripcionProducto()->String {
        return descripcion_producto
    }
    func DescuentoProducto()->Int {
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
    var uid:String
    var productos:[ProductoP]?
    var cursos:[CursoP]?
    

    
    enum CodingKeys: String, CodingKey {
        case activo
        case cliente_id
        case direccion
        case estatus
        case fecha
        case productos
        case cursos
        case uid
        
    }
    
    
    init(activo:Bool, estatus:String, productos:[ProductoP], direccion:String, cursos: [CursoP], cliente_id:String, fecha:String, uid:String ){
        self.activo = activo
        self.cliente_id = cliente_id
        self.direccion = direccion
        self.estatus = estatus
        self.fecha = fecha
        self.productos = productos
        self.cursos = cursos
        self.uid = uid
    }
    
    init(d:DocumentSnapshot){
            self.uid = d.documentID
            self.activo = d.get("activo") as? Bool ?? false
            self.cliente_id = d.get("cliente_id") as? String ?? ""
            self.direccion = d.get("direccion") as? String ?? ""
            self.estatus = d.get("estatus") as? String ?? ""
            self.fecha = d.get("fecha") as? String ?? ""
            self.productos = d.get("productos") as? [ProductoP] ?? []
            self.cursos = d.get("cursos") as? [CursoP] ?? []
            //self.uid = d.get("uid") as? String ?? ""
        }
    

}


typealias ProductosP = [ProductoP]
typealias CursosP = [CursoP]
typealias Pedidos = [Pedido]
