//
//  ViewController.swift
//  OrganicNails
//
//  Created by Archana Verma on 9/23/21.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*let button = UIButton(frame: CGRect (x: 0, y: 0,
        width: 200, height: 50))
        view.addSubview(button)
        button.center = view.center
        button.setTitle("Authorize",for:.normal)
        button.backgroundColor = .systemGreen
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)*/
        
    }
    
        @objc func didTapButton(){
            let context = LAContext()
            var error: NSError? = nil
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
                let reason = "Favor de autorizar con Face ID"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){
                    [weak self] succes, error in
                    guard succes, error == nil else{
                        //fallo
                        let alert = UIAlertController(title: "Fallo de autenticación", message: "Favor de intentar de nuevo", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                        self?.present(alert, animated: true)
                        return
                    }
                    DispatchQueue.main.async {
                    //Mostar otra pagina en caso de exito
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc: DetalleClienteViewController = storyboard.instantiateViewController(withIdentifier: "pantalla") as! DetalleClienteViewController
                    self!.present(vc, animated: true, completion: nil)
                }
                }
            }
            else{
                //no se puede utilizar
                let alert = UIAlertController(title: "No disponible", message: "No puedes usar esta herramienta", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                present(alert, animated: true)
            }
    }
}
    

