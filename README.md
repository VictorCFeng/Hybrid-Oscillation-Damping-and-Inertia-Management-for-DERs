# DER Dynamic Simulation and Stability Analysis

The code and data provided here are associated with the paper **"Hybrid Oscillation Damping and Inertia Management for Distributed Energy Resources"**. If you use this code in your research or applications, please remember to cite the paper and any other relevant literature.

## Overview

### Simulation Data
- **.m Files:**  
  Each `sim_m_casexxxxxx.m` file in this repository includes the simulation data necessary for running the analysis. This data encompasses network line parameters and DER control parameters (both inner and outer loop settings).
- **.mat Files:**  
  Each `.mat` file contains the corresponding inertia and damping values, which you can adjust according to your own requirements.

### Stability Analysis Procedure
- **Initialization:**  
  The simulation must be started with a stable operating point. The provided data files ensure that the initial solution is stable.
- **Switching and Testing:**  
  After initialization, the simulation switches to a designated solution to determine small-signal stability. The switching times are controlled by the parameters `t_gfl` and `t_gfm` in the code.

## Additional Features

- **MATPOWER Data Format:**  
  Several network data files are provided following the MATPOWER data format. This ensures compatibility and ease of use with other power system analysis tools.
- **Kron Reduction Function:**  
  A dedicated function for performing Kron reduction is included. This utility facilitates the necessary network reduction calculations, streamlining the process for your analysis.
- **Unit Conversion Notice:**  
  **Important:** Be cautious with the conversion between normal values and per unit (p.u.) values. Incorrect conversions can lead to significant errors in your simulation results. Always verify that the values are properly converted before running your analysis.
- **Dynamic Load Simulation:**  
  **Note:** When simulating dynamic loads, it is essential to add a very large impedance to each line. This is necessary because Simulink constructs the associated load as a current source, which may lead to errors if the impedance is not properly added.

## Getting Started

### Prerequisites
- **MATLAB 2024b** (or a compatible environment that supports `.m` and `.mat` files)
- **[Optional] MATPOWER** (if you plan to use the network data files in conjunction with MATPOWER-based tools)

### Running the Simulation
1. **Setup:**  
   Ensure that the simulation environment is properly configured and that you have the necessary data files (both `.m` and `.mat` files).
2. **Initialization:**  
   Run the initialization script to load the stable operating point. Verify that the system starts in a stable state.
3. **Switching for Stability Test:**  
   The simulation will automatically switch to the designated solution after initialization. This switch (controlled by `t_gfl` and `t_gfm`) will test if the system maintains small-signal stability.
4. **Adjustments:**  
   Modify inertia and damping values within the `.mat` files as required for your specific scenarios.

---

We hope this tool assists you in your research and development efforts in the field of DER dynamic analysis and stability.

