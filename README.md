# Feed the extracted tumour from CT Images in STL format. The programs finds the best angle for trocar insertion and the states (pre-set temperatures) for shape specific ablation.
The details on the algorithm can be found in the referenced article[1].
The database has been created by developing a new method detailed in article[2] This program utilises the database files (CoordsAndDistancesSymmetricCases.txt, CoordsAndDistancesUniqueCases.txt, and CoordsAndDistancesUniqueCasesBros.txt) and guesses the states of tines that should yield the tumour's shape specific ablation.
Sample stl file has been provided in ASMEImproved folder.
This is parallelised matlab code that has been teseted on intel Xeon E5 family processor having 10 physical cores supporting hyperthreading. 

#Reference:
1. Dhiman, Manoj, and Ramjee Repaka. "Algorithm to Avoid Normal Tissue Sacrifice and Thermal Injury of Neighbouring Organs During Radiofrequency Ablation of HCC Tumours    Treated Using a Multi-Tine Electrode With Separately Controlled Tines." ASME International Mechanical Engineering Congress and Exposition. Vol. 85598. American Society of  Mechanical Engineers, 2021.
Dhiman, Manoj, Aakash Kumar Kumawat, and Ramjee Repaka. "Directional ablation in radiofrequency ablation using a multi-tine electrode functioning in multipolar mode: An in-silico study using a finite set of states." Computers in Biology and Medicine 126 (2020): 104007.
