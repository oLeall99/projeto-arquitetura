	   ORG 0000H
     LJMP INICIO

     ORG 0100H
INICIO:
    MOV P3, #11111111b ; Inicializa P3 (displays)
    MOV P1, #0FFh      ; Inicializa P1 (segmentos)
    MOV P2, #0FFh      ; Inicializa P2 (teclado)

START:
    CALL SCAN_KEYBOARD ; Verifica teclado
    JMP START          ; Loop principal

SCAN_KEYBOARD:
    MOV P2, #0FFh     ; Prepara P2 para leitura
    MOV A, P2         ; Lê o teclado
    CJNE A, #0FFh, KEY_PRESSED ; Se alguma tecla foi pressionada
    RET               ; Retorna se nenhuma tecla foi pressionada

KEY_PRESSED:
    CALL DEBOUNCE     ; Aguarda debounce
    MOV A, P2         ; Lê o teclado novamente
    CJNE A, #0FFh, PROCESS_KEY ; Se ainda está pressionada
    RET               ; Retorna se foi ruído

PROCESS_KEY:
    ; Mapeia o valor do teclado para o display
    ; Aqui você precisa implementar a lógica de mapeamento
    ; Exemplo para tecla 1:
    CJNE A, #0FEh, CHECK_2
    MOV P1, #0F9h     ; Mostra 1 no display
    JMP SHOW_DISPLAY

CHECK_2:
    CJNE A, #0FDh, CHECK_3
    MOV P1, #0A4h     ; Mostra 2 no display
    JMP SHOW_DISPLAY

CHECK_3:
    CJNE A, #0FBh, CHECK_4
    MOV P1, #0B0h     ; Mostra 3 no display
    JMP SHOW_DISPLAY

CHECK_4:
    CJNE A, #0F7h, CHECK_5
    MOV P1, #099h     ; Mostra 4 no display
    JMP SHOW_DISPLAY

CHECK_5:
    CJNE A, #0EFh, CHECK_6
    MOV P1, #092h     ; Mostra 5 no display
    JMP SHOW_DISPLAY

CHECK_6:
    CJNE A, #0DFh, CHECK_7
    MOV P1, #082h     ; Mostra 6 no display
    JMP SHOW_DISPLAY

CHECK_7:
    CJNE A, #0BFh, CHECK_8
    MOV P1, #0F8h     ; Mostra 7 no display
    JMP SHOW_DISPLAY

CHECK_8:
    CJNE A, #07Fh, CHECK_9
    MOV P1, #080h     ; Mostra 8 no display
    JMP SHOW_DISPLAY

CHECK_9:
    CJNE A, #0EFh, CHECK_0
    MOV P1, #090h     ; Mostra 9 no display
    JMP SHOW_DISPLAY

CHECK_0:
    CJNE A, #0DFh, NO_KEY
    MOV P1, #0C0h     ; Mostra 0 no display
    JMP SHOW_DISPLAY

NO_KEY:
    RET

SHOW_DISPLAY:
    MOV P3, #11111110b ; Habilita display 0
    CALL delay
    RET

DEBOUNCE:
    MOV R0, #50
DEBOUNCE_LOOP:
    DJNZ R0, DEBOUNCE_LOOP
    RET

delay:
    MOV R0, #250
    DJNZ R0, $
    RET