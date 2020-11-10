import numpy as np
import os
import re
import matplotlib.pyplot as plt

#recebe o dataset e separa os valores em x e y
file = open("data/aerogerador.dat", "r")
x, y = [], []
x_aux, y_aux = 0,0
for linha in file:
    linha = linha.strip()
    linha = re.sub('\s+','-',linha)
    x_aux, y_aux = linha.split("-")
    y.append(float(y_aux))
    x.append(float(x_aux))
file.close()   
Y = np.array(y)

k = int(input("Digite o grau do polinomio:")) #recebe o grau do polinomio do usuario

#Cria a MATRIZ X
X = np.zeros((len(y),k+1), dtype=np.float64)
#preenche os valores de entrada x na matriz X
for i in range(len(y)): 
    for j in range(k+1):
        X[i][j] = x[i]**j

B = np.linalg.inv(X.T@X)@(X.T@y) #calculo da estimativa de quadrados mínimos
y_preditor = X@B #calculo do modelo de regressão ajustado 
e_residuo = y - y_preditor #calculo do residuo

y_media = 0 
sqe = 0
sy = 0

#calcula a media dos valores de saida
for i in range(len(y)):
    y_media = y_media + y[i]
y_media= y_media/len(y)

#calcula o valor se SQe
for i in range(len(y)):
    sqe = sqe + (y[i]-y_preditor[i])**2

#calcula o valor de Syy
for i in range(len(y)):
    sy = sy + (y[i]-y_media)**2


r2 = 1 - (sqe/sy) #faz o calculo do coeficiente de determinação
r2aj = 1 - ((sqe/(len(y)-(k+1))) / (sy/(len(y)-1)) )#faz o calculo do coeficiente de determinação ajustado


#exibe os resultados para o usuario
print("GRAU DO POLINOMIO:",k)
print("O coeficiente de determinação é dado por:",r2)
print("O coeficiente de determinação ajustado é dado por:",r2aj)
plt.plot(x,y_preditor, color ='red')
plt.scatter(x,y, marker="*",color='orange')
plt.show()