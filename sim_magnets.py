import qsharp
from Brilliant.Quantum.Operations import SpinEnergy
from scipy.optimize import minimize
from random import uniform
progress = []

# Define an objective function that calls the SpinEnergy operation
def objective(x):
    result = SpinEnergy.simulate(parameter = x.tolist(), 
                               iterations = 100, 
                               j = 1, 
                               h = 0)
    # Record the energy to keep track of the optimization
    progress.append(result)
    return result
    
# Define a starting parameter
starting_parameters = [uniform(0,3.14), uniform(0,3.14), uniform(0,3.14)]

# Call the minimize function with the Powell classical optimizer method
result = minimize(objective, starting_parameters, method = 'Powell')

# Print the results
print("Minimum energy:", result.fun)
print("Minimum parameters:", result.x)

# Plot the progress of the optimization
import matplotlib.pyplot as plt
plt.plot(progress)
plt.xlabel("Number of energy evaluations")
plt.ylabel("Energy")
plt.savefig("progress.png")