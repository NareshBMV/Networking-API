import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//: # Operation
//: An `Operation` represents a 'unit of work', and can be constructed as a `BlockOperation` or as a custom subclass of `Operation`.
//: ## BlockOperation
//:Block Operation : Manages concurrent execution of one or more blocks on a default global queue , has advantages over dispatch queues such as operation dependency, KVO notification, cancelling and dispatch. Its a Object oriented wrapper for Operation. Behaves like dispatch groups, used to track group of executing blocks, runs concurrently, if want to run serially has to submit to private dispatch queue

//:Operation runs synchronously by default and could dispatch to gcd queue for asynchronous operation but can also be achieved by operation queue class.

//:Block operations are alternative to gcd if apps already using operations and can work for simple operations and acts as dispatch groups and is mainly of simple operation, If needed for more complex operation then we should operation subclass
//: Create a `BlockOperation` to add two numbers
var result: Int?
// TODO: Create and run summationOperation
let summationOperation = BlockOperation {
    result = 2 + 3
    sleep(3)
}
duration {
    summationOperation.start()
}
result



let session = URLSession(configuration: .default)
var image:UIImage?
let dispatchGroup = DispatchGroup()
dispatchGroup.enter()
session.dataTask(with: URL.init(string: "https://americanheritagetrees.org/wp-content/uploads/2016/10/Forest.png")!) { (data, response, error) in
    image = UIImage(data: data!)
    dispatchGroup.leave()
}.resume()

dispatchGroup.notify(queue: DispatchQueue.global(), work: DispatchWorkItem(block: {
    _ = image
    print("After fetching image")
}))



//: Create a `BlockOperation` with multiple blocks:
// TODO: Create and run multiPrinter
let multiPrinter = BlockOperation()
multiPrinter.completionBlock = {
    print("All blocks successfully executed!!!")
}
multiPrinter.addExecutionBlock { print("Hello"); sleep(2) }
multiPrinter.addExecutionBlock { print("My"); sleep(2) }
multiPrinter.addExecutionBlock { print("Name"); sleep(2) }
multiPrinter.addExecutionBlock { print("Is"); sleep(2) }
multiPrinter.addExecutionBlock { print("Naresh"); sleep(2) }

duration {
//    multiPrinter.start()
}
//: ## Subclassing `Operation`
//: Allows you more control over precisely what the `Operation` is doing
let inputImage = UIImage(named: "dark_road_small.jpg")
// TODO: Create and run TiltShiftOperation
class TiltShiftOperation:Operation {
    var inputImage:UIImage?
    var outputImage:UIImage?
    
    override func main() {
        outputImage = tiltShift(image: inputImage)
    }
}

let tsop = TiltShiftOperation()
tsop.inputImage = inputImage

duration {
    tsop.start()
}
tsop.outputImage

//PlaygroundPage.current.finishExecution()

