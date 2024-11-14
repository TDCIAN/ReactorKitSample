//
//  FruitReactor.swift
//  ReactorKitSample
//
//  Created by 김정민 on 11/14/24.
//

import Foundation
import ReactorKit

final class FruitReactor: Reactor {

    // MARK: Actions(From View)
    enum Action {
        case apple
        case banana
        case grape
    }
    
    // MARK: Mutations(Action -> state)
    enum Mutation {
        case changeLabelApple
        case changeLabelBanana
        case changeLabelGrape
        case setLoading(Bool)
    }
    
    // MARK: State
    struct State {
        var fruitName: String
        var isLoading: Bool
    }
    
    var initialState: State
    
    init() {
        self.initialState = State(
            fruitName: "선택되어진 과일 없음",
            isLoading: false
        )
    }
    
    // MARK: Action -> Mutation
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .apple:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.changeLabelApple)
                    .delay(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
            ])
        case .banana:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.changeLabelBanana)
                    .delay(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
            ])
        case .grape:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.changeLabelGrape)
                    .delay(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
            ])
        }
    }
    
    // MARK: Mutation -> State
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .changeLabelApple:
            state.fruitName = "사과"
        case .changeLabelBanana:
            state.fruitName = "바나나"
        case .changeLabelGrape:
            state.fruitName = "포도"
        case .setLoading(let value):
            state.isLoading = value
        }
        return state
    }
}
