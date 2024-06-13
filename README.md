# bachelor-thesis
This is the repository for the thesis ["Timing distributions of sequence elements for dendritic sequence processing"](./Thesis/Thesis_lgolla.pdf) containing related code and figures. The data of the results were too large to add them to Github so I uploaded them publicly available on [myshare](https://myshare.uni-osnabrueck.de/d/cdfafc7ce1b44167b049/). The following images provide an overview of the designed system. For a detailed description and theoretical background of the individual components, refer the [thesis](./Thesis/Thesis_lgolla.pdf).


## Abstract 
In recent years, dendritic sequence processing has gained increasing interest within computational neuroscience motivated by its potential to unravel neural computation, particularly in sequence detection and the creation of efficient systems for sequence detection and neuromorphic hardware design. This study investigates the robustness of Dendritic Trees with memory in classifying sequences under timing variations through empirical experimentation and computational modeling. Findings confirm the robustness conferred by plateau potentials and temporal overlaps, crucial to dendritic sequence processing. Evaluation metrics across varied Gaussian distribution parameters mean and standard deviation combinations support the system's effectiveness, achieving 70-80\% accuracy for the balanced and extra trial generation condition with an optimal plateau potential duration $\tau$. Factors such as the sequence pool $\alpha$, negative bias, and input timing dispersion influence system robustness. Limitations include the use of a simplified model and choice of input timing distribution. Future research should explore biorealistic models and alternative distributions, while investigating complex arborization's role and learning mechanisms for enhanced understanding of dendritic sequence processing.


## Dendritic trees modeled 
![this-1](https://github.com/goody139/bachelor-thesis/assets/72889998/154c8e13-ba2f-4dc0-ae4e-ca65a445a15c)








## Naive Classifier 
![grafik](https://github.com/goody139/bachelor-thesis/assets/72889998/147e9f9e-73a0-4ff4-8e2d-cb1a225d83e4)


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



