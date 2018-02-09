To run the GUI to detect videos

1. Change your Matlab current working directory to MatlabCode folder.
2. Run 'actionDetction.m' file.
3. The GUI will be opened.


To detect videos:
1. Select the technique (SIFT, STIP, OF)
2. As the train data is provided in the folders already, click load train data.
3. Click load test video to detect. (you can download from http://www.nada.kth.se/cvap/actions/)
4. After feature computation of test video click detect action to view the action detected.


Folders , files and information in them:

3DSift_ourfiles - train, test and related files for 3D sift
FeaturesTrain3DSift - training features acquired by 3D Sift
FeaturesTrainOpticalFlow - training features acquired by OF
FeaturesTrainSTIP - training features acquired by STIP
OpticalFlow - train, test and other related code of OF
STIp - train, test and other related code of STIP

actionDetection.m - main gui file
getAccuracy3DSift - to get accuracy and confusion matrix for Sift
getAccuracyHOOF - to get accuracy and confusion matrix for OF
getAccuracySTIP - to get accuracy and confusion matrix for STIP

Cheers!