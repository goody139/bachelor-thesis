# bachelor-thesis
This is the repository for the thesis ["Timing distributions of sequence elements for dendritic sequence processing"](./Thesis/Thesis_lgolla.pdf). 
It contains code for the experimental setup, Plotting Code, Modeling of Dendritic Branches and a naive classifier and all figures used in the thesis. The data of the results were too large to add them to Github so I uploaded them publicly available on [myshare](https://myshare.uni-osnabrueck.de/d/cdfafc7ce1b44167b049/).

The following image provides an overview of the designed system. For a detailed description and theoretical background of the individual components, refer the [thesis](./Thesis/Thesis_lgolla.pdf).


## Dendritic trees modeled 
![grafik](https://github.com/goody139/bachelor-thesis/assets/72889998/63cf264d-1802-4f59-89bd-38d9a10e0321)

![grafik](https://github.com/goody139/bachelor-thesis/assets/72889998/b935dd1c-0c66-484b-8c4c-53865f946d76)
![grafik](https://github.com/goody139/bachelor-thesis/assets/72889998/3638f42d-8c08-4e70-987b-1effc4336733)






## Naive Classifier 
![grafik](https://github.com/goody139/bachelor-thesis/assets/72889998/147e9f9e-73a0-4ff4-8e2d-cb1a225d83e4)


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



