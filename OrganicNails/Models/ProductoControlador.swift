//
//  ProductoControlador.swift
//  OrganicNails
//
//  Created by Archana Verma on 10/3/21.
//

import Foundation

import Firebase

class ProductoControlador{
    
    let db = Firestore.firestore()
    
    func fetchProductos(completion: @escaping (Result<Productos, Error>)->Void){
        var lista_productos = [Producto]()
        db.collection("productos").getDocuments(){ (querySnapshot, err) in
            if let err = err{
                print("error getting docuemnts: \(err)")
                completion(.failure(err))
            }else{
                for document in querySnapshot!.documents{
                    let i = Producto(d: document)
                    lista_productos.append(i)
                }
                completion(.success(lista_productos))
            }
            
        }
    }
    
    //Función para regresar un arreglo de productos de un tipo
    func fetchProductosTipo(tipo: String, completion: @escaping (Result <Productos, Error>) -> Void){
        var productos = [Producto]()
        
        if(tipo == "Todos") {
            db.collection("productos").getDocuments() { (querySnapshot, err) in if let err = err {
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
        else {
            db.collection("productos").whereField("tipo", isEqualTo:tipo).getDocuments() { (querySnapshot, err) in if let err = err {
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
    }
    
    //Hacemos una lista con los productos que tienen promoción
    func productosPromo(listaProductos: Productos) -> Productos{
        
        //La variable que se va a regesar
        var productosConPromo = [Producto]()
        
        for i in listaProductos {
            if i.descuento > 0 {
                productosConPromo.append(i)
            }
        }
        
        //Ordena la lista de forma alfabética por el nombre
        var sortedProductos = productosConPromo.sorted(by: { $0.nombre < $1.nombre })
            
        return sortedProductos
    }
    
    //Para guardar todas las presentaciones en un arreglo
    func presentaciones(p: Producto) -> Array<String>{
        var pres:Array<String> = []
        //Por cada elemento de presentaciones del produco
        for i in p.presentacion {
            //Obtener cada valor y guardarlo
            pres.append(i)
        }
        return pres
    }
    
    
    //Función para regresar un arreglo de productos de un pedido
    func fetchProductosPedido(pedido: String, completion: @escaping (Result <Productos, Error>) -> Void){
        var productos = [Producto]()
        
        db.collection("pedidos").document(pedido).collection("productos").getDocuments() { (querySnapshot, err) in if let err = err {
            print("Error getting documents: \(err)")
            completion(.failure(err))
        } else {
            for document in querySnapshot!.documents {
                var p = Producto(document: document)
                productos.append(p)
            }
            completion(.success(productos))
            }
        }
    }
}

