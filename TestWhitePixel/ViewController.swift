//
//  ViewController.swift
//  TestWhitePixel
//
//  Created by DoanDuyPhuong on 8/29/20.
//  Copyright © 2020 prox.com. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ObjectMapper
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ApiClient.test().observeOn(MainScheduler.instance).subscribe(onNext: { (listPost) in
            print(listPost)
        }, onError: nil, onCompleted: {
            print("onCompleted")
            }, onDisposed: nil).disposed(by: DisposeBag())
        
//        fetchFilms()
    }
    
//    private func getPost2() {
//        ApiClient.getpost2(userId: 1)
//            .observeOn(MainScheduler.instance)
//            .subscribe(onNext: { (post) in
//                print("Post: \(post)")
//            }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: DisposeBag())
//    }
    
    func fetchFilms() {
      // 1
      let request = AF.request("https://swapi.dev/api/films")
      // 2
      request.responseJSON { (data) in
        print(data)
      }
    }


}

