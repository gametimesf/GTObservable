# GTObservable
### A simple, generic wrapper to help observe property value changes in Swift. 

## Installation

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

### Carthage

    github "gametimesf/GTObservable" == 1.0


To use, simply:

```
    let observableLoggedIn = GTObservable<Bool>(false)

    // observe all future changes 
    observableLoggedIn.observe(self) { [weak self] update in
      print("your value changed from \(update.oldValue) to \(update.newValue)")
    }

    // observe all future changes AND fire with the current value at observation time  
    observableLoggedIn.fireThenObserve(self) { [weak self] _ in }

```

Observers are safe, and will automatically unsubscribe when your observing  object is deallocated. 
