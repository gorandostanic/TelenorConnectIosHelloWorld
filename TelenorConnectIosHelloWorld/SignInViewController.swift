//
//  ViewController.swift
//  TelenorConnectIosHelloWorld
//
//  Created by Jørund Fagerjord on 10/03/16.
//  Copyright © 2016 Telenor Digital. All rights reserved.
//

import UIKit

import AeroGearHttp
import AeroGearOAuth2

class SignInViewController: UIViewController {
    
    var userInfo: AnyObject?
    var oauth2Module: OAuth2Module?
    let config = TelenorConnectConfig(clientId: "telenordigital-connectexample-android",
        useStaging: true,
        scopes: ["profile", "openid", "email"],
        accountId: "telenor-connect-ios-hello-world")
    
    override func viewDidLoad() {
        oauth2Module = AccountManager.getAccountByConfig(config) ?? AccountManager.addAccount(self.config, moduleClass: TelenorConnectOAuth2Module.self)
        print("oauth2Module?.isAuthorized()=\(oauth2Module?.isAuthorized())")
    }

    @IBAction func signInPressed(sender: AnyObject) {
        guard let oauth2Module = self.oauth2Module else {
            return
        }
        
        print("oauth2Module.isAuthorized()=\(oauth2Module.isAuthorized())")
        
        oauth2Module.login { (accessToken: AnyObject?, userInfo: OpenIDClaim?, error: NSError?) -> Void in
            if let accessToken = accessToken {
                print("accessToken=\(accessToken)")
                self.userInfo = userInfo
                self.performSegueWithIdentifier("signedIn", sender: nil)
            }
            if let error = error {
                print("error=\(error)")
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "signedIn") {
            let signedInController = segue.destinationViewController as! SignedInViewController
            signedInController.infoText = String(userInfo)
            signedInController.oauth2Module = oauth2Module
        }
    }
}