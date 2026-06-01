* ==========================================================================================================================================================================================================
* Este código, feito com a linguagem SPICE, tem como finalidade descrever e simular eletrônicamente um Multiplexador 2:1.
* Ele diz respeito à atividade passada em sala pelo Prof. Dr. Calebe Micael, durante a 5ª aula laboratorial da matéria de Sistemas Digitais (COMP0514 - UFS), correspondente à primeira aula do ciclo 2.
* Para formar a netlist do MUX, foi utilizado o Kit de Design Preditivo da NCSU para 45nm (FreePDK45), em conjunto com a biblioteca de células padrão da Nangate para o FreePDK45.
*
* @Author Mateus Aranha (github.com/matt-aranha)
* @Data 18/05/2026
* ==========================================================================================================================================================================================================


.lib ptm_45nm.bsim4.lib TT                          ; importa a biblioteca preditiva 45nm e habilita a caratectização Typical-Typical.
.include "spice/NangateOpenCellLibrary.spi"         ; importa a biblioteca de células padrão da Nangate.

* Fontes de alimentação e de estimulo das entradas
    VDD vdd 0 1.1

    VIN1 in1 0 dc 0
        ; IN1 em nível lógico 0

    VIN2 in2 0 dc 1.1
        ; IN2 em nível lógico 1

    VSEL sel 0 pulse( 0 1.1 0 20p 20p 10n 20n )
            ; SEL (Chave seletora) é do tipo Pulse (alternado) oscliando a 50Mhz (Período de 20ns), e seus parâmetros são, na ordem:
                ; v1: valor inicial - tensão antes do pulso começar (0V).
                ; v2: valor de pulso - tensão do sinal no pico do pulso (1.1V).
                ; td: tempo de atraso (time delay) - tempo que a fonte espera para começar a subir (0s).
                ; tr: tempo de subida (time rise) - duração da transição v1->v2 (20p).
                ; tf: tempo de descida (time fall) - duração da transição v2->v1 (20p).
                ; pw: largura de pulso (pulse width) - O tempo que o sinal permanece no seu pico v2 (10n).
                ; per: período - tempo total de um ciclo completo (20n).
    

    * Fonte Dummy (medir corrente) => amperímetro
    Vdummy vdd amp dc 0
        ; "Vdummy" (Voltage dummy) é o nome da fonte de tensão, seu tipo é dc (corrente contínua / direct current).
                        ; vdd: nome do nó positivo (+) da fonte de tensão.
                        ; a: nome do nó negativo (-) da fonte de tensão.
                        ; 0: esse é o valor de tensão da fonte.
    ;
;

* Multiplexador 2:1 (feito com células de dimensão X1)

    * Porta Inversora (NOT):
    x_inv_x2 sel sel_inv amp 0 INV_X2
        ; Ordem dos pinos:
            ; in: entrada da porta inversora INV_X1 (sel).
            ; out: saída da porta inversora INV_X1 (sel_inv).
            ; VDD: tensão (+).
            ; VSS: ground (0v).
            ; Nome: nome da porta (INV_X1).
    ;

    * Porta AND Superior (baseado no esquemático):
    x_and2_superior_x2 in2 sel fio_and_superior amp 0 AND2_X2
        ; Ordem dos pinos:
            ; in1: entrada 1 da porta AND2_S_X1 (in2).
            ; in2: entrada 2 da porta AND2_S_X1 (sel).
            ; out: saída da porta AND2_S_X1 (fio_and_superior).
            ; VDD: tensão (+).
            ; VSS: ground (0v).
            ; Nome: nome da célula na biblioteca (AND2_X1).
    ;

    * Porta AND Inferior (baseado no esquemático):
    x_and2_inferior_x2 in1 sel_inv fio_and_inferior amp 0 AND2_X2
        ; Ordem dos pinos:
            ; in1: entrada 1 da porta AND2_I_X1 (in1).
            ; in2: entrada 2 da porta AND2_I_X1 (sel_inv).
            ; out: saída da porta AND2_I_X1 (fio_and_inferior).
            ; VDD: tensão (+).
            ; VSS: ground (0v).
            ; Nome: nome da célula na biblioteca (AND2_X1).
    ;

    * Porta OR:
    x_or2_x2 fio_and_superior fio_and_inferior out amp 0 OR2_X2
        ; Ordem dos pinos:
            ; in1: entrada 1 da porta OR2_X1 (fio_and_superior).
            ; in2: entrada 2 da porta OR2_X1 (fio_and_inferior).
            ; out: saída da porta OR2_X1 (out).
            ; VDD: tensão (+).
            ; VSS: ground (0v).
            ; Nome: nome da célula na biblioteca (OR2_X1).
    ;

    ; Capacitância de carga na saída:
    c_load out 0 10f
;


* Bloco de controle da execução
.control	; comandos de controle

    ; Comando Transiente (tran):
    tran 10p 20n
        ; tran: Esse comando define a análise do tempo.
        ; passo: Passo de cálculo (10p) menor que o tempo de subida, que é 20p, para não perder os detalhes do sinal.
        ; duração: Para conseguir enxergar o ciclo completo de todas as combinações lógicas, precisa de um tempo += 20n
    ;

    ; Comando de Execução (run):
    run
    ;

    ; Comando de Plotagem (plot):
    ; plot v(in1)+3.5 v(in2)+2.4 v(sel)+1.2 v(out)
        ; plot: Esse comando está desenhando em um gráfico as 3 entradas (in1, in2 e sel) e a saída (out).
        ; cada entrada está sendo somada à uma constante apenas para deslocar as ondas verticalmentem, facilitando a visualização de cada uma delas.
    
    plot i(Vdummy)
        ; plot: Esse comando está desenhando em outro gráfico a corrente medida pelo amperímetro entre os pontos "vdd" e "amp".
    ;

    ; Comando para medir corrente média (meas):
    meas tran I_media AVG i(Vdummy) from=0 to=20n
        ; Resultado: 3.07881e-06 Amperes.
    ;
    
.endc

* Comando para finalizar a simulação
.end