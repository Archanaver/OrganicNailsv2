//
//  EvaluaServicioViewController.swift
//  OrganicNails
//
//  Created by user189673 on 10/3/21.
//

import UIKit

class EvaluaServicioViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func didTapButton(){
        guard let vc = storyboard?.instantiateViewController(identifier: "Perfil")else {
        print("failed to load storyboard")
        return
}
    
        present(vc, animated: true)
    }
    

}
