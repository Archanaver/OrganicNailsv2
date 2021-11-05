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

