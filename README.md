# Meta-learning Suite (mtlSuite)

'mtlSuite' is an automated R code used to generate meta-learning experiments. Current version is based on [mlr](https://github.com/mlr-org/mlr) package [01] and supports:

* single and multi-target classification tasks;
* single and multi-target regression tasks;
* data scaling;
* meta-feature selection; and
* hyperparameter tuning of the meta-learners using a simple hyperspace definition;

### Installation

The installation process is via git clone. You should use the following command inside your terminal session:

```
git clone https://github.com/rgmantovani/mtlSuite
```

### General instructions

Meta-datasets must be placed into the ```data/``` sub-directory. First column must contain an id which describes meta-examples (this is not used by meta-learners). All the targets must be placed in the last columns of the dataset. The target meta-attributes must be identified with the keywork **Class**. If the input problem is multi-target, use the keyword as a prefix and differ the targets with unique names. For example:
```
# Single classification task [id | meta-features | Class]
# Single regression task     [id | meta-features | Class]

# Multi-target classification task [id | meta-features | Class.1 ... Class.N]
# Multi-target regression task     [id | meta-features | Class.1 ... Class.N]
```

### Options

Just few algorithms were initially added used but a lot of them may also be considered for experiments. 
If you would like to add a specific algorithm not available in the current version, please add the option in the ```R/config.R``` file. The names must be in accordance with ['mlr'](https://github.com/mlr-org/mlr) package implementation. 
A complete list of the available learners may be found [here](http://mlr-org.github.io/mlr-tutorial/release/html/integrated_learners/).

* *Tuning* - it is possible to perform a simple Random Search or use default hyperparameter values. 
Options: ```{random, none}```
* *Feature Selection* - it is possible to perform a Sequential Forward Search; Sequential Backward Search; Sequential Floating Forward Search; Sequential Floating Backward Search or none. 
Options: ``` {sfs, sbs, sffs, sfbs, none} ```
* *Data scaling* - scaled input dataset with mean = 0 and standard deviation = 0. Options: ```{TRUE, FALSE}```
* *Seed* - for reproducibility (seed > 1)

### Running the code

To run the project, please, call it by the following command:
```R
Rscript mainMTL.R --datafile=<datafile> --algo=<algo> --norm=<norm> --feat.sel=<featsel> --resamp=<resamp> \
  --tuning=<tuning> --seed=<seed>
# example:
#Rscript mainMTL.R --datafile="toy_iris" --algo="classif.rpart" --norm="FALSE" --feat.sel="none" --resamp="10-CV" \
#  --tuning="none" --seed="1" &
```
This example it will run the rpart classification algorithm on the data ``toy_iris``, not scaling data, not performing feature selection, not doing tuning, doing a 10-fold CV and definying the seed as 1. The output job will be saved at the ```output``` sub-directory.

<!--### Contact-->

<!--Rafael Gomes Mantovani (rgmantovani@gmail.com) University of São Paulo - São Carlos, Brazil. -->

### References

[01] B. Bischl, Michel Lang, Lars Kotthoff, Julia Schiffner, Jakob Richter, Erich Studerus, Giuseppe Casalicchio, Zachary Jones. 
mlr: Machine Learning in R. Journal of Machine Learning in R, v.17, n.170, 2016, pgs 1-5. URL: https://github.com/mlr-org/mlr.

