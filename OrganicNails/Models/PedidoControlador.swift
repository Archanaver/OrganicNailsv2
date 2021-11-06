//
//  PedidoControlador.swift
//  OrganicNails
//
//  Created by Archana Verma on 11/3/21.
//

import Foundation
import Firebase

class PedidoControlador{
    
    let db = Firestore.firestore()
    
    
    func crearPedidoConProducto(nuevoPedido:Pedido, completion: @escaping (Result<String,Error>)->Void ){
        var ref: DocumentReference? = nil
        //let newDocumentID = UUID().uuidString
        ref = db.collection("pedidos").addDocument(data:[
            "activo": nuevoPedido.activo,
            "direccion": nuevoPedido.direccion,
            "estatus": nuevoPedido.estatus,
            "fecha": FieldValue.serverTimestamp(),
            "cliente_id": nuevoPedido.cliente_id,
            "id": nuevoPedido.id
        ]){ err in
            if let err = err{
                print("Error al añadir documento: \(err)")
                completion(.failure(err))
            }else{
                for nuevoProducto in nuevoPedido.productos{
                    print("ref",ref!.documentID)
                    self.db.collection("pedidos").document(ref!.documentID).collection("productos").addDocument(data: [
                       "cantidad_producto": nuevoProducto.CantidadProducto(),
                       "color":nuevoProducto.Color(),
                       "descripcion_producto": nuevoProducto.DescripcionProducto(),
                       "descuento_producto": nuevoProducto.DescuentoProducto(),
                       "id_producto": nuevoProducto.IdProducto(),
                       "nombre_producto": nuevoProducto.NombreProducto(),
                       "precio_producto": nuevoProducto.PrecioProducto(),
                       "presentacion": nuevoProducto.Presentacion(),
                       "tipo_producto": nuevoProducto.TipoProducto(),
                       "uso": nuevoProducto.Uso()
                    ]){ err in
                        if let err = err{
                            print("Error al añadir producto: \(err)")
                            completion(.failure(err))
                        }else{
                            completion(.success("Pedido ID: \(ref!.documentID)"))
                        }
                    }
                }
            }
        }
}
    
    //Función para regresar un arreglo de pedidos de un estado
    func fetchPedidosEstado(estado: String, completion: @escaping (Result <Pedidos, Error>) -> Void){
        var pedidos = [Pedido]()
        
        if(estado == "Todos") {
            db.collection("pedidos").getDocuments() { (querySnapshot, err) in if let err = err {
                print("Error getting documents: \(err)")
                completion(.failure(err))
            } else {
                for document in querySnapshot!.documents {
                    var p = Pedido(d: document)
                    pedidos.append(p)
                }
                completion(.success(pedidos))
                }
            }
        }
        else {
            db.collection("pedidos").whereField("estatus", isEqualTo:estado).getDocuments() { (querySnapshot, err) in if let err = err {
                print("Error getting documents: \(err)")
                completion(.failure(err))
            } else {
                for document in querySnapshot!.documents {
                    var p = Pedido(d: document)
                    pedidos.append(p)
                }
                completion(.success(pedidos))
                }
            }
        }
    }
    
    func crearPedidoConCurso(nuevoPedido:Pedido, completion: @escaping (Result<String,Error>)->Void ){
        var ref: DocumentReference? = nil
        //let newDocumentID = UUID().uuidString
        ref = db.collection("pedidos").addDocument(data:[
            "activo": nuevoPedido.activo,
            "direccion": nuevoPedido.direccion,
            "estatus": nuevoPedido.estatus,
            "fecha": FieldValue.serverTimestamp(),
            "cliente_id": nuevoPedido.cliente_id,
            "id": nuevoPedido.id
        ]){ err in
            if let err = err{
                print("Error al añadir documento: \(err)")
                completion(.failure(err))
            }else{
                for nuevoCurso in nuevoPedido.cursos{
                    print("ref",ref!.documentID)
                    self.db.collection("pedidos").document(ref!.documentID).collection("cursos").addDocument(data: [
                        "id_curso": nuevoCurso.IdCurso(),
                        "instructor":nuevoCurso.Instructor(),
                        "nombre_curso": nuevoCurso.NombreCurso(),
                        "precio_curso": nuevoCurso.PrecioCurso(),
                        "fecha_curso": nuevoCurso.FechaCurso(),
                        "descripcion_curso": nuevoCurso.DescripcionCurso()
                    ]){ err in
                        if let err = err{
                            print("Error al añadir curso: \(err)")
                            completion(.failure(err))
                        }else{
                            completion(.success("Pedido ID: \(ref!.documentID)"))
                        }
                    }
                }
            }
        }
}
    
    func checarCarritoActivo(completion: @escaping (Result<String,Error>)->Void){
        db.collection("pedidos").whereField("activo", isEqualTo: true)
          .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error obteniendo pedido activo: \(err)")
                completion(.failure(err))
            } else {
                var documentoID:String = ""
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    documentoID = document.documentID
                }
                completion(.success(documentoID))
                
            }
        }
        
        
    }
    

    
    func agregarProductoEnPedido(nuevoProducto:ProductoP,idPedido:String, completion: @escaping (Result<String,Error>)->Void ){
        db.collection("pedidos").document(idPedido).collection("productos").addDocument(data: [
           "cantidad_producto": nuevoProducto.CantidadProducto(),
           "color":nuevoProducto.Color(),
           "descripcion_producto": nuevoProducto.DescripcionProducto(),
           "descuento_producto": nuevoProducto.DescuentoProducto(),
           "id_producto": nuevoProducto.IdProducto(),
           "nombre_producto": nuevoProducto.NombreProducto(),
           "precio_producto": nuevoProducto.PrecioProducto(),
           "presentacion": nuevoProducto.Presentacion(),
           "tipo_producto": nuevoProducto.TipoProducto(),
           "uso": nuevoProducto.Uso()
        ]){ err in
            if let err = err{
                print("Error al añadir producto: \(err)")
                completion(.failure(err))
            }else{
                completion(.success("Pedido ID: \(idPedido)"))
            }
        }
        
    }
    
    func agregarCursoEnPedido(nuevoCurso:CursoP,idPedido:String, completion: @escaping (Result<String,Error>)->Void ){
        db.collection("pedidos").document(idPedido).collection("cursos").addDocument(data: [
           "id_curso": nuevoCurso.IdCurso(),
           "instructor":nuevoCurso.Instructor(),
           "nombre_curso": nuevoCurso.NombreCurso(),
           "precio_curso": nuevoCurso.PrecioCurso(),
           "fecha_curso": nuevoCurso.FechaCurso(),
           "descripcion_curso": nuevoCurso.DescripcionCurso()
        ]){ err in
            if let err = err{
                print("Error al añadir curso: \(err)")
                completion(.failure(err))
            }else{
                completion(.success("Pedido ID: \(idPedido)"))
            }
        }
        
    }
    
    
    

}
