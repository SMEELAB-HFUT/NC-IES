clear all;clc;close all;
[x]=xlsread('G:\Kmeans','C2:E288');
[idx,C]=kmeans(x,4,'replicate',10,'display','final');
silhouette(x,idx);










