//
//  ViewController.swift
//  RxSwiftSimple
//
//  Created by 韩艳锋 on 2018/1/22.
//  Copyright © 2018年 韩艳锋. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
         single()
        let usernameOutlet: UITextField! = UITextField()
        let usernameValid = usernameOutlet.rx.text.orEmpty
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
   
    }
    
    func single() {
        func getRepo(_ repo: String) -> Single<[String: Any]> {
            
            return Single<[String: Any]>.create { single in
                let url = URL(string: "https://api.github.com/repos/\(repo)")!
                let task = URLSession.shared.dataTask(with: url) {
                    data, _, error in
                    
                    if let error = error {
                        single(.error(error))
                        return
                    }
                    
                    guard let data = data,
                        let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
                        let result = json as? [String: Any] else {
                            let ee = NSError() as Error
                            single(.error(ee))
                            return
                    }
                    print("succed")
                    single(.success(result))
                }
                
                task.resume()
                
                return Disposables.create { task.cancel() }
            }
        }
        
        getRepo("ReactiveX/RxSwift").subscribe { (event) in
            print(event)
        }
    }
    
    func observable()  {
        let numbers: Observable<Int> = Observable.create { observer -> Disposable in
            observer.onNext(0)
            observer.onNext(1)
            observer.onNext(2)
            observer.onNext(3)
            observer.onNext(4)
            observer.onNext(5)
            observer.onNext(6)
            observer.onNext(7)
            observer.onNext(8)
            observer.onNext(9)
            observer.onCompleted()
            observer.onNext(10)
            print("`````")
            return Disposables.create()
        }
        print("开始观察1")
        numbers.subscribe { (Event) in
            print(Event)
        }.disposed(by: disposeBag)
        
        print("开始观察2")
        numbers.subscribe { (Event) in
            print(Event)
            }.disposed(by: disposeBag)
    }
    func map() {
        let sss = Variable<Int>(0)
        sss.value = 2
        sss.value = 2
        sss.asObservable()
            .map({ (int) -> String in
                return ["一", "二", "三"][int]
            })
            .subscribe { (event) in
                print(event)
            }
            .disposed(by: disposeBag)
        
        sss.value = 1
        sss.value = 1
        sss.value = 2

    }
    
    func flatMap() {
        let disposeBag = DisposeBag()
        Observable.of(Observable.of(1, 2, 3), Observable.of(4, 5))
            .flatMap({ observeable in
                return observeable
            })
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
    
    func flatMapLatestFlatMapFirst() {
        let disposeBag = DisposeBag()
        Observable.of(Observable.of(1, 2, 3), Observable.of(4, 5))
            .flatMapLatest({ observeable in
                return observeable
            })
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        Observable.of(Observable.of(1, 2, 3), Observable.of(4, 5))
            .flatMapFirst({ observeable in
                return observeable
            })
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
    }
}
