clear;
clc;
dataset = fscanfMat('C:\Users\STEFA\Desktop\ic\STEFANE ADNA DOS SANTOS - 403249\aerogerador.dat'); //recebendo o dataset do aerogerador

num_neuronios = input("Digite a quantidade de neuronios desejada"); //define o numero de neuronios ocutos

//o dataset do aerogerador possui duas colunas, sendo uma referente aos valores de x e outra referente aos valores de y.
//Separa o dataset de acordo com as colunas de x e y
x = dataset(:,1)';
x = x./max(x); //normaliza os valores de x para ficarem entre 0 e 1

y = dataset(:,2)';
y = y./max(y); //normaliza os valores de y para ficarem entre 0 e 1

quat_amostras = length(y); //quantidade de amostras por treinamento do aerogerador

//calculo dos centroides
index = grand(1,"prm",1:quat_amostras); //retorna para a variavel indice, os indices de 1 até a quantidade de amostras de forma embaralhada.
t = x(index(1:num_neuronios)); //recebe n valores de x, de forma aleatoria


//Cada valor de entrada vai ser processado pelos neuronios separadamente
sig = 1;
pv = ones(num_neuronios,quat_amostras); //retorna uma matriz num_neuroniosXN
for i=1:quat_amostras
    u = abs(repmat(x(i),1,num_neuronios) - t); //retorna os valores do vetor normalizados
    pv(:,i) = exp(-(u.^2/(2*sig)));
end

//adicionando o valor do -1 do bias no vetor
pv = [-1*ones(1,quat_amostras);pv];

lambda = 1*10.^(-9); //define o valor do lambda
B = y*pv'*(pv*pv'+lambda*eye(num_neuronios+1,num_neuronios+1))^(-1);
y_ = B*pv;

R2 = 1 - sum((y-y_).^2)/sum((y-mean(y)).^2);
disp("VALOR DE R2");
disp(R2);

title("Valor de R2 = " + string(R2));
plot(x,y,".");
plot(x,y_,"k--");
