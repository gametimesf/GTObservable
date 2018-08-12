# GTObservable
### Use GTObservable as a wrapper around your propeties making it easy to subscribe to their changes.  

## Installation

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

### Carthage

    github "gametimesf/GTObservable" == 1.1


To use, simply:

```swift
    var observableLoggedIn = GTObservable<Bool>(false)

    // observe all future changes 
    observableLoggedIn.observe(self) { [weak self] update in
      print("your value changed from \(update.oldValue) to \(update.newValue)")
    }

    // observe all future changes AND fire with the current value at observation time  
    observableLoggedIn.fireThenObserve(self) { [weak self] _ in }
    
    // update the value 
    observableLoggedIn.value = true

```

Observers are safe, and will automatically unsubscribe when your observing  object is deallocated. 
