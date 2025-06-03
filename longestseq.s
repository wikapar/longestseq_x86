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
        mov     byte [edx + ecx - 1], 0       ;zapisz 0 pod odpowiednim adresem
        dec     ecx             ;dekrementacja petli -> samo ustawi flagi wiec nie trzeba test
        ;test    ecx, ecx
        jnz     set_up_saving_space


        mov     al, [ebx]       ;al ma znak z patterna
save_pattern_on_stack:
        movzx   eax, al ;rozszerz al zerami do eax
        mov     byte [edx + eax], 1      ;zapisz 1 na miejscu odpowiadajacym znakowi
        inc     ebx

        mov     al, [ebx]       ;al ma teraz przyszly znak
        test    al, al  ;czy al to 0
        jnz     save_pattern_on_stack     ;jesi al to nie zero kontunuuj

set_up_finding_sequence:
        sub     esp, 4  ;miejsce na pointer do poczatku najlepszej sekwencji
        ;mov    cos, edx - 4
        mov     ebx, [ebp+8]    ;ebx wskazuje na string z argumentu
        mov     edi, ebx    ;edi bedzie wskazywac na poczatek aktualnej
        mov     [edx - 4], ebx
        xor     esi, esi        ;esi bedzie licznikiem aktualnej sekwencji
        xor     ecx, ecx        ;ecx bedzie licznikiem najdluzszej sekwencji
        ;al bedzie na znak czytany
        ;edx jest na lookup table
        ;edx - 4 -> pointer na najlepsza sekwencje

next_char:
        mov     al, [ebx] ;al ma aktualny znak
        inc     ebx ;ebx wskazuje na nastepny znak
        movzx   eax, al ;rozszerz al zerami do eax
        cmp     byte [edx + eax], 1
        jne      not_in_pattern ;nie jest we wzorcu -> albo kontynuuj albo skoncz sekwencje jesli zaczeta
        ;jest we wzorcu
        test    esi, esi  ;czy esi to 0 -> jesli tak sekwencja nie zaczeta
        jnz     increase_len_counter
        mov     edi, ebx        ;zachowaj ebx -> ale ono wskazuje juz na nastepny znak
        dec     edi             ; wiec zmniejsz o 1 zeby zachowac poczatek aktualnej sekwencji
increase_len_counter:
        inc     esi    ;zwieksz licznik aktualnej sekwencji
        jmp     next_char

not_in_pattern:
        test    esi, esi
        jz      continue_loop ; sekwencja nie zaczeta -> kontunuuj
end_sequence:
        cmp     esi, ecx ;porownanie dlugosci curr_seq i najdluzszej sekwencji
        jle     clear_curr_sequence
        mov     dword [edx - 4], edi ; zapisz wartosc z edi do edx - 4
        mov     ecx, esi        ;do licznika najdluzszej sekwencji zapisz aktualna dlugosc

clear_curr_sequence:
        xor     esi, esi ;wyzerowanie licznika aktualnej sekwencji
        ;kiedy dojdzie do 0 to zawsze wejdzie tutaj i zakonczy sekwencje
continue_loop:
        test    al, al  ;czy przeanalizowany znak to 0
        jnz      next_char ;jesli nie zerto -> kontynuuj, jesli 0 -> idz do fin

fin:
        mov     ebx, [edx - 4]  ;ebx to ptr na poczatek najdluzszej sekwencji
        add     ebx, ecx        ;dodaj dlugosc zeby otrzymac pointer na koniec stringa
        mov     byte [ebx], 0   ;zapisz 0 na koncu zwracanego stringa
        mov     eax, [edx - 4]  ;do eax pointer na zwracany string
        add     esp, 4
        add     esp, 256 ; zwolnienie miejsca na stosie
        pop     esi
        pop     edi
        pop     ebp     ; przywroc ebp
        ret