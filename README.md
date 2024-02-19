# Student-by-student-influences-in-tobacco-alcohol-and-cannabis-consumption-by-the-GVG-CNC-model

Reproducibility directory for the numerical results of the student-by-student influences in tobacco, alcohol and cannabis consumption by the GVG-CNC model

This repository is organized as follows. 

- Description.docx
Description file includes the details of the Glasgow-school data. In this repository, only certain input out of the whole dataset are used.

- Data files
    - Friendship network : fr1.csv, fr2.csv and fr3.csv
    - Selected individuals : sel129.csv
    - Alcohol consumption : alc.csv
    - Cannabis consumption : can.csv
    - Tabacco consumption : tbc.csv

- Programming code
    - 1.data_processing.m
    Matlab code for reading the above csv files and processing (remove NaN, reformat)
    - Project.exe 
    C++ executive files that implements GVG-CNC model
    - 2.run_IVANG.bat
    Bash code that integrated the parameters to run the C++ executive files.
    - 3.indirect_voting_configuration_comparision.ipynb
    Python notebook to compare the voting configuration and calculate some metrics of similarity.
    - 4.glasgow_network_analysis.ipynb
    Python notebook to generate network plots from the model, in addition to comparison with the original friendship network. 

- Results
    - graph_data_school.txt, v_data_school.txt, graph_school.csv
    Network and feature data generated after running 1.data_processing.m
    
    - conf5_numpy.csv and conf5_enemy.csv
    The network of friends and enemies respectively in 5th configuration setting. 

    - conf1.csv, conf2.csv, ..., conf7.csv
    The calculated network (in addition to other variables of the GVG-CNC model) based on different configuration settings.

    - various network plot png files
    The network plots of the calculated networks 
