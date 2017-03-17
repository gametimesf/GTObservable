//
//  GTObservable.swift
//  GTObservable
//
//  Created by Matt Banach on 3/17/17.
//  Copyright © 2017 Gametime. All rights reserved.
//

import Foundation

infix operator <=: AssignmentPrecedence

class GTObserver<T> {
    let handler: GTObservable<T>.Closure

    private var fireCount: Int = 0

    init(closure : @escaping GTObservable<T>.Closure) {
        self.handler = closure
    }

    fileprivate func notify(oldValue: T, newValue: T) {
        fireCount = fireCount + 1
        handler(GTObservableUpdate(oldValue: oldValue, newValue: newValue, fireCount: fireCount))
    }
}

public struct GTObservable<T> {
    public typealias Closure = (_ result: GTObservableUpdate<T>) -> Void

    private var observers = NSMapTable<AnyObject, GTObserver<T>>.weakToStrongObjects()

    public var value: T {
        didSet {
            notify(newValue: value, oldValue: oldValue)
        }
    }

    public init(_ value: T) {
        self.value = value
    }

    func notify(newValue: T, oldValue: T) {
        observers.objectEnumerator()?.allObjects.forEach { uncastObserver in
            (uncastObserver as? GTObserver<T>)?.notify(oldValue: oldValue, newValue: newValue)
        }
    }

    @discardableResult public func fireThenObserve(_ observer: AnyObject, observerClosure : @escaping GTObservable<T>.Closure ) -> GTObservable {
        observe(observer, observerClosure: observerClosure)
        notify(newValue: value, oldValue: value)
        return self
    }

    @discardableResult public func observe(_ observer: AnyObject, observerClosure : @escaping GTObservable<T>.Closure ) -> GTObservable {
        observers.keyEnumerator().allObjects.forEach { object in
            precondition(object as AnyObject !== observer, "the instance \(observer) is already observing this")
        }

        observers.setObject(GTObserver<T>(closure: observerClosure), forKey: observer)
        return self
    }

    public func unsubscribe(_ observer: AnyObject) {
        observers.removeObject(forKey: observer)
    }
}

public func <=<T>(left: inout GTObservable<T>?, right: T) {
    left?.value = right
}

public func <=<T>(left: inout T, right: GTObservable<T>) {
    left = right.value
}

public struct GTObservableUpdate<T> {
    public let oldValue: T
    public let newValue: T
    fileprivate let fireCount: Int

    public var isFirstFire: Bool {
        return fireCount == 1
    }
}
