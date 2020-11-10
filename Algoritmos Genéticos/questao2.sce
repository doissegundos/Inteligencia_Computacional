clear; 
clc;

//Gera individuos com valores aleatorios de cromossomos
function[populacao]=Gera_Ind(tam_pop)
    individuos = round(rand(tam_pop,1)*2^20);//Gera 100 numeros alaeatorios
    populacao = dec2bin(individuos,20);//converte os 100 numeros aleatorios para um binario de 20bits
endfunction

//Recebe os valores binarios de 20 bits e converte para os valores reais referentes aos seus x e y
function[x]=ConverteX(populacao)
    xaux = part(populacao,1:10); //Separa os 10 bits referentes a x
    
    //Convertendo binario para decimal
    num_real_x = bin2dec(xaux);
    
    //Converte os valores para o intervalo -5 e 5
    lim_sup = 5;
    lim_inf = -5;
    x = lim_inf+(lim_sup - lim_inf)/((2^10)-1) * num_real_x;
endfunction

function[y]=ConverteY(populacao)
    yaux = part(populacao,11:20); //Separa os 10 bits referentes a y
    
    //Convertendo binario para decimal
    num_real_y = bin2dec(yaux);
    
    //Converte os valores para o intervalo -5 e 5
    lim_sup = 5;
    lim_inf = -5;
    y = lim_inf+(lim_sup - lim_inf)/((2^10)-1) * num_real_y;
endfunction

//Função de avaliação
function[G]=funcao(x,y)
    G = (1-x)^2+100*(y - x^2)^2;
endfunction 

//Retorna os valores de avaliação de todos os cromossomos, onde cada posição de "avaliacao_cromossomo" se refere ao valor equivalente de cada posição de "populacao"
function[avaliacao_cromossomo]=AvaliaPopu(tam_pop,populacao)
    x = 0;
    y = 0;
    avaliacao_cromossomo = ones(tam_pop,1);
    for i=1:tam_pop
        x = ConverteX(populacao(i));
        y = ConverteY(populacao(i));
        avaliacao_cromossomo(i)=funcao(x,y);    
    end
endfunction

//METODO DOS TORNEIOS
//Esse metodo retorna os pais dos individuos depois dele passar pela disputa
function[pais]=torneio(tam_pop,populacao)
    concorrente = populacao(1:6);
    pais = populacao; //inicializando a variavel pais
    for i = 1:tam_pop
        for m = 1:6
            concorrente(m) = populacao(ceil(rand()*100));
        end
        avaliacao_cromossomo = AvaliaPopu(6,concorrente);
        [avaliacao posicao] = min(avaliacao_cromossomo);
        pais(i) = concorrente(posicao);        
    end
endfunction



//Função pra fazer o cruzamento de dois pais e retornar dois filhos
function[filho1,filho2]=Cruzamento(pai1,pai2)
    pontocorte = int(rand()*19); //define um valor de 1 até 19 para ser o ponto de corte
    
    //Separa o numero binario em duas partes de acordo com o ponto de corte
    pai1_parte1 = part(pai1,1:pontocorte);
    pai1_parte2 = part(pai1,pontocorte+1:20);
    
    pai2_parte1 = part(pai2,1:pontocorte);
    pai2_parte2 = part(pai2,pontocorte+1:20);
    
    //gera o valor binario dos filhos de acordo com a junçao dos valores dos pais    
    filho1 = pai1_parte1 + pai2_parte2;
    filho2 = pai2_parte1 + pai1_parte2;
endfunction
//Função para gerar novos filhos a partir do cruzamento com os pais
function[filhos]=Gera_filhos(tam_pop,pais,populacao)
    filhos = populacao;//Inicia o vetor filhos
    for i=1:2:tam_pop
        [filhos(i) filhos(i+1)] = Cruzamento(pais(i),pais(i+1));
    end
endfunction
//Função para fazer a mutação de um cromossomo
function[indmutado]=mutacao(individuo)
    prob = rand()*100; //prob vai receber um valor aleatorio de 0 a 10
    //Este for vai analizar cada bit separadamente, existira uma probabilidade de 0.5% desse bit sofrer mutação
    //Se o valor da variavel 'prob' for menor do que 1.0 então o bit será mudado
    //Na mutação se o bit tiver valor 0, passará a ter valor 1. Se o bit tiver valor 1, passará a ter valor 0.
    for j = 1:20
        bit = part(individuo,j);
        if prob < 0.5
            if bit == "1" then
                bit = "0";
            else
                bit = "1";
            end            
        end
        
        if j == 1 then
            indmutado = bit;
        else
            indmutado = indmutado + bit;
        end       
    end
endfunction
//Função para fazer a mutação dos cromossomos
function[filhos_mutados]=Fazmutacao(tam_pop,filhos,populacao)
    filhos_mutados = populacao;//Inicia o vetor filhos
    for i=1:tam_pop
        filhos_mutados(i) = mutacao(filhos(i));
    end
endfunction

//Função para fazer o treinamento do algoritmo
function[populacao,x,y]=treinamento(tam_pop,populacao)
for i = 1:quat_geracoes
    x = ones(tam_pop,1);
    y = ones(tam_pop,1);
    
    //Retorna os valores reais de x e y
    for j = 1:tam_pop
        x(j) = ConverteX(populacao(j));
        y(j) = ConverteY(populacao(j));
    end
    //retorna o valor da avaliação dos individuos
    avaliacao_cromossomo = AvaliaPopu(quat_geracoes,populacao);       
    
    pais = torneio(tam_pop,populacao); //recebe os pais que foram escolhidos pelo metodo do torneio
    filhos = Gera_filhos(tam_pop,pais,populacao); // gera os filhos
    filhos_mutados = Fazmutacao(tam_pop,filhos,populacao); // faz a mutação dos filhos
    populacao = filhos_mutados; // substitui a população pelos filhos mutados
    
    //PLOTANDO OS INDIVIDUOS
    p=gca();
    r=p.rotation_angles;
    h=scatter3d(x,y,avaliacao_cromossomo,"fill");
    a=gca();
    f=gcf();
    f.figure_name='Geração:'+ string(i);
    a.rotation_angles = r;
    sleep(100);
    if(~(i==100)) then
        delete(h);
    end   
       
end
endfunction


//PLOTAGEM DO GRAFICO EM 3D
quat_pontos = 30;
x1=linspace(-5,5,quat_pontos);
y1=linspace(-5,5,quat_pontos);
z1=zeros(quat_pontos,quat_pontos)
for k=1:quat_pontos
    for m=1:quat_pontos
        z1(k,m)=funcao(x1(k),y1(m))
    end    
end
plot3d(x1,y1,z1)
graf3d=gcf();
graf3d.color_map = hotcolormap(4);

//INICIA AS VARIAVEIS PARA INICIO DO ALGORITMO
tam_pop = 100;
quat_geracoes = 100;
populacao = Gera_Ind(tam_pop); //gera 100 individuos de uma população
avaliacao_cromossomo = AvaliaPopu(quat_geracoes,populacao); // retorna o valor da avaliação dos individuos
[populacao x y] = treinamento(tam_pop,populacao); //retorna a população apos o treinamento das gerações

//Resultados
[avaliacao posicao] = min(avaliacao_cromossomo);
disp("O valor minimo encontrado: ");
disp(avaliacao);
disp("A posição do individuo na população é:");
disp(posicao);
disp("O individuo é:");
disp(populacao(posicao));

disp("O valor de X é:" + string(x(posicao)));
disp("O valor de Y é:" + string(y(posicao)));








