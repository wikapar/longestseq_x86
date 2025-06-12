section .text
        global  longestseq

longestseq:
        push    rbp             ; rbp na stos
        mov     rbp, rsp        ;potrzebujemy rbp bo alokujemy zmienne na stosie

        sub     rsp, 256        ;alokacja zmiennych lokalnych


        mov     ecx, -256        ;ecx to licznik petli
        mov     r8, rsi   ;wskazuje na wzorzec

set_up_saving_space:
        mov     byte [rbp + rcx], 0       ;zapisz 0 pod odpowiednim adresem
        inc     ecx             ;dekrementacja petli -> samo ustawi flagi wiec nie trzeba test
        jnz     set_up_saving_space


        mov     al, [r8]       ;al ma znak z patterna
save_pattern_on_stack:
        movzx   rax, al ;rozszerz al zerami do eax
        neg     rax
        mov     byte [rbp + rax], 1      ;zapisz 1 na miejscu odpowiadajacym znakowi
        inc     r8

        mov     al, [r8]       ;al ma teraz przyszly znak
        test    al, al  ;czy al to 0
        jnz     save_pattern_on_stack     ;jesi al to nie zero kontunuuj

set_up_finding_sequence:
        mov     r8, rdi    ;r8 wskazuje na string z argumentu
        mov     r9, r8    ;r9 bedzie wskazywac na poczatek aktualnej
        mov     rdx, r8        ;rdx wskaznik na najdluzszy string
        xor     r10d, r10d        ;r10d bedzie licznikiem aktualnej sekwencji
        xor     ecx, ecx        ;ecx bedzie licznikiem najdluzszej sekwencji
        ;al bedzie na znak czytany

next_char:
        mov     al, [r8] ;al ma aktualny znak
        inc     r8 ;r8 wskazuje na nastepny znak
        movzx   rax, al ;rozszerz al zerami do eax
        neg     rax
        cmp     byte [rbp + rax], 1
        jne     not_in_pattern ;nie jest we wzorcu -> albo kontynuuj albo skoncz sekwencje jesli zaczeta
        ;jest we wzorcu
        test    r10d, r10d  ;czy r10d to 0 -> jesli tak sekwencja nie zaczeta
        jnz     increase_len_counter
        mov     r9, r8        ;zachowaj r8 -> ale ono wskazuje juz na nastepny znak
        dec     r9             ; wiec zmniejsz o 1 zeby zachowac poczatek aktualnej sekwencji
increase_len_counter:
        inc     r10d    ;zwieksz licznik aktualnej sekwencji
        jmp     next_char ; nigdy nie wyjdziemy z pętli jeśli znaleziony znak jest we wzorcu -> 0 nigdy nie będzie we wzorcu

not_in_pattern:
        test    r10d, r10d
        jz      continue_loop ; sekwencja nie zaczeta -> kontunuuj
end_sequence:
        cmp     r10d, ecx ;porownanie dlugosci curr_seq i najdluzszej sekwencji
        jle     clear_curr_sequence
        mov     rdx, r9 ; zapisz wartosc z r9 do rdx
        mov     ecx, r10d        ;do licznika najdluzszej sekwencji zapisz aktualna dlugosc

clear_curr_sequence:
        xor     r10d, r10d ;wyzerowanie licznika aktualnej sekwencji
        ;kiedy dojdzie do 0 to zawsze wejdzie tutaj i zakonczy sekwencje
continue_loop:
        test    al, al  ;czy przeanalizowany znak to 0
        jnz     next_char ;jesli nie zero -> kontynuuj, jesli 0 -> idz do fin

fin:
        mov     byte [rdx + rcx], 0   ;zapisz 0 na koncu zwracanego stringa
        mov     rax, rdx  ;do eax pointer na zwracany string

        mov     rsp, rbp ;usuniecie zmiennych lokalnych
        pop     rbp     ; przywroc rbp
        ret