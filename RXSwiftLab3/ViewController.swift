//
//  ViewController.swift
//  RXSwiftLab3
//
//  Created by Eman Khaled on 29/09/2023.
//

import UIKit
import RxSwift
import RxCocoa

struct Person {
    var fullName: String
}
class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let peopleSubject = PublishSubject<[Person]>()
    private let disposeBag = DisposeBag()
    private var people = [Person]()
    override func viewDidLoad() {
        super.viewDidLoad()
        comineLatestTest()
        tableView.isEditing = true
        // private let peopleSubject = PublishSubject<[Person]>()
        people = [Person(fullName: "Esraa Eid"),
                  Person(fullName: "Mona Ahmed"),
                  Person(fullName: "Ahmed Essam")]
        
        // Bind the data to the table view
        peopleSubject
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) { _, person, cell in
                cell.textLabel?.text = person.fullName
            }
            .disposed(by: disposeBag)
        
        // Delete feature using RxSwift
        tableView.rx.modelDeleted(Person.self)
            .subscribe(onNext: { [weak self] person in
                if let index = self?.people.firstIndex(where: { $0.fullName == person.fullName }) {
                    self?.people.remove(at: index)
                    self?.peopleSubject.onNext(self?.people ?? [])
                }
            })
            .disposed(by: disposeBag)
        
        // Simulate expansion of data after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.people.append(Person(fullName: "Ali Gamal"))
            self.peopleSubject.onNext(self.people)
        }
        
        // Initial data emission
        peopleSubject.onNext(people)
    }
    //        people = [Person(fullName: "Esraa Eid"),
    //                         Person(fullName: "Mona Ahmed"),
    //                         Person(fullName: "Ahmed Essam")]
    //
    //               // Create an Observable to observe the people array
    //               let peopleObservable = Observable<[Person]>.just(people)
    //            .observe(on: MainScheduler.instance)
    //
    //               // Bind the data to the table view
    //               peopleObservable
    //                   .bind(to: tableView.rx.items(cellIdentifier: "cell")) { _, person, cell in
    //                       cell.textLabel?.text = person.fullName
    //                   }
    //                   .disposed(by: disposeBag)
    //
    //               // Delete feature using RxSwift
    //               tableView.rx.modelDeleted(Person.self)
    //                   .subscribe(onNext: { [weak self] person in
    //                       if let index = self?.people.firstIndex(where: { $0.fullName == person.fullName }) {
    //                           self?.people.remove(at: index)
    //                       }
    //                   })
    //                   .disposed(by: disposeBag)
    //
    //               // Simulate expansion of data after 2 seconds
    //               DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    //                   self.people.append(Person(fullName: "Ali Gamal"))
    //               }
    //
    
    
    
    func comineLatestTest(){
        
        // Create two BehaviorSubjects with initial values
        let subject1 = BehaviorSubject<Int>(value: 1)
        let subject2 = BehaviorSubject<Int>(value: 10)
        
        // CombineLatest to get the latest values from both subjects
        Observable.combineLatest(subject1, subject2)
            .subscribe(onNext: { (value1, value2) in
                print("Combined: \(value1), \(value2)")
            })
            .disposed(by: disposeBag)
        
        // Emit new values to the subjects
        subject1.onNext(2)
        subject2.onNext(20)
    }
}


