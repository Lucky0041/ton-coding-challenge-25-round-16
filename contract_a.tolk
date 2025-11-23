// contract_a.tolk

// Main entry point
fun onInternalMessage(myBalance: int, msgValue: int, msg: cell, msgBody: slice) {
    // 1. Parse the message headers to check flags
    var cs = msg.beginParse();
    val flags = cs.loadUint(4); 

    // 2. Check if the message is a Bounced message
    // The first bit of the 4-bit flags indicates if it is bounced.
    if (flags & 1) {
        // --- HANDLE RICH BOUNCE HERE ---
        // This block executes when Contract B throws an error and the message bounces back.
        // In a real "Rich Bounce" scenario, you might parse the 
        // first 32 bits of msgBody to see the error code (0xFFFFFFFF) or arguments.
        
        return; // Successfully handled the bounce
    }

    // 3. If not bounced (Message from Wallet), send to Contract B
    
    // We assume the user sent the address of Contract B in the message body
    // so Contract A knows where to send the message.
    if (msgBody.remainingBits() < 267) {
        throw 101; // Invalid body, need destination address
    }
    val targetAddress = msgBody.loadAddress();

    // Construct the message to Contract B
    var msgToB = beginCell()
        .storeUint(0x18, 6) // Flags: 0x18 = 0b011000 (bounce: true, internal msg)
        .storeSlice(targetAddress)
        .storeCoins(0)      // Amount (will be overridden by mode 64)
        .storeUint(0, 1 + 4 + 4 + 64 + 32 + 1 + 1) // Default headers
        .storeUint(0, 32)   // Opcode (optional)
        .storeSlice("Trigger Bounce") // Comment
    .endCell();

    // Send the message
    // Mode 64: Carry all remaining inbound message value to Contract B
    sendRawMessage(msgToB, 64);
}
