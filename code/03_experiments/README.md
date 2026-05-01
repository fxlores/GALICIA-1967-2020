# Counterfactual Experiments and Model Solution

This folder contains the code used to solve the model and to perform the
counterfactual experiments reported in the paper
**“Drivers of Regional Economic Development: Technological Change versus
Market Distortions in Galicia (1967–2020)”**.

The main files are:

- `WGAGalicia.mod`
- `experiments.m`

Together, these files implement the solution of the model under perfect
foresight and the set of “no‑wedge” counterfactual experiments used in the
quantitative decomposition.

---

## `WGAGalicia.mod`

`WGAGalicia.mod` is the Dynare model file that solves the economy under
perfect foresight.

### Purpose

The model is used to compute equilibrium paths of output, consumption,
investment, labor, and the labor share given exogenous paths for the wedges.
In the counterfactual exercises, wedges are treated as deterministic
exogenous processes.

### Key features

- The model is solved using `perfect_foresight_setup` and
  `perfect_foresight_solver`.
- Capital, output, consumption, investment, labor, and the labor share are
  endogenous variables.
- The efficiency wedge, labor wedges, investment wedge, resource wedge, and
  population growth wedge enter as exogenous processes.
- Steady‑state objects and initial conditions are loaded from previously
  generated data files.
- The same model file is reused across experiments by fixing one wedge at a
  time while keeping the others at their estimated paths.

The numerical values of the parameters are fixed in the model file and are
consistent with the calibration described in the paper.

---

## `experiments.m`

`experiments.m` is a MATLAB script that automates the counterfactual
“no‑wedge” experiments.

### Purpose

The script evaluates the contribution of each wedge to observed
macroeconomic dynamics by sequentially shutting down individual wedges and
re‑solving the model.

### Workflow

The script performs the following steps:

1. **Model modification**  
   For each wedge (A, πₕ, πₓ, π_g, π_n, π_f), the script edits
   `WGAGalicia.mod` in place, fixing that wedge to a constant value while
   restoring previously modified wedges to their steady‑state levels.

2. **Model solution**  
   Dynare is called to solve the model under perfect foresight using the
   corresponding exogenous data file (e.g. `NoApaths`, `Nopihpaths`, etc.).
   Dynare is run with the option `noclearall` so that results from successive
   experiments are preserved.

3. **Extraction of simulated paths**  
   For each experiment, simulated paths of output, investment, labor, and
   labor share are extracted from Dynare’s output and stored for further
   analysis.

4. **Comparison with data**  
   Counterfactual paths are compared with observed data using log deviations
   from the initial year.

5. **Figures**  
   The script produces all figures reported in the paper, showing observed
   data together with the contributions of individual wedges. Shaded areas
   are used to highlight major recession periods.

6. **Summary statistics**  
   The script computes summary measures that quantify the similarity between
   observed and counterfactual paths:
   
