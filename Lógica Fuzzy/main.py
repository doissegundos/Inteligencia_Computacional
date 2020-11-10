'''
NOME: Stefane Adna dos Santos
MATRICULA: 403249


As funções a baixo são utilizadas no calculo dos valores nebulosos de acordo com suas regras
As variaveis MEDIA1 e MEDIA2 dizem respeito ao valor medio de cada parte
Ele foi dividido em 2 porque é uma função em V. Media1 se refere a parte crescente e MEDIA2 a parte decrescente da função

PRESSÃO DO PEDAL
	LOW = -0.02X + 1 [0,50]
	MEDIO1 =  0.05x-3/2 [30,50]
	MEDIO2 = -0.05x + 7/2 [50,70]
	HIGHT = 0.02X - 1 [50,100]

VELOCIDADE DA RODA
	LOW = -0.0166667X+1 [0,60]
	MEDIO1 = 0.0333X - 2/3 [20,50]
	MEDIO2 = -0.0333X + 8/3 [50,80]
	HIGHT = 0.01667X - 2/3 [40,100]

VELOCIDADE DO CARRO
	LOW = -0.0166667X+1 [0,60]
	MEDIO1 = 0.0333333X - 2/3 [20,50]
	MEDIO2 = -0.0333333X + 8/3 [50,80]
	HIGHT = 0.01667X - 2/3 [40,100]


Cada regra vai ser calculada de acordo com suas normas que foram colocadas nos slides.
O valor de cada regra é extraido a partir das funções acima.
Após o calculo das regras é calculado o valor de "Aplicar Freio" e "Liberar freio"
Esses valores são enviados para a função de desnebulização no qual faz o calculo do somatorio a partir de um conjunto de regras

'''
#Função que retorna o valor da regra 1, recebe como parametro o valor da Pressão do Pedal
def regra1(pressaoPedal):
	aplicarFreio = 0

	#Calcula o valor medio do pedal de acordo com a função que foi mostrada acima
	if(pressaoPedal>=30 and pressaoPedal<=70):
		if(pressaoPedal>=30 and pressaoPedal<50):
			aplicarFreio = (0.05*pressaoPedal)-3/2 
		else:
			aplicarFreio = (-0.05*pressaoPedal) + 7/2
	return aplicarFreio

#Função que retorna o valor da regra 2, recebe como parametro o valor da Pressão do Pedal, Velocidade da Roda e Velocidade do Carro
def regra2(pressaoPedal,velocidadeRoda, velocidadeCarro):
	#Declarando as variaveis
	velocidadeAltaPedal = 0
	velocidadeAltaRoda = 0
	velocidadeAltaCarro = 0
	aplicarFreio = 0

	#definindo os valores nebulosos, de acordo com seus intervalos
	#Os valores nebulosos são tirados das funções mostradas acima
	if(pressaoPedal>=50 and pressaoPedal<=100):
		velocidadeAltaPedal = (0.02*pressaoPedal) - 1

	if(velocidadeRoda>=40 and velocidadeRoda<=100):
		velocidadeAltaRoda = (0.0166667*velocidadeRoda) - 2/3

	if(velocidadeCarro>=40 and velocidadeCarro<=100):
		velocidadeAltaCarro = (0.01666677*velocidadeCarro) - 2/3

	#Define qual valor nebuloso é o menor e atribui esse valor a "aplicarFreio"
	if(velocidadeAltaPedal<=velocidadeAltaRoda and velocidadeAltaPedal<=velocidadeAltaCarro):
		aplicarFreio = velocidadeAltaPedal
		return aplicarFreio
	elif(velocidadeAltaRoda<=velocidadeAltaPedal and velocidadeAltaRoda<=velocidadeAltaCarro):
		aplicarFreio = velocidadeAltaRoda
		return aplicarFreio
	else:
		aplicarFreio = velocidadeAltaCarro
		return aplicarFreio

#Função que retorna o valor da regra 3, recebe como parametro o valor da Pressão do Pedal, Velocidade da Roda e Velocidade do Carro
def regra3(pressaoPedal,velocidadeRoda, velocidadeCarro):
	#Declarando as variaveis
	velocidadeAltaPedal = 0
	velocidadeBaixaRoda = 0
	velocidadeAltaCarro = 0
	liberarFreio = 0

	#definindo os valores nebulosos, de acordo com suas funções
	if(pressaoPedal>=50 and pressaoPedal<=100):
		velocidadeAltaPedal = (0.02*pressaoPedal) - 1

	if(velocidadeRoda>=0 and velocidadeRoda<=60):
		velocidadeBaixaRoda = (-0.0166667*velocidadeRoda) + 1

	if(velocidadeCarro>=40 and velocidadeCarro<=100):
		velocidadeAltaCarro = (0.01667*velocidadeCarro) - 2/3

	#Define qual valor nebuloso é o menor e atribui esse valor a "liberarFreio"
	if(velocidadeAltaPedal<=velocidadeBaixaRoda and velocidadeAltaPedal<=velocidadeAltaCarro):
		liberarFreio = velocidadeAltaPedal
		return liberarFreio
	elif(velocidadeBaixaRoda<=velocidadeAltaPedal and velocidadeBaixaRoda<=velocidadeAltaCarro):
		liberarFreio = velocidadeBaixaRoda
		return liberarFreio
	else:
		liberarFreio = velocidadeAltaCarro
		return liberarFreio

#Função que retorna o valor da regra 4, recebe como parametro a pressão do pedal
def regra4(pressaoPedal):
	liberarFreio = 0

	#define o valor nebuloso de acordo com a regra 4
	if(pressaoPedal>=0 and pressaoPedal<=50):
		liberarFreio = (-0.02*pressaoPedal) + 1 

	return liberarFreio

#Função que calcula o valor da desnebulização, recebe como parametro AplicarFreio e LiberarFreio
def desnebulização(aplicarFreio,liberarFreio):
	somatorio1 = 0
	somatorio2 = 0
	for x in range (101):

		a = 0.01*x #Função "Apertar Freio"
		r = (-0.01*x) + 1 #Função "Liberar Freio"

		#Essa sequencia de if e else define um conjunto de regras para realizar o calculo da desnebulização de acordo com o mostrado no slide
		if(liberarFreio<=r and liberarFreio>=a):
			somatorio1 = somatorio1 + (liberarFreio*x)
			somatorio2 = somatorio2 + liberarFreio
		elif(liberarFreio>=r and r>=a):
			somatorio1 = somatorio1 + (r*x)
			somatorio2 = somatorio2 + r 
		elif(liberarFreio<=r and liberarFreio>=aplicarFreio):
			somatorio1 = somatorio1 + (liberarFreio*x)
			somatorio2 = somatorio2 + liberarFreio 
		elif(liberarFreio>=r and r>=aplicarFreio):
			somatorio1 = somatorio1 + (r*x)
			somatorio2 = somatorio2 + r
		elif(liberarFreio>=r and aplicarFreio<=r):
			somatorio1 = somatorio1 + (r*x)
			somatorio2 = somatorio2 + r
		elif(a>=aplicarFreio):
			somatorio1 = somatorio1 + (aplicarFreio*x)
			somatorio2 = somatorio2 + aplicarFreio
		elif(a<=aplicarFreio and a>=liberarFreio):
			somatorio1 = somatorio1 + (a*x)
			somatorio2 = somatorio2 + a

	c = somatorio1 / somatorio2
	return c


def main():
	#Recebendo os valores do usuario
	pressaoPedal = float(input("Digite a pressão do pedal:\n"))
	while(pressaoPedal<0 or pressaoPedal>100):
		pressaoPedal = float(input("Digite a pressão do pedal entre 0 e 100:\n"))

	velocidadeRoda = float(input("Digite a velocidade da roda:\n"))
	while (velocidadeRoda<0 or velocidadeRoda>100):
		velocidadeRoda = float(input("Digite a velocidade da roda entre 0 e 100:\n"))

	velocidadeCarro = float(input("Digite a velocidade do carro:\n"))
	while(velocidadeCarro<0 or velocidadeCarro>100):
		velocidadeCarro = float(input("Digite a velocidade do carro entre 0 e 100:\n"))
	
	#Recebendo o valor nebuloso de cada regra
	regra_1 = float("%.5f"% regra1(pressaoPedal))
	regra_2 = float("%.5f"% regra2(pressaoPedal,velocidadeRoda, velocidadeCarro))
	regra_3 = float("%.5f"% regra3(pressaoPedal,velocidadeRoda, velocidadeCarro))
	regra_4 = float("%.5f"% regra4(pressaoPedal))

	#Faz o calculo de aplicarFreio e liberarFreio
	aplicarFreio = regra_1 +regra_2
	liberarFreio = regra_3 + regra_4

	c = float(desnebulização(aplicarFreio,liberarFreio))

	print("\n Regra 1:", regra_1)
	print("\n Regra 2:", regra_2)
	print("\n Regra 3:", regra_3)
	print("\n Regra 4:", regra_4)

	print("\n\nValor Aplicar freio: ",aplicarFreio)
	print("\nValor Liberar Freio: ",liberarFreio)
	print("\n\nValor desnebulização: ",c)


main()