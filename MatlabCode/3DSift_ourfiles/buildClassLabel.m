function [ trainClass ] = buildClassLabel(name )
% function to build class labels depending on name

     if(strcmp(name(1,10:21),'handclapping'))
         trainClass = 2;
     elseif(strcmp(name(1,10:15),'boxing'))
         trainClass = 1;
     elseif(strcmp(name(1,10:19),'handwaving'))
         trainClass = 3;
     elseif(strcmp(name(1,10:16),'running'))
         trainClass = 5;
     elseif(strcmp(name(1,10:16),'jogging'))
         trainClass = 4;
     elseif(strcmp(name(1,10:16),'walking'))
         trainClass = 6;
     end


end

