@echo off

del conf1.txt
del conf2.txt
del conf3.txt
del conf4.txt
del conf5.txt
del conf6.txt
del conf7.txt
del output_solution.txt

Project1.exe 129 27 -1 "graph_data_school.txt" "v_data_school.txt" 1
rename output_solution.txt conf1.txt

Project1.exe 129 27 -1 "graph_data_school.txt" "v_data_school.txt" 2
rename output_solution.txt conf2.txt

Project1.exe 129 27 -1 "graph_data_school.txt" "v_data_school.txt" 3
rename output_solution.txt conf3.txt

Project1.exe 129 27 -1 "graph_data_school.txt" "v_data_school.txt" 4
rename output_solution.txt conf4.txt

Project1.exe 129 27 -1 "graph_data_school.txt" "v_data_school.txt" 5
rename output_solution.txt conf5.txt

Project1.exe 129 27 -1 "graph_data_school.txt" "v_data_school.txt" 6
rename output_solution.txt conf6.txt

Project1.exe 129 27 -1 "graph_data_school.txt" "v_data_school.txt" 7
rename output_solution.txt conf7.txt