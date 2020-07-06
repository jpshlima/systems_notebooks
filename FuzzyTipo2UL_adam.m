%Programa Fuzzy Tipo-2 treinado por algoritmo Adam
clear
close all
clc

tic;

%Definição de parâmetros
epn=100; %número de épocas
numParam  = 12; %número de atributos
Nvez=33;
Nnfold=5;
acerto_teste=zeros(Nnfold+5*(Nvez-1),1);

for vez=1:Nvez
     BD = GerarBanco;
    
for nfold=1:Nnfold
    
    clear saidateste;
    
    xcd=BD{nfold,1};
    des_out=BD{nfold,2};
    xcd_teste=BD{nfold,3};
    des_out_teste=BD{nfold,4};

%REGRAS

%regra 1 para cada conjunto de dados - REVISAR A REGRA POIS TEM QUE EXISTIR
%DUAS MEDIAS
Mean1_1=mean(xcd(des_out==1,:))-0.08*mean(xcd(des_out==1,:));
Mean2_1=mean(xcd(des_out==1,:))+0.08*mean(xcd(des_out==1,:));
Var_1=var(xcd(des_out==1,:));

Mean1_2=mean(xcd(des_out==-1,:))-0.08*mean(xcd(des_out==-1,:));
Mean2_2=mean(xcd(des_out==-1,:))+0.08*mean(xcd(des_out==-1,:));
Var_2=var(xcd(des_out==-1,:));

%regra 2 para cada conjunto de dados
Mean1_1_regra2=0.2+Mean1_1;
Mean2_1_regra2=0.2+Mean2_1;
Var_1_regra2=1.8*Var_1;

Mean1_2_regra2=0.2+Mean1_2;
Mean2_2_regra2=0.2+Mean2_2;
Var_2_regra2=1.8*Var_2;

%matriz de regras
matme1=[Mean1_1;Mean1_1_regra2;Mean1_2;Mean1_2_regra2];
matme2=[Mean2_1;Mean2_1_regra2;Mean2_2;Mean2_2_regra2];
matstd=sqrt([Var_1;Var_1_regra2;Var_2;Var_2_regra2]);
teta=[1 1 -1 -1];
 
for LI=1:1:size(matme1,1)
    for KI=1:1:size(matme1,2)
        if (matme2(LI,KI))<(matme1(LI,KI))
            aux=matme2(LI,KI);
            matme2(LI,KI)=matme1(LI,KI);
            matme1(LI,KI)=aux;
        end
    end
end

alpha=0.01;
beta1=0.9;
beta2=0.999;
epsilon=10^-8;
t=0;
mome1=zeros(size(matme1,1),size(matme1,2));
mome2=zeros(size(matme2,1),size(matme2,2));
mostd=zeros(size(matstd,1),size(matstd,2));
moteta=zeros(size(teta,1),size(teta,2));
vme1=zeros(size(matme1,1),size(matme1,2));
vme2=zeros(size(matme2,1),size(matme2,2));
vstd=zeros(size(matstd,1),size(matstd,2));
vteta=zeros(size(teta,1),size(teta,2));

y=zeros(size(xcd,1),1);
saida1=zeros(size(xcd,1),1);

gradme1=zeros(size(matme1,1),numParam);
gradme2=zeros(size(matme2,1),numParam);
gradstd=zeros(size(matstd,1),numParam);
gradteta=zeros(1,size(teta,2));

for Iepn=1:1:epn
    for NN=1:1:size(xcd,1)
        t=t+1;
        
        for LI=1:1:size(matme1,1)
            for KI=1:1:size(matme1,2)
                if (matme2(LI,KI))<(matme1(LI,KI))
                    aux=matme2(LI,KI);
                    matme2(LI,KI)=matme1(LI,KI);
                    matme1(LI,KI)=aux;
                end
            end
        end
        
        E1=zeros(size(matme1,1),numParam);
        E2=zeros(size(matme1,1),numParam);
        
        for l=1:1:size(matstd,1)
            E1(l,:)=uppMBF(xcd(NN,:),matme1(l,:),matme2(l,:),matstd(l,:));
            E2(l,:)=lwrMBF(xcd(NN,:),matme1(l,:),matme2(l,:),matstd(l,:));
        end
        E1=E1';
        E2=E2';
        %calculando Y1
        if(numParam==1)
            num1=E1;
        else
            num1=prod(E1);
        end
        den1=sum(num1);
        if den1==0
            den1=0.00001;
        end
        phi1=(num1/den1)';
        Y1=(teta*num1')/den1;
        
        %calculando Y2
        if(numParam==1)
            num2=E2;
        else
            num2=prod(E2);
        end
        den2=sum(num2);
        if den2==0
            den2=0.00001;
        end
        phi2=(num2/den2)';
        Y2=(teta*num2')/den2;
        
        %calculo da saida
        y(NN,1)=(Y1+Y2)/2;
        
        if y(NN,1)>=0
            saida1(NN,1)=1; %sem disturbio
        else
            saida1(NN,1)=-1; %sem disturbio
        end
        
        %calculando o gradiente da média 1
        for l=1:1:size(matme1,1)
            for k=1:1:size(matme1,2)
                if (xcd(NN,k)<matme1(l,k))
                    gradme1(l,k)=(0.5)*(y(NN,1)-des_out(NN,1))*((teta(1,l)-Y1)*phi1(l,1)*((xcd(NN,k)-matme1(l,k))/((matstd(l,k)^2)))+...
                    ((teta(1,l)-Y2)*phi2(l,1))*0);
                elseif (xcd(NN,k)>=matme1(l,k) && xcd(NN,k)<=matme2(l,k) && xcd(NN,k)<=(matme1(l,k)+matme2(l,k))/2)
                    gradme1(l,k)=(0.5)*(y(NN,1)-des_out(NN,1))*((teta(1,l)-Y1)*phi1(l,1)*0+...
                    ((teta(1,l)-Y2)*phi2(l,1))*0);
                elseif (xcd(NN,k)>=matme1(l,k) && xcd(NN,k)<=matme2(l,k) && xcd(NN,k)>(matme1(l,k)+matme2(l,k))/2)
                    gradme1(l,k)=(0.5)*(y(NN,1)-des_out(NN,1))*((teta(1,l)-Y1)*phi1(l,1)*0+...
                    ((teta(1,l)-Y2)*phi2(l,1))*((xcd(NN,k)-matme1(l,k))/((matstd(l,k)^2))));
                elseif (xcd(NN,k)>matme2(l,k))
                    gradme1(l,k)=(0.5)*(y(NN,1)-des_out(NN,1))*((teta(1,l)-Y1)*phi1(l,1)*0+...
                    ((teta(1,l)-Y2)*phi2(l,1))*((xcd(NN,k)-matme1(l,k))/((matstd(l,k)^2))));                    
                end
%                     gradme1(l,k)=(0.5)*(y(NN)-des_out(NN))*((teta(1,l)-Y1)*phi1(l,1)+(teta(1,l)-Y2)*phi2(l,1))*((xcd(NN,k)-matme1(l,k))/((matstd(l,k)^2)));
            end
        end
        
        %calculando o gradiente da média 2
        for l=1:1:size(matme2,1)
            for k=1:1:size(matme2,2)
                if (xcd(NN,k)<matme1(l,k))
                    gradme2(l,k)=(0.5)*(y(NN,1)-des_out(NN,1))*((teta(1,l)-Y1)*phi1(l,1)*0+...
                    ((teta(1,l)-Y2)*phi2(l,1))*((xcd(NN,k)-matme2(l,k))/((matstd(l,k)^2))));
                elseif (xcd(NN,k)>=matme1(l,k) && xcd(NN,k)<=matme2(l,k) && xcd(NN,k)<=(matme1(l,k)+matme2(l,k))/2)
                    gradme2(l,k)=(0.5)*(y(NN,1)-des_out(NN,1))*((teta(1,l)-Y1)*phi1(l,1)*0+...
                    ((teta(1,l)-Y2)*phi2(l,1))*((xcd(NN,k)-matme2(l,k))/((matstd(l,k)^2))));
                elseif (xcd(NN,k)>=matme1(l,k) && xcd(NN,k)<=matme2(l,k) && xcd(NN,k)>(matme1(l,k)+matme2(l,k))/2)
                    gradme2(l,k)=(0.5)*(y(NN,1)-des_out(NN,1))*((teta(1,l)-Y1)*phi1(l,1)*0+...
                    ((teta(1,l)-Y2)*phi2(l,1))*0);
                elseif (xcd(NN,k)>matme2(l,k))
                    gradme2(l,k)=(0.5)*(y(NN,1)-des_out(NN,1))*((teta(1,l)-Y1)*phi1(l,1)*((xcd(NN,k)-matme2(l,k))/((matstd(l,k)^2)))+...
                    ((teta(1,l)-Y2)*phi2(l,1))*0);                    
                end
%                 gradme2(l,k)=(0.5)*(y(NN)-des_out(NN))*((teta(1,l)-Y1)*phi1(l,1)+(teta(1,l)-Y2)*phi2(l,1))*((xcd(NN,k)-matme2(l,k))/((matstd(l,k)^2)));
            end
        end
        
        %calculando o gradiente de sigma
        for l=1:1:size(matstd,1)
            for k=1:1:size(matstd,2)
                if (xcd(NN,k)<matme1(l,k))
                    gradstd(l,k)=(0.5)*(y(NN,1)-des_out(NN,1))*((teta(1,l)-Y1)*phi1(l,1)*(((xcd(NN,k)-matme1(l,k))^2)/((matstd(l,k)^3)))+...
                    ((teta(1,l)-Y2)*phi2(l,1))*(((xcd(NN,k)-matme2(l,k))^2)/((matstd(l,k)^3))));
                elseif (xcd(NN,k)>=matme1(l,k) && xcd(NN,k)<=matme2(l,k) && xcd(NN,k)<=(matme1(l,k)+matme2(l,k))/2)
                    gradstd(l,k)=(0.5)*(y(NN,1)-des_out(NN,1))*((teta(1,l)-Y1)*phi1(l,1)*0+...
                    ((teta(1,l)-Y2)*phi2(l,1))*(((xcd(NN,k)-matme2(l,k))^2)/((matstd(l,k)^3))));
                elseif (xcd(NN,k)>=matme1(l,k) && xcd(NN,k)<=matme2(l,k) && xcd(NN,k)>(matme1(l,k)+matme2(l,k))/2)
                    gradstd(l,k)=(0.5)*(y(NN,1)-des_out(NN,1))*((teta(1,l)-Y1)*phi1(l,1)*0+...
                    ((teta(1,l)-Y2)*phi2(l,1))*(((xcd(NN,k)-matme1(l,k))^2)/((matstd(l,k)^3))));
                elseif (xcd(NN,k)>matme2(l,k))
                    gradstd(l,k)=(0.5)*(y(NN,1)-des_out(NN,1))*((teta(1,l)-Y1)*phi1(l,1)*(((xcd(NN,k)-matme2(l,k))^2)/((matstd(l,k)^3)))+...
                    ((teta(1,l)-Y2)*phi2(l,1))*(((xcd(NN,k)-matme1(l,k))^2)/((matstd(l,k)^3))));                    
                end
%                 gradstd(l,k)=(0.5)*(y(NN)-des_out(NN))*((((teta(1,l)-Y1)*phi1(l,1)+(teta(1,l)-Y2)*phi2(l,1)))*((((xcd(NN,k)-matme1(l,k))^2)/((matstd(l,k)^3))))+(((teta(1,l)-Y1)*phi2(l,1)+(teta(1,l)-Y2)*phi2(l,1))*(((xcd(NN,k)-matme2(l,k))^2)/((matstd(l,k)^3)))));
%                 gradstd(l,k)=(0.5)*(y(NN)-des_out(NN))*((((teta(1,l)-Y1)*phi1(l,1)+(teta(1,l)-Y2)*phi2(l,1)))*((((xcd(NN,k)-matme1(l,k))^2)/((matstd(l,k)^3))))+(((teta(1,l)-Y1)*phi2(l,1)+(teta(1,l)-Y2)*phi2(l,1))*(((xcd(NN,k)-matme2(l,k))^2)/((matstd(l,k)^3)))));
            end
        end
        
        %calculando o gradiente de teta
        for l=1:1:size(teta,2)
            gradteta(1,l)=0.5*(y(NN,1)-des_out(NN,1))*(phi1(l,1)+phi2(l,1));
        end
        
        %calculando o primeiro momento da média 1, da média 2, de sigma e de teta
        mome1=beta1*mome1+(1-beta1)*gradme1;
        mome2=beta1*mome2+(1-beta1)*gradme2;
        mostd=beta1*mostd+(1-beta1)*gradstd;
        moteta=beta1*moteta+(1-beta1)*gradteta;
        
        %calculando o segundo momento da média 1, da média 2, de sigma e de teta
        vme1=beta2*vme1+(1-beta2)*gradme1.^2;
        vme2=beta2*vme2+(1-beta2)*gradme2.^2;
        vstd=beta2*vstd+(1-beta2)*gradstd.^2;
        vteta=beta2*vteta+(1-beta2)*gradteta.^2;
        
        %calculando o primeiro momento corrigido da média 1, da média 2, de sigma e de teta
        mocme1=mome1./(1-beta1^t);
        mocme2=mome2./(1-beta1^t);
        mocstd=mostd./(1-beta1^t);
        mocteta=moteta./(1-beta1^t);
        
        %calculando o segundo momento corrigido da média 1, da média 2, de sigma e de teta
        vcme1=vme1./(1-beta2^t);
        vcme2=vme2./(1-beta2^t);
        vcstd=vstd./(1-beta2^t);
        vcteta=vteta./(1-beta2^t);
        
        %atualização dos parâmetros
        matme1=matme1-alpha*mocme1./(vcme1.^(1/2)+epsilon);
        matme2=matme2-alpha*mocme2./(vcme2.^(1/2)+epsilon);
        matstd=matstd-alpha*mocstd./(vcstd.^(1/2)+epsilon);
        teta=teta-alpha*mocteta./(vcteta.^(1/2)+epsilon);
               
    end
    
%     taxaClas(Iepn,vez)=100*((length(find((saida1'-des_out)==0))))/size(xcd,1);
%     if (Iepn==100)
%     fprintf('\nTaxa de acerto do Treino para o caso do TipoDist=%d %.2f%%',tipoDist,taxaClas(tipoDist,Iepn));
%     end

end

saidateste=zeros(size(xcd_teste,1),1);

for NN=1:1:size(xcd_teste,1)
    E1=zeros(size(matme1,1),numParam);
    E2=zeros(size(matme1,1),numParam);
    for l=1:1:size(matstd,1)
        E1(l,:)=uppMBF(xcd_teste(NN,:),matme1(l,:),matme2(l,:),matstd(l,:));
        E2(l,:)=lwrMBF(xcd_teste(NN,:),matme1(l,:),matme2(l,:),matstd(l,:));
    end
    E1=E1';
    E2=E2';
    %calculando Y1
    if(numParam==1)
        num1=E1;
    else
        num1=prod(E1);
    end
    den1=sum(num1);
    phi1=(num1/den1)';
    Y1=(teta*num1')/den1;
    
    %calculando Y2
    if(numParam==1)
        num2=E2;
    else
        num2=prod(E2);
    end
    den2=sum(num2);
    phi2=(num2/den2)';
    Y2=(teta*num2')/den2;
    
    %calculo da saida
    y(NN,1)=(Y1+Y2)/2;
    
    if y(NN,1)>=0
        saidateste(NN,1)=1; %sem disturbio
    else
        saidateste(NN,1)=-1; %sem disturbio
    end
    
end
    
%erro da validação
acerto_teste(nfold+5*(vez-1),1)=100*((length(find((saidateste-des_out_teste)==0))))/size(xcd_teste,1);

end %fim do nfold

end %fim das vezes

mean_acerto_teste=mean(acerto_teste);

std_acerto_teste=std(acerto_teste);

tempo=toc;
fprintf('\nMédia da taxa de acerto do Teste %.2f%%\n',mean_acerto_teste);
fprintf('\nDesvio padrão da taxa de acerto do Teste %.2f%\n',std_acerto_teste);
fprintf('\nTempo %.2f%\n',tempo);