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

*Fonte dummy (medir corrente)
Vdummy vdd a dc 0 			; Vdummy: nome da fonte de tensão (Voltage dummy).
					; vdd: nome do nó positivo (+) da fonte de tensão
					; a: nome do nó negativo (-) da fonte de tensão
; V dummy é do tipo dc - corrente contínua (direct current). Seu valor é constante.
					; 0: esse é o valor de tensão da fonte.


* Inversor com modelos BSIM4
M1 out in a vdd PMOS_VTG L=45n W=500n
M2 out in 0   0   NMOS_VTG L=45n W=250n

Cload out 0 2f


.control	; comandos de controle
  tran 0.1n 20n 0 0.01n   ; Define a análise  
  let pot_inst = v(vdd) * i(Vdummy)	; Define a potencia instantanea
;  run                     ; Executa a análise definida acima
  
  meas tran pot_media  AVG pot_inst 	; calcula a potencia media (AVG) dissipada no intervalo
	  				; eh a integral da potencia instantanea

  plot v(in) v(out)       ; Plota as tensões
  plot i(Vdummy)          ; Plota a corrente de Vdd
.endc


.end
