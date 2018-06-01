import UIKit
//: Specify indefinite execution to prevent the playground from killing background tasks when the "main" thread has completed.
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//: # Terminology
//: ## Using a Global Queue
// TODO: Get the .userInitiated global dispatch queue

let userQueue = DispatchQueue.global(qos: .userInitiated)

// TODO: Get the .default global dispatch queue

let defaultQueue = DispatchQueue.global()

// TODO: Get the main queue
let mainQueue = DispatchQueue.main
//: Some simple tasks:
func task1() {
  print("Task 1 started")
  // make task1 take longer than task2
  sleep(1)
  print("Task 1 finished")
}

func task2() {
  print("Task 2 started")
  print("Task 2 finished")
}

print("=== Starting userInitated global queue ===")

// TODO: Dispatch tasks onto the userInitated queue


duration {
    userQueue.async {
        task1()
    }
    userQueue.async {
        task2()
    }
}

sleep(2)
//: ## Using a Private Serial Queue
//: The only global serial queue is `DispatchQueue.main`, but you can create a private serial queue. Note that `.serial` is the default attribute for a private dispatch queue:
// TODO: Create mySerialQueue
let serialQueue = DispatchQueue(label: "com.serial.queue")

print("\n=== Starting mySerialQueue ===")
// TODO: Dispatch tasks onto mySerialQueue
duration {
    serialQueue.async {
        task1()
    }
    serialQueue.async {
        task2()
    }
}

sleep(2)
//: ## Creating a Private Concurrent Queue
//: To create a private __concurrent__ queue, specify the `.concurrent` attribute.
// TODO: Create workerQueue
let workerQueue = DispatchQueue(label: "com.concurrent.queue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
print("\n=== Starting workerQueue ===")
// TODO: Dispatch tasks onto workerQueue
workerQueue.async {
    task1()
}
workerQueue.async {
    task2()
}
//: ## Dispatching Work _Synchronously_
//: You have to be very careful calling a queue’s `sync` method because the _current_ thread has to wait until the task finishes running on the other queue. **Never** call sync on the **main** queue because that will deadlock your app!
//:
//: But sync is very useful for avoiding race conditions — if the queue is a serial queue, and it’s the only way to access an object, sync behaves as a _mutual exclusion lock_, guaranteeing consistent values.
//:
//: We can create a simple race condition by changing `value` asynchronously on a private queue, while displaying `value` on the current thread:

let queue = DispatchQueue(label: "com.serial.private.queue")
var value = 42


func changeValue() {
  sleep(1)
  value = 0
}
//: Run `changeValue()` asynchronously, and display `value` on the current thread
// TODO
queue.async {
    changeValue()
}
value

//: Now reset `value`, then run `changeValue()` __synchronously__, to block the current thread until the `changeValue` task has finished, thus removing the race condition:
// TODO
value = 42
queue.sync {
    changeValue()
}
value


sleep(2)
//: ## Playground vs App
//: In an app, the UI runs on `DispatchQueue.main`, but playgrounds run on the default global queue.
//:
//: In our playgrounds, we won't be doing work on the main queue:
print("\nRunning on main queue")
// TODO: Run a simple task on the main queue

mainQueue.async {
    let a = 6
    print("Main Queue Value : \(a)")
}


print("Running on default queue")
// TODO: Run a similar task on the default queue
defaultQueue.async {
    let a = 42
    print("Default Queue Value : \(a)")
}

// Allow time for sleeping tasks to finish before letting the playground finish execution:
sleep(3)
//PlaygroundPage.current.finishExecution()

