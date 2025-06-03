section .text
        global  longestseq

longestseq:
        push    ebp             ; ebp na stos
        mov     ebp, esp        ; ustaw ebp jako esp

        push    edi
        push    esi

        sub     esp, 256        ;zarezerwuj 256 miejsca na stosie
        mov     edx, esp        ;edx wskazuje na zarezerwowane miejsce

        mov     ecx, 256        ;ecx jako loop counter
        mov     ebx, [ebp+12]   ;wskazuje na wzorzec

set_up_saving_space:
        mov     byte [edx + 256 - ecx], 0       ;zapisz 0 pod odpowiednim adresem
        dec     ecx             ;dekrementacja petli -> samo ustawi flagi wiec nie trzeba test
        ;test    ecx, ecx
        jnz     set_up_saving_space


        mov     al, [ebx]       ;al ma znak z patterna
save_pattern_on_stack:
        mov     byte [edx + al], 1      ;zapisz 1 na miejscu odpowiadajacym znakowi
        inc     ebx

        mov     al, [ebx]       ;al ma teraz przyszly znak
        test    al, al  ;czy al to 0
        jnz      save_pattern_on_stack     ;jesi al to nie zero kontunuuj


        mov     ebx, [ebp+8] ;ebx wskazuje na string z argumentu





fin:
        add     esp, 256 ; zwolnienie miejsca na stosie
        pop     esi
        pop     edi
        mov     eax, [ebp + 8]  ;do eax pointer na zwracany string
        pop     ebp     ; przywroc ebp
        ret