namespace QuantumHello {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    
    @EntryPoint()
    operation QuantumMain() : Unit {
        for (i in 0 .. 99) {
            using ( q = Qubit() ) {
                Circuit(q);
                
                ResetQubit(q, i);
            } 
        }
    }
 
    operation Circuit(target : Qubit) : Unit {
        H(target); T(target); H(target);
    }
    
    operation ResetQubit(target : Qubit, factor :  Int) : Unit {
        let result = M(target);
        
        // Message($"Result: {result}");
        
        if (result == Zero) {
            // No operation is necessary, since the qubit is already in |0>
        } else {
            // Perform a quantum NOT gate to return the qubit from |1> to |0>
            X(target);
            Message($"Return value is 1 at iteration {factor}");
        }
    }
}

