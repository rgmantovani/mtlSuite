# Meta-learning Suite (mtlSuite)

'mtlSuite' is an automated R code used to perform meta-learning experiments. Current version is based on [mlr](https://github.com/mlr-org/mlr) package [01] and supports:

* single and multi-target classification tasks;
* single and multi-target regression tasks;
* data scaling;
* data balancing;
* meta-feature selection; and
* hyperparameter tuning of the meta-learners using a simple hyperspace definition;

### Installation

The installation process is via git clone. You should use the following command inside your terminal session:

```
git clone https://github.com/rgmantovani/mtlSuite
```

### General instructions

Meta-datasets must be placed into the ```data/``` sub-directory. The first column must contain an **id** which describes the meta-examples (this is not used by meta-learners). All the targets must be placed in the last columns of the dataset. The target meta-attributes must be identified with the keyword **Class**. If the input problem is multi-target, use the keyword as a prefix and differ the targets with unique names. For example:
```
# datasets' header for single classification tasks       -> [id | meta-features | Class]
# datasets' header for single regression tasks           -> [id | meta-features | Class]
# datasets' header for multi-target classification tasks -> [id | meta-features | Class.1 ... Class.N]
# datasets' header for multi-target regression tasks     -> [id | meta-features | Class.1 ... Class.N]
```

### Options

Just a few algorithms were initially added used, but a lot of them may also be considered for experiments. 
If you would like to add a specific algorithm not available in the current version, please add the option in the ```R/config.R``` file. The names must be following ['mlr'](https://github.com/mlr-org/mlr) package implementation. 
A complete list of the available learners may be found [here](http://mlr-org.github.io/mlr-tutorial/release/html/integrated_learners/).

* *Tuning* - it is possible to perform a simple Random Search or use default hyperparameter values. 
Options: ```{random, none}```
* *Feature Selection* - there are search and filter methods options. Search methods available are: Sequential Forward Search (SFS); Sequential Backward Search (SBS); Sequential Floating Forward Search (SFFS); Sequential Floating Backward Search (SFBS). Filter methods available are: Information Gain and RELIEF [02]. If you don't want to use feature selection, just define your option as ``--feat.sel=none``.
Options: ```{sfs, sbs, sffs, sfbs, information.gain.x, relief.x, none} ```
* *Data scaling* - scaled input dataset with mean = 0 and standard deviation = 0. Options: ```{TRUE, FALSE}```
* *Data balancing* - if set, performs data balancing in the desired dataset. Available methods are: Oversampling, Undersampling, and SMOTE [03].
If you don't want to use data balancing, just define your option as ``--balancing=none``.
Options: ```{oversamp, undersamp, smote, none}```
* *Seed* - for reproducibility (seed > 1)

### Running the code

To run the project, please, call it by the following command:
```R
R CMD BATCH --no-save --no-restore '--args' --datafile=<datafile> --algo=<algo> --norm=<norm> --feat.sel=<featsel> \ 
  --resamp=<resamp> --tuning=<tuning> --balancing=<balancing> --seed=<seed> mainMTL.R <output.file>
# example:
# R CMD BATCH --no-save --no-restore '--args'--datafile="toy_iris" --algo="classif.rpart" --norm="FALSE" \ 
# --feat.sel="none" --resamp="10-CV" --tuning="none" --balancing="smote" --seed="1" mainMTL.R output.log &
```

This example will run the 'rpart' classification algorithm on the ``toy_iris`` data, not scaling it, not performing feature selection, 
doing a 10-fold CV, not performing tuning, using SMOTE for data balancing and seed equals to 1. By default, models are not exported. 
If you wish to save all the models generated during the execution, so you should add the option ``--models`` at the end of the command.

```R
# example:
# R CMD BATCH --no-save --no-restore '--args'--datafile="toy_iris" --algo="classif.rpart" --norm="FALSE" \ 
#--feat.sel="none" --resamp="10-CV" --tuning="none" --balancing="smote" --seed="1" --models mainMTL.R output.log &
```

The resultant files will be saved at the ```output``` sub-directory: one file with performances, one file with predictions, and one file with the optimization path (if tuning is selected).

### References

[01] B. Bischl, Michel Lang, Lars Kotthoff, Julia Schiffner, Jakob Richter, Erich Studerus, Giuseppe Casalicchio, Zachary Jones. 
"mlr: Machine Learning in R". Journal of Machine Learning in R, v.17, n.170, 2016, pgs 1-5. URL: https://github.com/mlr-org/mlr.

[02] I. Kononenko. "Estimating attributes: Analysis and extensions of RELIEF". Machine Learning: ECML-94. Lecture Notes in Computer Science. Springer, Berlin, Heidelberg. 784: 171–182. Available [here](https://link.springer.com/chapter/10.1007%2F3-540-57868-4_57).
 
[03] N. V. Chawla, K. W. Bowyer, L. O. Hall, W. P. Kegelmeyer. SMOTE: Synthetic Minority Over-sampling Technique. Journal of Artificial Intelligence Research, v.16, n.1, 2002 pgs 321-357. Available [here](https://arxiv.org/abs/1106.1813). 

If you would like to use our code, please cite it as:

```
@article{ ,
   title = "A meta-learning recommender system for hyperparameter tuning: Predicting when tuning improves SVM classifiers",
   journal = "Information Sciences",
   volume = "501",
   pages = "193 - 221",
   year = "2019",
   issn = "0020-0255",
   doi = "https://doi.org/10.1016/j.ins.2019.06.005",
   url = "http://www.sciencedirect.com/science/article/pii/S002002551930533X",
   author = "Rafael G. Mantovani and Andr{'e} L.D. Rossi and Edesio Alcoba{\c c}a and Joaquin Vanschoren and Andr{\'e} C.P.L.F. de Carvalho",
}
```

### Contact

Rafael Gomes Mantovani (rgmantovani@gmail.com) 
Federal Technology University - Paraná - Apucarana - PR, Brazil.
