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
class MLViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var catalogo = Catalogo.listaCatalogo()
    var bestPrediction = ""

    @IBOutlet weak var identificacionImagen: UILabel!
    @IBOutlet weak var IrCatalogo: UIButton!
    @IBOutlet weak var camaraBoton: UIButton!
    @IBOutlet weak var fotoVista: UIImageView!
    private let miPicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IrCatalogo.isHidden = true
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
        let modelFile = OrganicML()
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
        
        var bestConfidence: VNConfidence = 0
        //recorrer todas las respuestas en búsqueda del mejor resultado
        for classification in results{
            if (classification.confidence > bestConfidence){
                bestConfidence = classification.confidence
                bestPrediction = classification.identifier
                let confidence = classification.confidence
            }
        }
        let percent = CGFloat(exactly: bestConfidence)! * 100
        
        let formato = String(format: "%0.2f", percent)
        let resultado = "Su imagen pertenece a la categoria: "+bestPrediction+" con un  "+String(formato)+"% de confianza"
        print(resultado)
        identificacionImagen.text = resultado
        IrCatalogo.isHidden = false
        IrCatalogo.setTitle("Comprar productos de la categoria: "+bestPrediction+"", for: .normal)
        
        IrCatalogo.backgroundColor = UIColor.purple
        IrCatalogo.layer.cornerRadius = 10
        IrCatalogo.layer.shadowColor = UIColor(named: "buttonShadow")?.cgColor
        IrCatalogo.layer.shadowOpacity = 0.8
        IrCatalogo.layer.shadowOffset = CGSize(width: 1, height: 1)
        IrCatalogo.layer.borderWidth = 2
        IrCatalogo.layer.borderColor = UIColor(named: "buttonBorder")?.cgColor
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let siguiente = segue.destination as! ProductosViewController
        if bestPrediction == "Acrilicos"{
        siguiente.filtradoTipo = true;
        siguiente.opcion = "Acrílicos"
        
        }
        if bestPrediction == "Kits"{
            //siguiente.opcion = "Kits"
            siguiente.filtradoTipo = true;
            siguiente.opcion = (catalogo[0].categoria?[2])!
            print("Opción:" ,siguiente.opcion)
            //siguiente.categoria = "Catálogo general"
        }
        if bestPrediction == "Liquidos"{
            siguiente.filtradoTipo = true;
            siguiente.opcion = "Líquidos"
            
        }
        if bestPrediction == "Glitters"{
            siguiente.filtradoTipo = true;
            siguiente.opcion = "Glitters"
            
        }
        if bestPrediction == "Gel"{
            siguiente.filtradoTipo = true;
            siguiente.opcion = "TechGel"
            
        }
        if bestPrediction == "Color_Gel"{
            siguiente.filtradoTipo = true;
            siguiente.opcion = "Color Gel"
            
        }
        if bestPrediction == "Arte"{
            siguiente.filtradoTipo = true;
            siguiente.opcion = "Arte"
            
        }
        
        siguiente.categoria = "Catálogo general"
        //siguiente.opcion = (catalogo[1]).producto!
        //siguiente.categoria = (catalogo[section].producto)!
        
        
    }
    
    
    @IBAction func camara() {
        miPicker.sourceType = UIImagePickerController.SourceType.camera
        present(miPicker, animated: true, completion: nil)
    }
    
    @IBAction func album() {
        miPicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(miPicker, animated: true, completion: nil)
    }
    public func imagePickerController(_ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])

    {
            fotoVista.image = info[.originalImage] as? UIImage
            picker.dismiss(animated: true, completion: nil)
            }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}




