//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by Jan Provazník on 10/03/2020.
//  Copyright © 2020 Jan Provazník. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {

//    override var vcLoggingName: String {
//        return "ThemeChooser"
//    }
    
    let themes = [
        "Sports": "🏀⚾️🎾🏐🏈🎱🏓🏂🎳⛳️🛹🧘🥏",
        "Animals": "🐶🦊🐼🦀🐪🐓🐋🐙🦄🐵🐿🦔🐢",
        "Faces": "😃😂😎😰😴🙄🤔🥰😷🥶🥳🤪🤢",
        "Halloween": "🦇🧛🏻🧟😈🎃👻🍫🔪🕷👽"
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return true // I did it but I'm actually not going to do it
            }
        }
        return false // I didn't collapse it so you should do it
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]  {
                cvc.theme = theme
            }
        } else if let cvc = lastSeguedToConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]  {
                 cvc.theme = theme
             }
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    // MARK: - Navigation
    
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]  {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                    lastSeguedToConcentrationViewController = cvc
                }
            }
        }
    }

}
