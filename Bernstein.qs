namespace Berstein_Problem {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    
    @EntryPoint()
    operation QuantumMain() : Unit {
        using ( (query, target) = (Qubit[5], Qubit()) ) { 
            // The state begins as query = |00000>, target = |0>
            
            // Prepare query and target for phase query
            StatePreparation(query, target);
            
            // Apply an Oracle using query and target.
            BVOracle(query, target);
            
            // Decode the string from the query qubits.
            DecodeString(query);
            
            MeasureAndMessage(target);
            ResetAll(query); Reset(target);
        }
    }
    operation DecodeString(query : Qubit[]) : Unit {
        // Decode the string a from the query qubits.
        mutable a = new Result[5];
        for (i in 0..4) {
            H(query[i]);
            Message($"Decoded String {i}: {M(query[i])}");
        }
    }
    operation StatePreparation(query : Qubit[], target : Qubit) : Unit {
        // Prepare qubits for phase query.
        for (i in 0 .. 4) {
            H(query[i]);
        }
        X(target); 
        H(target);
    }
    operation BVOracle(query : Qubit[], target : Qubit) : Unit {
        // Define string a
        let a = [RandomInt(2), RandomInt(2), RandomInt(2), RandomInt(2), RandomInt(2)];
        Message($"String a: {a}");
            
        // Output |x, y + a.x mod 2>
        for (i in 0 .. 4) {
            if (a[i] == 1) {
                CNOT(query[i], target);
            }
        }
    }
    operation MeasureAndMessage(target : Qubit) : Unit {
        let resultTarget = M(target);
        Message($"Target Qubit: {resultTarget}");
    }
}