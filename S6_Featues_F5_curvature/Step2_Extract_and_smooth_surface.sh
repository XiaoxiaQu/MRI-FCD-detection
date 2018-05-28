#!/bin/bash
##################
## std::cerr << "Usage: " << std::endl;
## std::cerr << argv[0] << std::endl;
## std::cerr << "[1]inputFilename .vtk"<< std::endl;
## std::cerr << "[2]Threshold (e.g. 0.5) for extract surface"<< std::endl;
## std::cerr << "[3]NumberOfIterations (e.g. 1,2, 3 or 50?)"<< std::endl;
## std::cerr << "[4]outputFilename .vtp"<< std::endl;
###################
Threshold=0.5
NumberOfIterations=10 
DIR="/media/xiaqu/HardDisk/research/MRI_FCD/Patient_T1_v2"
TolNum=10 # 10

for i in `seq 2 $TolNum`;do
NUM=`printf "%03d" $i`

Infile=$DIR"/Patient_"$NUM"/Hong2014/curvatures/Step1_GM_surface_2.vtk"
Outfile=$DIR"/Patient_"$NUM"/Hong2014/curvatures/Step2_GM_surface_1.vtp" 
## Patient_001: Number of points: 1374548

cd /media/xiaqu/HardDisk/research/MRI_FCD/Code_Exist_Methods/Hong2014/CODES/MarchingCubes_Smooth/bin/
./source $Infile $Threshold $NumberOfIterations $Outfile
echo "Computation is done in datasets NO."$NUM"."

done





