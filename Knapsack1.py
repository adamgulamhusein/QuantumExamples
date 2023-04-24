import qsharp
from Knapsack_Quantum import KnapsackEnergy
from scipy.optimize import minimize

# Define an objective function that calls KnapsackEnergy
def objective(x):
    return KnapsackEnergy.simulate(parameter = x.tolist(), iterations = 100)

# Define a set of starting parameters
starting_parameters = [0.0, 0.0, 0.0, 0.0, 0.0]

# Call the classical minimizer
result = minimize(objective, starting_parameters, method = 'Powell')

print("Minimum energy:", result.fun)
print("Minimum parameters:", result.x)