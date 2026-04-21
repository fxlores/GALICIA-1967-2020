# Wedge computation

This folder contains the files used to recover the wedges from the model:

- `wedgescomputation.mod`
- `post_wedgecomputation.m`

The Dynare file `wedgescomputation.mod` implements the wedge-recovery step of the quantitative exercise. It defines the model, assigns parameter values, loads the steady-state objects from `EEGalicia`, uses `PathsGalicia` as the input data file, and solves the model under perfect foresight. In this setup, the observed paths of output, consumption, investment, labour, population growth, and labour shares are treated as given, and Dynare recovers the endogenous wedge series and the capital path consistent with the model. 

More specifically, the Dynare model solves for:

- the capital stock `k`,
- the efficiency wedge `A`,
- the household labour wedge `pi_h`,
- the firm labour wedge `pi_f`,
- the investment wedge `pi_x`,
- and the resource wedge `pi_g`, 

taking as exogenous inputs:

- output `y`,
- consumption `c`,
- investment `x`,
- labour `l`,
- population growth `pi_n`,
- and the labour share `sl`.

The file `post_wedgecomputation.m` should be run after Dynare has solved `wedgescomputation.mod` in MATLAB. Its purpose is to extract the simulated series from Dynare output objects, save the relevant processed files for subsequent exercises, and generate the figures associated with the wedge decomposition.

This stage of the replication pipeline uses as inputs the processed files generated in `code/01_data_preparation/`, in particular:

- `PathsGalicia`
- `EEGalicia`

The economic interpretation of the wedges and their role in the quantitative exercise are discussed in Section 4.3, **Wedges**, of the paper. The parameter values used in the Dynare file are consistent with the calibration described in Section 4.2, **Calibration**, of the paper. 

## Workflow

The wedge-computation stage should be run after the data-preparation step:

1. Run `code/01_data_preparation/preparation.m`.
2. Run `wedgescomputation.mod` with Dynare.
3. Run `post_wedgecomputation.m` in MATLAB to save the resulting files and produce the figures.

## Notes

`wedgescomputation.mod` solves the model using `perfect_foresight_setup` and `perfect_foresight_solver`, with `PathsGalicia` as the data input. It also loads steady-state and initialization objects from `EEGalicia`. 

For reproducibility and portability, output files and figures should be saved using repository-relative paths rather than machine-specific absolute paths.
