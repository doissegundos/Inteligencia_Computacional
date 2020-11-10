clear;
clc;
//o dataset two classes possui 3 colunas, sendo 2 referentes as caracterisiticas de entrada e uma referente aos valores de saida.
//Este dataset contém duas classes sendo uma a com valores iguais a 1 e outra com valores iguais a -1
//Ler os dados do dataset e retorna a matriz X  e D
dataset = fscanfMat('C:\Users\STEFA\Desktop\ic\enviar\two_classes.dat'); //recebendo o dataset do aerogerador
function[X,D]=datasetform(len,dataset)
    X = dataset(:,1:2)';
    X = [(-1)*ones(1,len);X]; //adiconando o bias
    D = dataset(:,3)';
endfunction

//FASE1
//definindo os pesos aleatorios
function[wt]=W(num_neuronios,num_classes)
    wt = rand(num_neuronios,num_classes+1,'normal');
endfunction

//FASE 2
function[Z]=fase2(len,wt,X)
    ut = wt*X; //função de ativação
    Z = (1./(1+exp(-ut)));
    Z = [(-1)*ones(1,len);Z];
endfunction

num_neuronios = 30; //define o numero de neuronios ocutos
num_classes = 2;
len = 1000; //quantidade de amostras do dataset
[X D] = datasetform(len,dataset);

//FASE 1
//Recebe um vetor de pesos aleatorios
wt = W(num_neuronios,num_classes);

//FASE2
Z=fase2(len,wt,X);

//FASE 3
M = D*Z'*(Z*Z')^(-1); //metodo dos minimos quadrados

///////PLOTAR O GRÁFICO
//Separando as classes para a plotagem
class1 = dataset(1:500,1:2);
class2 = dataset(501:1000,1:2);

plot(class1(:,1),class1(:,2), 'y*')   
plot(class2(:,1),class2(:,2), 'r*')   


//Criando 1000 pontos do plano
x = linspace(0,4, 1000);
y = linspace(0,4, 1000);

//Fazendo a plotagem da curva de decisão
for i = 1:1000
    for j = 1:1000
        xm = [-1 x(i) y(j)]';
        zm = fase2(1,wt,xm);
        s = M*zm;
        
        if s <0.001 & s > -0.001 then
            plot(x(i),y(j),"d");
        end
    end
end



