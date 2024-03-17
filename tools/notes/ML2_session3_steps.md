# ML2 - Session 3

## 1: DL theory

- Quiz#2

- Some interactive questions about Neural Network
    - flexibility - compare to logit
    - sigmoid vs ReLU - vanishing gradient problem
    - how to ensure that outcomes are probabilities? softmax -- extending the logit logic to multiple classes: scales real numbers to 0-1 range with the constraint that they add up to 1

- Look at some examples in [tensorflow playground](https://playground.tensorflow.org/#activation=tanh&batchSize=10&dataset=circle&regDataset=reg-plane&learningRate=0.03&regularizationRate=0&noise=0&networkShape=4,2&seed=0.35061&showTestData=false&discretize=false&percTrainData=50&x=true&y=true&xTimesY=false&xSquared=false&ySquared=false&cosX=false&sinX=false&cosY=false&sinY=false&collectStats=false&problem=classification&initZero=false&hideText=false)
    - Example #0: Two separated bunch of points: ~linear model, no hidden layer
    - Example #1a: Circles dataset: 1 hidden layer with 3 neurons is enough
        - experiment with the learning rate [playground]
        (https://developers.google.com/machine-learning/crash-course/fitter/graph)
        - play around with this example: too slow learning vs too fast learning
        - show that too complex model could harm
    - Example #1b: Circles with noisy set (10% train-to-test ratio, 50 noise, with all features)
        - without regularization
        - with L1/L2 regularization
    - Example #2: Spiral dataset: go up to 3 hidden layers with 8-4-2 neurons -- Run several times to observe the inherent randomness of the training
        - Tanh, no regularization - partial result
        - ReLU, no regularization - works better (quicker convergence to better result)
        - increase the number of hidden layers: 8-8-4-4-2-2
    - What makes a problem hard?
        - complex relationships
        - multiple features
        - noisy outcome (small data, low signal-to-noise ratio)

## 2: DL in practice: keras & MNIST
- New business problem: image classification
    - talk about classification metrics -- is 99% accuracy good?
    - refresh false positive rate, true positive rate, confusion matrix -- mention ROC curve
- Estimate some neural networks on MNIST
    - start with logistic regression as benchmark
    - recreate logistic regression with a single neuron network

## 3: Extensions: convolution, transfer learning, embeddings, GPT(?)

## Lessons

