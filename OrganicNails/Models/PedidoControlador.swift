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
    
    //Función para regresar un arreglo de pedidos de un usuario
    func fetchPredidosUsuario(usuario: String, completion: @escaping (Result <Pedidos, Error>) -> Void){
        var pedidos = [Pedido]()
        
        db.collection("pedidos").whereField("cliente_id", isEqualTo:usuario).getDocuments() { (querySnapshot, err) in if let err = err {
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
    //Funcion para encontrar el id del cliente
    
   
    //Funcion para regresar los productos de un pedido identificando al usuario
    func fetchCarritoUsuario(idPedido: String, completion: @escaping (Result <Productos, Error>) -> Void){
        var productos = [Producto]()
        //var cursos = [Curso]()
       // let userID = Auth.auth().currentUser!.uid
        db.collection("pedidos").document(idPedido).collection("productos").getDocuments() { (querySnapshot, err) in if let err = err {
            print("Error getting documents: \(err)")
            completion(.failure(err))
        } else {
            for document in querySnapshot!.documents {
                var p = Producto(d: document)
                //var c = Curso(d: document)
                /*Metodo segun apra sacar el id del pedido
                 const racesCollection: AngularFirestoreCollection<Race>;
                 return racesCollection.snapshotChanges().map(actions => {
                   return actions.map(a => {
                     const data = a.payload.doc.data() as Race;
                     data.id = a.payload.doc.id;
                     return data;
                   });
                 });
                 */
                var productosObjecto = Producto(nombre: p.nombre, id: p.id, colores: p.colores, precio: p.precio, descripcion: p.descripcion, tipo: p.tipo, descuento: p.descuento, uso: p.uso, producto: p.producto, presentacion: p.presentacion)
                //Igual aqui el append podria ser algo como " pedidos.append(p.productos)",
                //pero swift no deja imprimir el arreglo productos :(
                //cursos.append(c.nombre)
                productos.append(productosObjecto)
               
            }
            completion(.success(productos))
            //completion(.success(cursos))
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
