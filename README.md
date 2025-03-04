# BKIFF: Black-winged Kite Improved Fuzzy Clustering

## 1. Introduction
BKIFF (Black-winged Kite Improved Fuzzy Clustering) is an advanced clustering algorithm for uncertain and imbalanced data. In the initialization phase, it integrates the Black-winged Kite Optimization (BKO) method with an Improved Fuzzy Clustering (IFF) framework to enhance accuracy, convergence, and stability.

BKIFF is particularly useful for clustering problems with uneven data distributions, such as medical diagnostics, ecological analysis, and complex data mining applications.

## 2. Key Features
- **BKO-Based Initialization Optimization:** Determines optimal initialization points instead of random selection, improving efficiency and stability.
- **Hellinger Distance Metric:** Enhances similarity measurement between probability density functions, ensuring better cluster differentiation.
The improved Fuzzy Clustering Framework (IFF) adjusts cluster weights to prevent smaller clusters from being overshadowed by larger ones.
- **Superior Performance:** Validated through extensive experiments on synthetic and real-world datasets, achieving an ARI of 1.00 even in highly imbalanced scenarios.
Versatile Applications: It is Suitable for medical data analysis, biological data clustering, image segmentation, and large-scale data mining.

## 3. Project Structure
The BKIFF project consists of the following main directories:
- **src/**: Contains the main source code for the BKIFF algorithm.
- **data/**: Sample datasets for testing the algorithm.
- **results/**: Stores the results of clustering experiments on various datasets.
- **docs/**: Documentation and experimental reports.
- **notebooks/**: Jupyter Notebooks for analysis and testing.

## 4. System Requirements
- MATLAB/Octave version 2024a or later.
- Operating System: Windows, Linux, or macOS.
- Required MATLAB toolboxes (if applicable), including Optimization Toolbox and Fuzzy Logic Toolbox.

## 5. Installation and Usage
1. **Clone the GitHub repository:**
   ```bash
   git clone https://github.com/hungtrannam/BKIFF.git
   ```
2. **Navigate to the project directory:**
   ```bash
   cd BKIFF
   ```
3. **Open MATLAB and add the project path:**
   ```matlab
   addpath(genpath('path_to_BKIFF_directory'));
   ```
4. **Run the algorithm on a test dataset:**
   ```matlab
   run('src/main.m');
   ```
5. **Customize input parameters:**
   - Adjust parameters such as the number of clusters (`c`), iterations (`maxIter`), and convergence threshold (`epsilon`) in `config.m`.

## 6. Experimentation and Performance Evaluation
### 6.1. Test Datasets
BKIFF has been tested on the following datasets:
- **Gaussian Synthetic Data:** Generates imbalanced probability distributions to evaluate algorithm performance.
- **Skewed Probability Functions:** Tests the algorithm's ability to handle skewed distributions.
- **Image-Based Clustering:** Applied in medical image analysis and image-based data clustering.

### 6.2. Evaluation Metrics
BKIFF's performance is measured using the following metrics:
- **Adjusted Rand Index (ARI):** Measures clustering accuracy.
- **Normalized Mutual Information (NMI):** Assesses the relationship between detected clusters and ground truth labels.
- **Execution Time:** Evaluates computational efficiency compared to other clustering algorithms.

## 7. Comparison with Other Methods
Below is a comparison of BKIFF's performance against other clustering methods:
| Method | ARI | NMI | Execution Time (seconds) |
|-------------|-----|-----|-----------------|
| K-means | 0.75 | 0.70 | 0.12 |
| Fuzzy C-Means (FCM) | 0.82 | 0.75 | 0.20 |
| Self-Updating Process | 0.95 | 0.90 | 0.50 |
| **BKIFF (Proposed)** | **1.00** | **1.00** | **0.08** |

## 8. Contact
For any questions or support requests, please contact:
- **Email:** [hungtrannam@vlu.edu.vn]
- **GitHub:** [https://github.com/hungtrannam/BKIFF]

---
Thank you for your interest in BKIFF! We welcome community contributions and feedback to further improve the algorithm.

