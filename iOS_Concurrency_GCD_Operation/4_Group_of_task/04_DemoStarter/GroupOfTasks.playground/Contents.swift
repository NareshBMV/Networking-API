import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true
//: # Group of Tasks
let workerQueue = DispatchQueue(label: "com.raywenderlich.worker", attributes: .concurrent)
let numberArray = [(0,1), (2,3), (4,5), (6,7), (8,9)]


//: ## Creating a group
print("=== Group of sync tasks ===\n")
// TODO: Create slowAddGroup
let slowAddGroup = DispatchGroup()

//: ## Dispatching to a group
// TODO: Loop to add slowAdd tasks to group
workerQueue.async(group: slowAddGroup, execute: DispatchWorkItem(block: {
    for intValue in numberArray {
        let result = slowAdd(intValue)
        print("Result : \(result)")
    }
}))


//: ## Notification of group completion
//: Will be called only when every task in the dispatch group has completed
let defaultQueue = DispatchQueue.global()
// TODO: Call notify method
slowAddGroup.notify(queue: defaultQueue, work: DispatchWorkItem(block: {
    print("SLOW ADD: Completed all tasks")
//    PlaygroundPage.current.finishExecution()
}))

//: ## Waiting for a group to complete
//: __DANGER__ This is synchronous and can block:
//:
//: This is a synchronous call on the __current__ queue, so will block it. You cannot have anything in the group that wants to use the current queue otherwise you'll deadlock.
// TODO: Call wait method
slowAddGroup.wait(timeout: DispatchTime.distantFuture)

//: ## Wrapping an existing Async API
//: All well and good for new APIs, but there are lots of async APIs that don't have group parameters. What can you do with them, so the group knows when they're *really* finished?
//:
//: Remember from the previous video, the `slowAdd` function we wrapped as an asynchronous function?

func asyncAdd(_ input: (Int, Int), runQueue: DispatchQueue, completionQueue: DispatchQueue,
              completion: @escaping (Int, Error?) -> ()) {
  runQueue.async {
    var error: Error?
    error = .none
    let result = slowAdd(input)
    completionQueue.async { completion(result, error) }
  }
}

//: Wrap `asyncAdd` function
// TODO: Create asyncAdd_Group
func asyncAddGroup(_ input: (Int, Int), group:DispatchGroup, runQueue: DispatchQueue, completionQueue: DispatchQueue, completion: @escaping (Int, Error?) -> ()) {
    group.enter()
    asyncAdd(input, runQueue: runQueue, completionQueue: completionQueue) { (result, error) in
        completion(result, error)
        group.leave()
    }
}





print("\n=== Group of async tasks ===\n")
let wrappedGroup = DispatchGroup()

for pair in numberArray {
  // TODO: use the new function here to calculate the sums of the array
    asyncAddGroup(pair, group: wrappedGroup, runQueue: defaultQueue, completionQueue: workerQueue, completion: { (result, error) in
        print("Result : \(result)")
    })
}

// TODO: Notify of completion
wrappedGroup.notify(queue: defaultQueue, work: DispatchWorkItem(block: {
    print("WRAPPED ASYNC ADD: Completed All the task")
//    PlaygroundPage.current.finishExecution()
}))
