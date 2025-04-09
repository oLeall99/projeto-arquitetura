	   ORG 0000H
     LJMP INICIO

     ORG 0100H
INICIO:
    MOV P3, #11111111b ; Inicializa P3 (displays)
    MOV P1, #0FFh      ; Inicializa P1 (segmentos)
    MOV P0, #0FFh      ; Inicializa P0 (keypad)

START:
    CALL SCAN_KEYBOARD ; Verifica teclado
    JMP START          ; Loop principal

SCAN_KEYBOARD:
    ; Verifica linha 3 (primeira linha física - 1,2,3)
    MOV P0, #11110111b ; Ativa linha 3
    MOV A, P0
    ANL A, #11110000b  ; Mascara para ler apenas as colunas
    CJNE A, #11110000b, ROW3_PRESSED

    ; Verifica linha 2 (segunda linha física - 4,5,6)
    MOV P0, #11111011b ; Ativa linha 2
    MOV A, P0
    ANL A, #11110000b  ; Mascara para ler apenas as colunas
    CJNE A, #11110000b, ROW2_PRESSED

    ; Verifica linha 1 (terceira linha física - 7,8,9)
    MOV P0, #11111101b ; Ativa linha 1
    MOV A, P0
    ANL A, #11110000b  ; Mascara para ler apenas as colunas
    CJNE A, #11110000b, ROW1_PRESSED

    ; Verifica linha 0 (última linha física - *,0,#)
    MOV P0, #11111110b ; Ativa linha 0
    MOV A, P0
    ANL A, #11110000b  ; Mascara para ler apenas as colunas
    CJNE A, #11110000b, ROW0_PRESSED

    RET

ROW3_PRESSED:
    CALL DEBOUNCE
    MOV A, P0
    ANL A, #11110000b
    CJNE A, #11100000b, CHECK_ROW3_COL1 ; Coluna 0
    MOV P1, #0F9h ; Mostra 1
    JMP SHOW_DISPLAY
CHECK_ROW3_COL1:
    CJNE A, #11010000b, ROW3_COL2 ; Coluna 1
    MOV P1, #0A4h ; Mostra 2
    JMP SHOW_DISPLAY
ROW3_COL2:
    MOV P1, #0B0h ; Mostra 3
    JMP SHOW_DISPLAY

ROW2_PRESSED:
    CALL DEBOUNCE
    MOV A, P0
    ANL A, #11110000b
    CJNE A, #11100000b, CHECK_ROW2_COL1 ; Coluna 0
    MOV P1, #099h ; Mostra 4
    JMP SHOW_DISPLAY
CHECK_ROW2_COL1:
    CJNE A, #11010000b, ROW2_COL2 ; Coluna 1
    MOV P1, #092h ; Mostra 5
    JMP SHOW_DISPLAY
ROW2_COL2:
    MOV P1, #082h ; Mostra 6
    JMP SHOW_DISPLAY

ROW1_PRESSED:
    CALL DEBOUNCE
    MOV A, P0
    ANL A, #11110000b
    CJNE A, #11100000b, CHECK_ROW1_COL1 ; Coluna 0
    MOV P1, #0F8h ; Mostra 7
    JMP SHOW_DISPLAY
CHECK_ROW1_COL1:
    CJNE A, #11010000b, ROW1_COL2 ; Coluna 1
    MOV P1, #080h ; Mostra 8
    JMP SHOW_DISPLAY
ROW1_COL2:
    MOV P1, #090h ; Mostra 9
    JMP SHOW_DISPLAY

ROW0_PRESSED:
    CALL DEBOUNCE
    MOV A, P0
    ANL A, #11110000b
    CJNE A, #11100000b, CHECK_ROW0_COL1 ; Coluna 0 (*)
    MOV P1, #088h ; Mostra A
    JMP SHOW_DISPLAY
CHECK_ROW0_COL1:
    CJNE A, #11010000b, ROW0_COL2 ; Coluna 1
    MOV P1, #0C0h ; Mostra 0
    JMP SHOW_DISPLAY
ROW0_COL2:
    MOV P1, #088h ; Mostra A (para #)
    JMP SHOW_DISPLAY

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