// contract_b.tolk

// Main entry point for internal messages
fun onInternalMessage(myBalance: int, msgValue: int, msg: cell, msgBody: slice) {
    // The task requires Contract B to error out on any message.
    // Throwing an exception with a non-zero code triggers a bounce
    // if the incoming message had the "bounce" flag set.
    
    throw 100; // Custom error code implies rejection
}
