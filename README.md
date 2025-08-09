<<<<<<< HEAD
# BKIFF
=======
# BKIFF: Black-winged Kite Improved Fuzzy Clustering for Imbalanced Uncertain Data

## 1. Introduction

Black-winged Kite Improved Fuzzy Clustering (BKIFF) is an innovative clustering algorithm specifically designed to address challenges inherent in uncertain and highly imbalanced data. By integrating Black-winged Kite Optimization (BKO) into an Improved Fuzzy Clustering (IFF) framework, BKIFF substantially enhances clustering accuracy, convergence speed, and stability.

This method excels in handling datasets where traditional algorithms fail, particularly in scenarios involving uneven data distributions, such as medical diagnostics, ecological studies, and complex data mining applications.

## 2. Key Features

- **BKO-Based Optimal Initialization:** Employs BKO, a biologically inspired optimization strategy, to select superior initial clustering prototypes, significantly improving stability and convergence speed compared to random initialization.
- **Hellinger Distance Metric:** Utilizes the robust Hellinger distance for measuring similarity between probability density functions, ensuring better cluster differentiation and theoretical convergence supported by Zangwill’s theorem.
- **Adaptive Cluster Weighting (IFF):** Adjusts cluster weights dynamically, effectively mitigating the dominance of larger clusters and ensuring fair representation for minority clusters.
- **Exceptional Performance:** Proven through rigorous experimental validations on synthetic and real-world datasets, achieving perfect Adjusted Rand Index (ARI) and Normalized Mutual Information (NMI) scores even in scenarios with severe imbalances.
- **Broad Applicability:** Demonstrated effectiveness in medical diagnostics, biological data clustering, image segmentation, and large-scale data mining.

## 2. Project Structure

The BKIFF repository is structured as follows:
- **src/**: Source code implementing the BKIFF algorithm.
- **data/**: Contains sample datasets for algorithm testing.
- **results/**: Stores results from experiments.
- **docs/**: Project documentation, including experimental reports and technical notes.
- **notebooks/**: Interactive Jupyter Notebooks for algorithm testing and data analysis.

## 3. System Requirements

- **MATLAB/Octave:** Version 2024a or later.
- **Operating System:** Compatible with Windows, Linux, and macOS.
- **Toolboxes Required:** Optimization Toolbox and Fuzzy Logic Toolbox.

## 4. Installation and Usage

1. **Clone the repository:**
```bash
git clone https://github.com/hungtrannam/BKIFF.git
```

2. **Navigate into the directory:**
```bash
cd BKIFF
```

3. **Set up MATLAB environment:**
```matlab
addpath(genpath('path_to_BKIFF_directory'));
```

4. **Execute the main algorithm:**
```matlab
run('src/main.m');
```

5. **Parameter Customization:**
Adjust parameters in `config.m` to configure the clustering task:
- Number of clusters (`c`)
- Maximum iterations (`maxIter`)
- Convergence threshold (`epsilon`)

## 4. Experimental Validation

### 4.1 Test Datasets

The performance of BKIFF has been rigorously evaluated on:

- **Synthetic Gaussian Data:** Testing performance against controlled, imbalanced scenarios.
- **Skewed Probability Functions:** Assessing adaptability to complex distributions.
- **Real-world Image Data:** Evaluating practical applicability in image segmentation scenarios.

### 4.2 Evaluation Metrics

BKIFF's effectiveness is measured using:

- **Adjusted Rand Index (ARI):** Evaluates clustering accuracy.
- **Normalized Mutual Information (NMI):** Assesses cluster consistency and integrity.
- **Computational Time:** Benchmarking efficiency against contemporary clustering methods.

## 5. Comparative Performance

BKIFF demonstrates superior performance compared to traditional and recent clustering methods, showcasing both accuracy and computational efficiency:

| Method                 | ARI  | NMI  | Execution Time (s) |
|------------------------|------|------|-------------------|
| K-means                | 0.75 | 0.70 | 0.12               |
| Fuzzy C-Means (FCM)    | 0.82 | 0.75 | 0.20              |
| Self-Updating Process  | 0.95 | 0.90 | 0.50              |
| **BKIFF (Proposed)**   | **1.00** | **1.00** | **0.08**  |

## 6. Advantages and Theoretical Contributions

- **Reduced Dependence on Randomness:** Significantly reduces instability due to random initialization.
- **Theoretical Convergence Guarantee:** Proven convergence via Zangwill’s theorem, ensuring robust theoretical underpinnings.
- **Enhanced Clustering Stability:** Provides consistent and reliable clustering in highly imbalanced and uncertain scenarios.

## 7. References

Theoretical details and methodological justifications are further elaborated in the associated paper:

> Tran-Nam, H., & Che-Ngoc, H. (2025). *Black-winged Kite Improved Fuzzy Clustering Handling Imbalanced Uncertain Data.*

## 8. Contact and Support

For support, questions, or contributions, please reach out to:
- **Hung Tran-Nam:** [hung.trannam@vlu.edu.vn](mailto:hung.trannam@vlu.edu.vn)
- **Project Repository:** [GitHub](https://github.com/hungtrannam/BKIFF)

---

Thank you for your interest in the BKIFF project. We welcome collaboration, contributions, and feedback from the community to further enhance this approach.

>>>>>>> dca88ce (First commit)
