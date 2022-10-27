# Welcome to the Repository with Scripts of the paper “User-Level Handover Decision Making Based on Machine Learning Approaches”

The paper, in a Letter format, covers a broad comparison of methods for classification and regression applications for a user-level handover decision making in scenarios with adverse propagation conditions involving buildings, coverage holes, and shadowing effects. The simulation campaigns are based on network simulator ns-3. The comparison encompasses classical machine learning approaches, such as KNN, SVM, and neural networks, but also state-of-the-art fuzzy logic systems and latter boosting machines. The results indicate that SVM and MLP are the most suitable for the classification of the best handover target, although fuzzy system SOFL can perform similarly with lower processing time. Additionally, for the download time estimation, LightGBM provides the smallest error with short processing time, even in hard propagation scenarios.

## Scripts Features

The scripts, written as Jupyter notebooks (.ipynb), and database are found in this repository. 

The scripts are split into classification and regression tasks, for Scenarios 1 and 2. 

In addition, the classification task employs Python and Matlab algorithms, whereas regression uses only Python. It is advised to start with 'python_classification_scenario01.ipynb'.

The Matlab files are all kept in a specific folder. Inside, you can find .mat variables used to feed our algorithms. These .mat files contain exactly the same data used in Python scripts.

The other files in root repository are the data collected from simulation campaigns in ns-3.

The database and the code are available to be reproduced, simply download the files to execute the codes as you prefer. Notice that one metric used in the algorithms evaluation was the processing time, which differs from machine to machine.

## Citation

If you use our scripts and dataset, please cite our JCIS papers. Here is a suitable BibTeX entry:

```python
@article{joao_2022, 
title={User-Level Handover Decision Making Based on Machine Learning Approaches}, 
volume={37},  
DOI={10.14209/jcis.2022.11}, 
number={1}, 
journal={Journal of Communication and Information Systems}, 
author={João P. S. H. Lima and Alvaro A. M. de Medeiros, Eduardo P. de Aguiar, Vicente A. de Sousa Jr. and Tarciana C. B. Guerra}, 
year={2022},  
pages={104--108} 
}
```

```python
@article{Cabral_2020, 
title={A Machine Learning Approach for Handover in LTE Networks with Signal Obstructions}, 
volume={35}, 
url={https://jcis.sbrt.org.br/jcis/article/view/715}, 
DOI={10.14209/jcis.2020.28}, 
number={1}, 
journal={Journal of Communication and Information Systems}, 
author={Cabral de Brito Guerra, Tarciana and Dantas, Ycaro and Sousa Jr, Vicente}, 
year={2020}, 
month={Nov.}, 
pages={271-289} 
}
```


## People
- João Paulo S. H. Lima
- A. M. de Medeiros
- Eduardo P. de Aguiar
- Vicente A. de Sousa Jr
- Tarciana C. B. Guerra

## Acknowledgments
- This study was financed in part by FUNTTEL/Finep and the Coordenação de Aperfeiçoamento de Pessoal de Nível Superior - Brasil (CAPES) - Finance Code 001;
- This work was supported by GppCom reasearch group [https://gppcom.ct.ufrn.br/](https://gppcom.ct.ufrn.br/);
- The proof of concept simulations provided by this Letter was supported by High Performance Computing Center (NPAD/UFRN).


<!--

## Related academic works
- Conference paper: Sistemas Fuzzy aplicados ao Handover em Redes LTE com Falhas de Cobertura (Link: [https://gppcom.ct.ufrn.br/index.php/2019/10/01/sistemas-fuzzy-aplicados-ao-handover-em-redes-lte-com-falhas-de-cobertura/](https://gppcom.ct.ufrn.br/index.php/2019/10/01/sistemas-fuzzy-aplicados-ao-handover-em-redes-lte-com-falhas-de-cobertura/));
- Conference paper: Handover Baseado em Aprendizado de Máquina para Redes LTE com Falhas de Cobertura (Link: [https://biblioteca.sbrt.org.br/articles/1947](https://biblioteca.sbrt.org.br/articles/1947)).
- Journal paper: A Machine Learning Approach for Handover in LTE Networks with Signal Obstructions (DOI: [https://doi.org/10.14209/jcis.2020.28](https://doi.org/10.14209/jcis.2020.28));
- Master Thesis: Machine learning based handover management for LTE Networks with coverage Holes (Link: [https://repositorio.ufrn.br/handle/123456789/26678](https://repositorio.ufrn.br/handle/123456789/26678));

# systems_notebooks
The scripts written as Jupyter notebooks (.ipynb) and database for paper 'User-Level Handover Decision Making Based on Machine Learning Algorithms' are found in this repository.
Authors:
- João Paulo S. H. Lima
- Álvaro A. M. de Medeiros
- Eduardo P. de Aguiar
- Vicente A. de Sousa Jr
- Tarciana C. B. Guerra

         
The scripts are divided in classification and regression tasks, for Scenarios 1 and 2.
In addition, the classification task employs Python and Matlab algorithms, whereas regression uses only Python.
It is advised to start with 'python_classification_scenario01.ipynb'.

The Matlab files are all kept in a specific folder. Inside, you can find .mat variables used to feed our
algorithms. These .mat files contain exactly the same data used in Python scripts.

The other files in root repository are the data collected from simulation campaigns in ns-3.

The database and the code are available to be reproduced, simply download the files to execute the codes as you prefer.
Notice that one metric used in the algorithms evaluation was the processing time, which differs from machine to machine.

Please cite our work.
Feel free to contact me at joao.lima@engenharia.ufjf.br
-->
