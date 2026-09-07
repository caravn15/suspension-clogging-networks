# Clogging of Particle Suspensions in Networks

MATLAB code accompanying the paper:

**Neal, C. V., Hewitt, D. R., & Pearce, P.**  
*Clogging of particle suspensions in networks*

## Requirements

- **MATLAB** (tested in version **2025a**)

## Repository outputs

- Simulation/processed data are saved in `data/`
- Generated figures are saved in `images/`

## Running the figure simulations

Run scripts directly from MATLAB to reproduce figure results.

### Main manuscript figures

- `sc_main_fig_3`
- `sc_main_fig_4`
- `sc_main_fig_5`
- `sc_main_fig_6`

These scripts generate results for Figures 3–6 of the main manuscript.

### Supplementary material figures

- `sc_supp_mat_fig_S1`
- `sc_supp_mat_fig_S2`
- `sc_supp_mat_fig_S3`
- `sc_supp_mat_fig_S4`
- `sc_supp_mat_fig_S5`
- `sc_supp_mat_fig_S6`

These scripts generate results for Figures S1–S6 of the supplementary material.

## Network data

The network data for Figure 6 and Supplementary Figure 6 was generated according to the paper:

**Brown, E. E., Guy, A. A., Holroyd, N. A., Sweeney, P. W., Gourmet, L., Coleman, H., Walsh, C., Markaki, A. E., Shipley, R., Rajendram, R., & Walker-Samuel, S.**  
*Physics-informed deep generative learning for quantitative assessment of the retina*

The network was generated using RetinaGen within [RetinaSim](https://github.com/simonwalkersamuel/retinasim). The resultant data file `19_graph_250_vein_7_a2v.am` is contained within the folder `net/Brown-et-al-retina/`. This file was then converted into several text files (located in the same folder) in order to be read by MATLAB.

## Typical usage

1. Clone the repository:
   ```bash
   git clone https://github.com/caravn15/suspension-clogging-networks.git
   cd suspension-clogging-networks
   ```

2. Open MATLAB and set the repository root as the current working directory.

3. Run any of the scripts above, for example:
   ```matlab
   sc_main_fig_3
   ```
   or
   ```matlab
   sc_supp_mat_fig_S1
   ```

4. Check:
   - `data/` for saved data outputs
   - `images/` for generated figure files

## Authorship and third-party code

All code in this repository was written by **Cara V. Neal**, except:

- `parseArgs`
- `subaxis`

`parseArgs` and `subaxis` are copyright **© 2001–2014 Aslak Grinsted** and are free to modify.  
Please see the headers in those files for full copyright and permission details.

## Citation

If you use this repository, please cite:

> Neal, C. V., Hewitt, D. R., & Pearce, P. *Clogging of particle suspensions in networks*.
