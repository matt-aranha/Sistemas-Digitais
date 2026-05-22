.lib ptm_45nm.bsim4.lib TT ; importa a bibiblioteca preditiva 45nm e habilita a caratectizacao Typical-Typical

* Fontes
VDD vdd 0 1.1
VIN in  0 pulse(0 1.1 0 20p 20p 2n 4n)  ; VIN: nome da fonte de tensão (Voltage source INput).
					; in: Nome do nó positivo (+) da fonte de tensão. O sinal é aplicado a este nó.
					; 0:  Nó negativo (-) da fonte de tensão, que está conectado ao terra (ground)
					; 	a referência de 0V do circuito.
; VIN é do tipo Pulse, e seus parâmtros são, na ordem:
	; v1: valor inicial - tensão antes do pulso começar (0V)
	; v2: valor de pulso - tensão do sinal no pico do pulso (1.1V)
	; td: atraso (delay) - tempo que a fonte espera para começar a subir (0s)
	; tr: tempo de subida (rise) - duração da transição v1->v2 (20p)
	; tf: tempo de descida (fall) - duração da transição v2->v1 (20p)
	; pw: largura de pulso (pulse width) - O tempo que o sinal permanece no seu pico v2 (2n)
	; per: período - tempo total de um ciclo completo (4n)

* Cargas (clones para cada inversor ter a mesma carga)
Cload1 out1 0 10f
Cload2 out2 0 10f
Cload3 out4 0 10f

* Instanciando os Inversores Nangate
* A ordem dos nós (out in vdd gnd) deve corresponder à ordem dos pinos (Y A VDD VSS)
* no arquivo .SUBCKT da Nangate.

* Inversor com drive X1 (o mais fraco)
x_inv_x1 in out1 vdd 0 INV_X1

* Inversor com drive X2
x_inv_x2 in out2 vdd 0 INV_X2

* Inversor com drive X4 (o mais forte)
x_inv_x4 in out4 vdd 0 INV_X4

.control
  tran 0.1n 20n 0 0.01n   ; Define a análise
  plot v(in) v(out1) v(out2) v(out4) ; apresenta o grafico da analise
.endc

.end
