//
//  ProductoControlador.swift
//  OrganicNails
//
//  Created by Archana Verma on 10/3/21.
//

import Foundation

import Firebase

class CursoControlador{
    let db = Firestore.firestore()
    
  /*  func fetchProductos(completion: @escaping (Result<Cursos, Error>)->Void){
        var urlComponents = URLComponents(string: "http://martinmolina.com.mx/202113/tc2024/equipo2/cursos.json")!


        let task = URLSession.shared.dataTask(with: urlComponents.url!) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data{
                do{
                    let cursos = try? jsonDecoder.decode([Curso].self, from: data)
                    completion(.success(cursos!))
                }
                catch{
                    completion(.failure(error))
                }
            }
            else {
                completion(.failure(error as! Error))
            }
            
        }

        task.resume()
        
    }*/
    
    //Función para regresar un arreglo de cursos de un pedido
    func fetchCursosPedido(pedido: String, completion: @escaping (Result <Cursos, Error>) -> Void){
        var cursos = [Curso]()
        
        db.collection("pedidos").document(pedido).collection("cursos").getDocuments() { (querySnapshot, err) in if let err = err {
            print("Error getting documents: \(err)")
            completion(.failure(err))
        } else {
            for document in querySnapshot!.documents {
                var c = Curso(d: document)
                cursos.append(c)
            }
            completion(.success(cursos))
            }
        }
    }
    
    func fetchCursos(completion: @escaping (Result<Cursos, Error>)->Void){
        var lista_cursos = [Curso]()
        db.collection("cursos").getDocuments(){ (querySnapshot, err) in
            if let err = err{
                print("error getting docuemnts: \(err)")
                completion(.failure(err))
            }else{
                for document in querySnapshot!.documents{
                    let i = Curso(d: document)
                    lista_cursos.append(i)
                }
                completion(.success(lista_cursos))
            }
            
        }
        
    }
        
    }

