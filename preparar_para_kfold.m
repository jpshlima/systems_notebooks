clc
clear all
close all

load previsores2.mat;
load label2.mat;

M=previsores; 

microes=label';

microes(find(microes==2),1)=-1;

variavel_para_kfold=M;

variavel_para_kfold(:,13)=microes(:,1);

filename= 'variavel_para_kfold.mat';
save(filename, 'variavel_para_kfold');

