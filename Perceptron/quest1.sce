clear;
clc;
//Define os valores do bias e da tabela verdade
entrada = [-1 0 0
           -1 0 1
           -1 1 0
           -1 1 1];

//define os valores de saida da tabela verdade
saida = [0
         0
         0
         1];

//escolhe os pesos aleatoriamente
wt = [];
for i = 1:3
    wt(i)=rand();
end

//pede o numero de epocas desejadas pelo usuario
epoca = input("Digite o numero de epocas desejado");

linha = 1;
contador = 0;
for i=1:epoca

    xt = entrada(linha, 1:3);
    dt = saida(linha,1);
    
    //somatorio
    ut = xt*wt;
    if ut<0 then
        yt = 0;
    else
        yt = 1;
    end
    
    //define o erro
    erro = dt - yt;    
    
    //define os pesos da proxima interação
    for j= 1:3
        wt(j) = wt(j)+0.4*erro*xt(j);
    end
    
    
    //criterio de parada
    //Vamos supor que se a rede acertar 8 vezes consecutivas é pq ela ja aprendeu
    if dt==yt then
        contador = contador + 1;
        if contador==8 then
            break
        end
    end
    
    //como a tabela so possui 4 tipos de amostras, esse trecho faz um controle sobre qual amostra vai ser utilizada para fazer a predição
    //quando o algoritmo tiver utilizado a 4 linha da tabela(4 amostra) ele voltara para utilizar a primeira linha da tabela
    linha = linha + 1;
    if linha>4 then
        linha = 1;
    end
    
    
    disp("EPOCA");
    disp(i); 
    disp("entrada");
    disp(xt);
    disp("Saida esperada");
    disp(dt);
    disp("Saida da network");
    disp(yt);
    disp("Erro");
    disp(erro);
    sleep(1000);
    
end

//valores de x1 e x2 das classes 1 e 2
classe1x1 = 1;
classe1x2 = 1;
classe2x1 = [0 0 1];
classe2x2 = [0 1 0];
    
x1 = linspace(-3,5);
x2 = -((wt(2)/wt(3))*x1) + ((wt(1)/wt(3))); //equação da reta

//fazer a plotagem
plot(classe1x1,classe1x2,'*');
plot(classe2x1, classe2x2, 'x');
plot(x1,x2,'r-');
