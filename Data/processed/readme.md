# Processed data

This folder contains the **model-ready datasets** generated from the original data file `data/raw/datBDMORES.mat`.

The files stored here are produced by the scripts in `code/01_data_preparation/` and contain the transformed series used in the quantitative analysis. These transformations include deflation, per-capita conversion, detrending, and the construction of the transition paths required by Dynare.

In particular, the processed data may include:
- per-capita consumption,
- per-capita output,
- per-capita investment,
- employment,
- labour share,
- capital stock serie,
- wedge series,
- steady-state objects,
- and other inputs required for calibration, decomposition, and simulation.

These files are not raw source data. They are generated objects derived from the original series and should be reproducible by running the code in this repository.

Definitions of the original variables and the details of the data construction are provided in the **Data** section of the paper.

