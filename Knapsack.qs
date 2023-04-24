namespace Knapsack_Quantum {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Core;
    
    @EntryPoint()
    operation QuantumMain() : Unit {
        // KnapsackEnergy() operation, providing an angle and number of iterations
        // let parameter = [3.14, 0.0, 0.0, 0.0, 3.14];
        // let energy = KnapsackEnergy(parameter, 100);
        let parameter = [0.0];
        let energy = KnapsackEntanglement(parameter, 100);
        Message($"Energy: {energy}");
    }
    
    operation KnapsackEnergy(parameter : Double[], iterations : Int) : Double {
        // Define a mutable variable to keep a running total for averaging
        mutable sum = 0;
        
        // Find the number of qubits to be parameterized
        let nQubits = Length(parameter);

        // Define mutable arrays for calculating spins
        mutable s = new Int[nQubits];
        
        using ( q = Qubit[nQubits] ) {
            // Allocate an array of qubits that begin in the |000> state
            for (iter in 1..iterations) {
                // Rotate the state of each qubit
                for (i in 0..nQubits - 1) {
                    Rx(parameter[i], q[i]);
                }
                
                // For each qubit, measure the state and convert it to a spin value
                for (i in 0..nQubits - 1) {
                    let result = M(q[i]);
                    let m = ResultArrayAsInt([result]);
                    set s w/= i <- m;
                }
                
                // Calculate the total energy from the spin values
                // 2kg is weight of item 1, 1kg is weight of item 1 and 2
                let energy = 1000 * (1 - (s[3] + s[4])) + 1000 * (1 * s[3] + 2 * s[4] - 2 * s[0] - 1 * s[1] - 1 * s[2])^2 - (500 * s[0] + 200 * s[1] + 400 * s[2]);
                // 500 is value of item 1, 200 value of item 2, 400 value for item 3
                set sum = sum + energy;
                       
                // Reset all the qubits to the |0> state
                ResetAll(q);
            }   
        }
        // Calculate the average energy over all iterations.
        let average = IntAsDouble(sum)/IntAsDouble(iterations);
        return average;
    }

    operation KnapsackEntanglement(parameter : Double[], iterations : Int) : Double {
        // Define a mutable variable to keep a running total for averaging
        mutable sum = 0;

        // Find the number of qubits to be parameterized
        let nQubits = 5;

        // Define a mutable array for calculating spins
        mutable s = new Int[nQubits];

        using ( q = Qubit[nQubits] ) {
            // Allocate an array of qubits that begin in the |000> state
            for (iter in 1..iterations) { 
                // Rotate the state of q[1]
                Rx(parameter[0], q[1]);

                // Entangle the qubits together using CNOT operations
                CNOT(q[1], q[2]);
                CNOT(q[2], q[4]);

                // For each qubit, measure the state and convert it to a spin value
                for (i in 0..nQubits - 1) {
                    let result = M(q[i]);
                    let m = ResultArrayAsInt([result]);
                    set s w/= i <- m;
                }

                // Calculate the total energy from the spin values
                let energy = 1000 * (1 - s[3] - s[4])^2 + 1000 * (-2 * s[0] - 1 * s[1] - 1 * s[2] + 1 * s[3] + 2 * s[4])^2 - (500 * s[0] + 200 * s[1] + 400 * s[2]);
                set sum = sum + energy;

                // Reset all the qubits to the |0> state
                ResetAll(q);
            }   
        }
        // Calculate the average energy over all iterations.
        let average = IntAsDouble(sum)/IntAsDouble(iterations);
        return average;
    }
}

// There won't always be an entanglement shortcut when solving a problem, and 
// the entangling block always needs to be designed to fit the problem at hand. Whether or not entanglement can provide a general speedup to solving problems without the careful 
// tailoring of entanglement that we’ve done here is still an active area of research. However, when the minimum configuration we are searching 
// for is itself an entangled state 
// (such as in real quantum systems like molecules), an entangling block is necessary to solve the problem, as we'll see in the next lesson.
