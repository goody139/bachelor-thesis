# bachelor-thesis
This is the repository for the thesis ["Timing distributions of sequence elements for dendritic sequence processing"](./Thesis/Thesis_lgolla.pdf). 
It contains code for the experimental setup, Plotting Code, Modeling of Dendritic Branches and a naive classifier and all figures used in the thesis. The data of the results were too large to add them to Github so I uploaded them publicly available on [myshare](https://myshare.uni-osnabrueck.de/d/cdfafc7ce1b44167b049/).

The following image provides an overview of the designed system. For a detailed description and theoretical background of the individual components, refer the [thesis](./filepath/Thesis_Final_Digital.pdf), and see the [receiver code](code/csi_receiver/) for the implementation. 
(![grafik](https://github.com/goody139/bachelor-thesis/assets/72889998/8b93438a-4576-4a2e-98fa-1b05c6c79c2d)
)


## Abstract 
*Insert Abstract here*

## Structure
The repository is structured as follows:

- `Thesis` : contains the thesis as a .pdf file and all figures used in thesis
- `Code`: contains the code used in the context of the thesis
    - DendriticBranches.jl : Module to handle modeled dendritic trees in Code
    - Experiments.jl : Modeling code & experimental setup for the experiments 
    - Manifest.toml & Project.toml : Dependencies and packages used in the project
    - Plotting.jl : Potting code used to generate final thesis plots
 
## Setup 
- Julia version 1.10.0
- For dependencies see [Project.toml](./Code/Project.toml) & [Manifest.toml](./Code/Manifest.toml)
- Packages
    - StatsBase
    - Distributions
    - Plots & StatsPlots
    - ROCAnalysis
    - Combinatorics
    - IterTools



