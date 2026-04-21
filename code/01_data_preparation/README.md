# Data preparation

This folder contains `preparation.m`, the script that reads the original data from `data/raw/datBDMORES.mat` and transforms them into the model-ready inputs used in the paper.

The script performs the main data-construction steps of the replication pipeline. In particular, it:

- constructs per-capita consumption, output, and investment series,
- computes employment and labour shares,
- assigns values to the model parameters,
- detrends the data,
- recovers the capital stock path,
- computes the wedges used in the quantitative exercise,
- and builds the transition paths required by Dynare.

The script generates two processed files, which should be saved in `data/processed/`:

- `PathsGalicia`, containing the time paths of `A`, `pi_h`, `pi_f`, `pi_x`, `pi_n`, `pi_g`, `k`, `y`, `x`, `l`, `c`, and `sl`.
- `EEGalicia`, containing the steady-state and initialization objects `ye`, `xe`, `ce`, `le`, `ke`, `A_bar`, `pi_h_bar`, `pi_f_bar`, `pi_x_bar`, `pi_g_bar`, `pi_n_bar`, `sle`, and `K0`.

This script is the starting point of the quantitative analysis. Downstream scripts use these processed outputs for wedge decomposition, Dynare implementation, and counterfactual simulations.

Definitions of the original variables and the details of the data construction are provided in the **Data** section of the paper.
