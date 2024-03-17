# ML2 - Session 1

## 1: ML intro (theory + discussion)

- quick intro: name and previous study
- start with the business problem and look for tools that could solve them
- basic ingredients for an ML model (quick recap)
- case study: bike share demand
    - loss function:
        - need a cutoff / benchmark
        - MSE is symmetric - we might need an asymmetric one
    - train/test split is tricky for time-series data


## 2: basic models + diagnostics & feature engineering (work on their own + prepared notebook)

- Work-on-their-own: benchmark evaluation (avg calculation is just a function of data as is every other ML model)
- overfit on flexible linear data -> run LASSO to overcome the problem
- visual recap of tree: it can get non-linearities on its own
- feature engineering: extract more info from the data available

--> todo: write step-by-step guide with conceptual and technical learnings

## 3: flexible models & more data (work on their own + prepared notebook)

- visual recap of known flexible models: random forest & gradient boosting
- flexible models could work well on smaller data as well (compare RF to flexible LASSO)
- adding more data does not help on rigid models - but they do on flexible ones
- submit to Kaggle: realize that 33% relative loss is the best we can do given the data


## Lessons

- Part #3 was omitted, even for tree there was no time
- More discussion is needed about Pipelines - include feature engineering step in that?