namespace Ising_Magnets {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Core;
    
    @EntryPoint()
    operation QuantumMain() : Unit {
        // SpinEnergy() operation, providing an angle and number of iterations
        let parameter = [0.0, 0.0, 0.0];
        let energy = SpinEnergy(parameter, 100, 1, 2);
        Message($"Average energy: {energy}");
    }
    
    // j is a constant that defines what type of interaction happens between neighbours
    // If j is positive there is an energetic benefit (i.e. ferromagnitism)

    // Constant h corresponds to an external magnetic field applied to the chain of spins 
    // If s is pos, biased towards +1 and if not, biased towards -1
    operation SpinEnergy(parameter : Double[], iterations : Int, j : Int, h : Int) : Double {  
        // Define a mutable variable to keep a running total for averaging
        mutable sum = 0;
        
        // Find the number of qubits to be parameterized
        let nQubits = Length(parameter);

        // Define a mutable array for calculating spins
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
                    set s w/= i <- 2 * m - 1;
                }
                
                // Code to calculate the energy of this spin configuration will be added here.
                // Calculate the total energy according to the spin model
                let energy = -j * (s[0] * s[1] + s[1] * s[2]) - h * (s[0] + s[1] + s[2]);
                set sum += energy;

                // Reset all the qubits to the |0> state
                ResetAll(q);
            }   
        }
        // Calculate the average energy over all iterations.
        let average = IntAsDouble(sum)/IntAsDouble(iterations);
        return average;
    }
}
