
//
//  ViewController.swift
//  fotosS4
//
//  Created by ITESM on 11/7/17.
//  Copyright © 2017 Tecnologico de Monterrey. All rights reserved.
//

import UIKit
import CoreML
import Vision

//ML solo funciona a partir de iOS 11
@available(iOS 11.0, *)
class Claisificador_Productos_ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        

    @IBOutlet weak var identificacionImagen: UILabel!
    
    @IBOutlet weak var camaraBoton: UIButton!
    @IBOutlet weak var fotoVista: UIImageView!
    private let miPicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            camaraBoton.isHidden = true
        }
        miPicker.delegate = self
        
    }

    @IBAction func guardarImagen(_ sender: UIButton) {
    
        
        UIImageWriteToSavedPhotosAlbum(fotoVista.image!, nil, nil, nil)
    }
    @IBAction func ejecutarML() {
        //instanciar el modelo de la red neuronal
        let modelFile = Clasifica_Products()
        let model = try! VNCoreMLModel(for: modelFile.model)
        //Convertir la imagen obtenida a CIImage
        let imagenCI = CIImage(image: fotoVista.image!)
        //Crear un controlador para el manejo de la imagen, este es un requerimiento para ejecutar la solicitud del modelo
        let handler = VNImageRequestHandler(ciImage: imagenCI!)
        //Crear una solicitud al modelo para el análisis de la imagen
        let request = VNCoreMLRequest(model: model, completionHandler: resultadosModelo)
        try! handler.perform([request])
        
    }
    
    func resultadosModelo(request: VNRequest, error: Error?)
    {
        guard let results = request.results as? [VNClassificationObservation] else { fatalError("No hubo respuesta del modelo ML")}
        var bestPrediction = ""
        var bestConfidence: VNConfidence = 0
        //recorrer todas las respuestas en búsqueda del mejor resultado
        for classification in results{
            if (classification.confidence > bestConfidence){
                bestConfidence = classification.confidence
                bestPrediction = classification.identifier
            }
        }
        let resultado = bestPrediction+" "+String(bestConfidence)
        print(resultado)
        identificacionImagen.text = resultado
    }
    
    
    @IBAction func camara() {
        miPicker.sourceType = UIImagePickerController.SourceType.camera
        present(miPicker, animated: true, completion: nil)
    }
    
    @IBAction func album() {
        miPicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(miPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        fotoVista.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

