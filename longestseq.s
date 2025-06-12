section .text
        global  longestseq

longestseq:
        push    ebp             ; ebp na stos
        mov     ebp, esp        ; ustaw ebp jako esp

        sub     esp, 256        ;alokacja zmiennych lokalnych

        push    edi     ;zapamietywanie rejestrow saved
        push    esi
        push    ebx

        mov     ecx, -256        ;ecx jako loop counter
        mov     ebx, [ebp+12]   ;wskazuje na wzorzec

set_up_saving_space:
        mov     byte [ebp + ecx], 0       ;zapisz 0 pod odpowiednim adresem
        inc     ecx             ;dekrementacja petli -> samo ustawi flagi wiec nie trzeba test
        jnz     set_up_saving_space


        mov     al, [ebx]       ;al ma znak z patterna
save_pattern_on_stack:
        movzx   eax, al ;rozszerz al zerami do eax
        neg     eax
        mov     byte [ebp + eax], 1      ;zapisz 1 na miejscu odpowiadajacym znakowi
        inc     ebx

        mov     al, [ebx]       ;al ma teraz przyszly znak
        test    al, al  ;czy al to 0
        jnz     save_pattern_on_stack     ;jesi al to nie zero kontunuuj

set_up_finding_sequence:
        mov     ebx, [ebp+8]    ;ebx wskazuje na string z argumentu
        mov     edi, ebx    ;edi bedzie wskazywac na poczatek aktualnej
        mov     edx, ebx        ;edx wskaznik na najdluzszy string
        xor     esi, esi        ;esi bedzie licznikiem aktualnej sekwencji
        xor     ecx, ecx        ;ecx bedzie licznikiem najdluzszej sekwencji
        ;al bedzie na znak czytany

next_char:
        mov     al, [ebx] ;al ma aktualny znak
        inc     ebx ;ebx wskazuje na nastepny znak
        movzx   eax, al ;rozszerz al zerami do eax
        neg     eax
        cmp     byte [ebp + eax], 1
        jne     not_in_pattern ;nie jest we wzorcu -> albo kontynuuj albo skoncz sekwencje jesli zaczeta
        ;jest we wzorcu
        test    esi, esi  ;czy esi to 0 -> jesli tak sekwencja nie zaczeta
        jnz     increase_len_counter
        mov     edi, ebx        ;zachowaj ebx -> ale ono wskazuje juz na nastepny znak
        dec     edi             ; wiec zmniejsz o 1 zeby zachowac poczatek aktualnej sekwencji
increase_len_counter:
        inc     esi    ;zwieksz licznik aktualnej sekwencji
        jmp     next_char ; nigdy nie wyjdziemy z pętli jeśli znaleziony znak jest we wzorcu -> 0 nigdy nie będzie we wzorcu

not_in_pattern:
        test    esi, esi
        jz      continue_loop ; sekwencja nie zaczeta -> kontunuuj
end_sequence:
        cmp     esi, ecx ;porownanie dlugosci curr_seq i najdluzszej sekwencji
        jle     clear_curr_sequence
        mov     edx, edi ; zapisz wartosc z edi do edx
        mov     ecx, esi        ;do licznika najdluzszej sekwencji zapisz aktualna dlugosc

clear_curr_sequence:
        xor     esi, esi ;wyzerowanie licznika aktualnej sekwencji
        ;kiedy dojdzie do 0 to zawsze wejdzie tutaj i zakonczy sekwencje
continue_loop:
        test    al, al  ;czy przeanalizowany znak to 0
        jnz      next_char ;jesli nie zero -> kontynuuj, jesli 0 -> idz do fin

fin:
        mov     byte [edx + ecx], 0   ;zapisz 0 na koncu zwracanego stringa
        mov     eax, edx  ;do eax pointer na zwracany string

        ;odtworzenie rejestrow saved
        pop     ebx
        pop     esi
        pop     edi

        mov     esp, ebp ;usuniecie zmiennych lokalnych
        pop     ebp     ; przywroc ebp
        ret