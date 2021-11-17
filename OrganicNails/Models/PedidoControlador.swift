//
//  PedidoControlador.swift
//  OrganicNails
//
//  Created by Archana Verma on 11/3/21.
//

import Foundation
import Firebase
import FirebaseFirestore

class PedidoControlador{
    
    let db = Firestore.firestore()
    
   
    
    func crearPedidoConProductoP(nuevoPedido:Pedido, completion: @escaping (Result<String,Error>)->Void ){
        var ref: DocumentReference? = nil
        //let newDocumentID = UUID().uuidString
        ref = db.collection("pedidos").addDocument(data:[
            "activo": nuevoPedido.activo,
            "direccion": nuevoPedido.direccion,
            "estatus": nuevoPedido.estatus,
            "fecha": nuevoPedido.fecha,
            "cliente_id": nuevoPedido.cliente_id,
            "uid": nuevoPedido.uid
        ]){ err in
            if let err = err{
                print("Error al añadir documento: \(err)")
                completion(.failure(err))
            }else{
                for nuevoProducto in nuevoPedido.productos!{
                    //print("ref",ref!.documentID)
                    let testRef = self.db.collection("pedidos").document(ref!.documentID).collection("productos")
                    let aDoc = testRef.document()
                    let data = [
                       "cantidad_producto": nuevoProducto.CantidadProducto(),
                       "color":nuevoProducto.Color(),
                       "descripcion_producto": nuevoProducto.DescripcionProducto(),
                       "descuento_producto": nuevoProducto.DescuentoProducto(),
                       "id_producto": nuevoProducto.IdProducto(),
                       "nombre_producto": nuevoProducto.NombreProducto(),
                       "precio_producto": nuevoProducto.PrecioProducto(),
                       "presentacion": nuevoProducto.Presentacion(),
                       "tipo_producto": nuevoProducto.TipoProducto(),
                       "uso": nuevoProducto.Uso(),
                        "idDoc": aDoc.documentID,
                        "id_pedido": ref!.documentID
                    ] as [String : Any]

                    //print("id del producto", aDoc.documentID)
                    aDoc.setData(data)
                    { err in
                        if let err = err{
                            print("Error al añadir producto: \(err)")
                            completion(.failure(err))
                        }else {
                            
                            completion(.success("Pedido ID: \(ref!.documentID)"))
                        }
                    }
                }
            }
        }
}
    
    
    
/*
    func crearPedidoConProducto(nuevoPedido:Pedido, completion: @escaping (Result<String,Error>)->Void ){
        var ref: DocumentReference? = nil
        //let newDocumentID = UUID().uuidString
        ref = db.collection("pedidos").addDocument(data:[
            "activo": nuevoPedido.activo,
            "direccion": nuevoPedido.direccion,
            "estatus": nuevoPedido.estatus,
            "fecha": nuevoPedido.fecha,
            "cliente_id": nuevoPedido.cliente_id,
            "uid": nuevoPedido.uid
        ]){ err in
            if let err = err{
                print("Error al añadir documento: \(err)")
                completion(.failure(err))
            }else{
                for nuevoProducto in nuevoPedido.productos!{
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
                        }else {
                            
                            completion(.success("Pedido ID: \(ref!.documentID)"))
                        }
                    }
                }
            }
        }
}
   */
    func crearPedidoConCurso(nuevoPedido:Pedido, completion: @escaping (Result<String,Error>)->Void ){
        var ref: DocumentReference? = nil
        //let newDocumentID = UUID().uuidString
        ref = db.collection("pedidos").addDocument(data:[
            "activo": nuevoPedido.activo,
            "direccion": nuevoPedido.direccion,
            "estatus": nuevoPedido.estatus,
            "fecha": nuevoPedido.fecha,
            "cliente_id": nuevoPedido.cliente_id,
            "uid": nuevoPedido.uid
        ]){ err in
            if let err = err{
                print("Error al añadir documento: \(err)")
                completion(.failure(err))
            }else{
                for nuevoCurso in nuevoPedido.cursos!{
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
    
    func fetchCarritoActivo(idDocument: String, completion: @escaping (Result <Productos, Error>) -> Void){
            var productos = [Producto]()
            
            db.collection("pedidos").document(idDocument).collection("productos").getDocuments() { (querySnapshot, err) in if let err = err {
                print("Error getting documents: \(err)")
                completion(.failure(err))
            } else {
                for document in querySnapshot!.documents {
                    var p = Producto(d: document)
                    productos.append(p)
                }
                completion(.success(productos))
                }
            }
        }
    

    
    func agregarProductoEnPedido(nuevoProducto:ProductoP,idPedido:String, completion: @escaping (Result<String,Error>)->Void ){
        
        let testRef = db.collection("pedidos").document(idPedido).collection("productos")
        let aDoc = testRef.document()
        let data = [
           "cantidad_producto": nuevoProducto.cantidad_producto,
           "color":nuevoProducto.color,
           "descripcion_producto": nuevoProducto.descripcion_producto,
           "descuento_producto": nuevoProducto.descuento_producto,
           "id_producto": nuevoProducto.id_producto,
           "nombre_producto": nuevoProducto.nombre_producto,
           "precio_producto": nuevoProducto.precio_producto,
           "presentacion": nuevoProducto.presentacion,
           "tipo_producto": nuevoProducto.tipo_producto,
           "uso": nuevoProducto.uso,
            "id_pedido": idPedido,
            "idDoc": aDoc.documentID
        ] as [String : Any]
        aDoc.setData(data)
        { err in
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
    
    
    
    func fetchPedidos(completion: @escaping (Result<Pedidos, Error>)->Void){
            var lista_pedidos = [Pedido]()
            db.collection("pedidos").getDocuments(){ (querySnapshot, err) in
                if let err = err{
                    print("error getting docuements: \(err)")
                    completion(.failure(err))
                }else{
                    for document in querySnapshot!.documents{
                        let i = Pedido(d: document)
                        lista_pedidos.append(i)
                    }
                    completion(.success(lista_pedidos))
                }
                
            }
            
        }
    //checa cuál carrito está activo y te regresa el id del documento
    func checarCarrito(completion: @escaping (Result<String,Error>)->Void){
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
    
    //Función para regresar un arreglo de pedidos de un usuario
    func fetchPredidosUsuario(usuario: String, completion: @escaping (Result <Pedidos, Error>) -> Void){
        var pedidos = [Pedido]()
        
        db.collection("pedidos").whereField("uid", isEqualTo:usuario).getDocuments() { (querySnapshot, err) in if let err = err {
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
    
    
   
    //Funcion para regresar los productos de un pedido identificando al usuario
    func fetchCarritoUsuario(idPedido: String, completion: @escaping (Result <ProductosP, Error>) -> Void){
        var productos = [ProductoP]()
        
        db.collection("pedidos").document(idPedido).collection("productos").getDocuments() { (querySnapshot, err) in if let err = err {
            print("Error getting documents: \(err)")
            completion(.failure(err))
        } else {
            for document in querySnapshot!.documents {
                var p = ProductoP(d: document)
                p = ProductoP(cantidad_producto: p.cantidad_producto, color: p.color, descripcion_producto: p.descripcion_producto, descuento_producto: p.descuento_producto, id_producto: p.id_producto, nombre_producto: p.nombre_producto, precio_producto: p.precio_producto, presentacion: p.presentacion, tipo_producto: p.tipo_producto, uso: p.uso)
              
                productos.append(p)
               
            }
            
            completion(.success(productos))
            }
        }
    }
    
    func fetchCarritoCursosUsuario(idPedido: String, completion: @escaping (Result <CursosP, Error>) -> Void){
        var cursos = [CursoP]()
        db.collection("pedidos").document(idPedido).collection("cursos").getDocuments() { (querySnapshot, err) in if let err = err {
            print("Error getting documents: \(err)")
            completion(.failure(err))
        } else {
            for document in querySnapshot!.documents {
                var p = CursoP(d: document)
                p = CursoP(id_curso: p.id_curso, instructor: p.instructor, nombre_curso: p.nombre_curso, precio_curso: p.precio_curso, fecha_curso: p.fecha_curso, descripcion_curso: p.descripcion_curso)
                //print("Cursos--- ",p)
                cursos.append(p)
            }
            completion(.success(cursos))
            
            }
        }
    }
    
  
    func deleteCarrito(id:String,completion: @escaping (Result<String,Error>)->Void){
          db.collection("pedidos").document(id).delete(){err in
                            if let err = err {
                                print("Error al remover carrito\(err)")
                                completion(.failure(err))
                            }else{
                                        completion(.success("Se ha eliminado carrito activo"))
                                    
                                  }
        
                        }
        
     }
    
    func deleteProductoP(idDoc:String, idPedido:String,completion: @escaping (Result<String,Error>)->Void ){
        db.collection("pedidos").document(idPedido).collection("productos").document(idDoc).delete(){err in
            if let err = err {
                print("Error al borrar producto\(err)")
                completion(.failure(err))
            }else{
                        completion(.success("Se ha eliminado producto"))
                    
                  }

        }
    }
//con el id del pedido activo te regresa el arreglo con los productos
    func fetchCarritoProductos(pedidoActivo: String,completion: @escaping (Result<[ProductoP],Error>)->Void){
        var lista_productos = [ProductoP]()
        db.collection("pedidos").document(pedidoActivo).collection("productos").getDocuments(){ (querySnapshot, err) in
            if let err = err{
                print("error getting documents: \(err)")
                completion(.failure(err))
            }else{
                for document in querySnapshot!.documents{
                    let i = ProductoP(d: document)
                    lista_productos.append(i)
                }
                completion(.success(lista_productos))
            }
            
        }
        
        
    }
    //con el id del pedido activo te regresa el arreglo con los cursos
    func fetchCarritoCursos(pedidoActivo: String,completion: @escaping (Result<[CursoP],Error>)->Void){
        var lista_cursos = [CursoP]()
        db.collection("pedidos").document(pedidoActivo).collection("cursos").getDocuments(){ (querySnapshot, err) in
            if let err = err{
                print("error getting documents: \(err)")
                completion(.failure(err))
            }else{
                for document in querySnapshot!.documents{
                    let i = CursoP(d: document)
                    lista_cursos.append(i)
                }
                completion(.success(lista_cursos))
            }
            
        }
        
        
    }
    //Hacemos una lista de pedidos con el estado que solicita
    func pedidosEstadoSelect(listaPedidos: Pedidos, estado: String) -> Pedidos{
        
        //La variable que se va a regesar
        var pedidosEstado = [Pedido]()
        
        for i in listaPedidos {
            if(i.estatus == estado) {
                pedidosEstado.append(i)
            }
        }
        
        //Ordena la lista por fecha
        var sortedPedidos = pedidosEstado.sorted(by: { $0.fecha > $1.fecha })
            
        return sortedPedidos
    }
    

}
