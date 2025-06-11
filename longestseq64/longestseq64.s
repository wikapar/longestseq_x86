section .text
        global  longestseq

longestseq:
        push    rbp             ; ebp na stos
        mov     rbp, rsp        ; ustaw ebp jako rsp

        push    rdi
        push    rsi
        push    rbx

        sub     rsp, 256        ;zarezerwuj 256 miejsca na stosie

        mov     rcx, 256        ;ecx jako loop counter
        mov     rbx, rsi   ;wskazuje na wzorzec
        ;mov     r10, rdi   ;r10 -> przechowuje 1 arg. funkcji, żeby go nie nadpisac

set_up_saving_space:
        mov     byte [rsp + rcx-1], 0       ;zapisz 0 pod odpowiednim adresem
        dec     rcx             ;dekrementacja petli -> samo ustawi flagi wiec nie trzeba test
        jnz     set_up_saving_space


        mov     al, [rbx]       ;al ma znak z patterna
save_pattern_on_stack:
        movzx   rax, al ;rozszerz al zerami do eax
        mov     byte [rsp + rax], 1      ;zapisz 1 na miejscu odpowiadajacym znakowi
        inc     rbx

        mov     al, [rbx]       ;al ma teraz przyszly znak
        test    al, al  ;czy al to 0
        jnz     save_pattern_on_stack     ;jesi al to nie zero kontunuuj

set_up_finding_sequence:
        mov     rbx, rdi    ;ebx wskazuje na string z argumentu
        ;mov     edi, ebx    ;edi bedzie wskazywac na poczatek aktualnej
        mov     rdx, rbx        ;edx wskaznik na najdluzszy string
        xor     rsi, rsi        ;esi bedzie licznikiem aktualnej sekwencji
        xor     rcx, rcx        ;ecx bedzie licznikiem najdluzszej sekwencji
        ;al bedzie na znak czytany

next_char:
        mov     al, [rbx] ;al ma aktualny znak
        inc     rbx ;ebx wskazuje na nastepny znak
        movzx   rax, al ;rozszerz al zerami do eax
        cmp     byte [rsp + rax], 1
        jne     not_in_pattern ;nie jest we wzorcu -> albo kontynuuj albo skoncz sekwencje jesli zaczeta
        ;jest we wzorcu
        test    rsi, rsi  ;czy esi to 0 -> jesli tak sekwencja nie zaczeta
        jnz     increase_len_counter
        mov     rdi, rbx        ;zachowaj ebx -> ale ono wskazuje juz na nastepny znak
        dec     rdi             ; wiec zmniejsz o 1 zeby zachowac poczatek aktualnej sekwencji
increase_len_counter:
        inc     rsi    ;zwieksz licznik aktualnej sekwencji
        jmp     next_char ; nigdy nie wyjdziemy z pętli jeśli znaleziony znak jest we wzorcu -> 0 nigdy nie będzie we wzorcu

not_in_pattern:
        test    rsi, rsi
        jz      continue_loop ; sekwencja nie zaczeta -> kontunuuj
end_sequence:
        cmp     rsi, rcx ;porownanie dlugosci curr_seq i najdluzszej sekwencji
        jle     clear_curr_sequence
        mov     rdx, rdi ; zapisz wartosc z edi do edx
        mov     rcx, rsi        ;do licznika najdluzszej sekwencji zapisz aktualna dlugosc

clear_curr_sequence:
        xor     rsi, rsi ;wyzerowanie licznika aktualnej sekwencji
        ;kiedy dojdzie do 0 to zawsze wejdzie tutaj i zakonczy sekwencje
continue_loop:
        test    al, al  ;czy przeanalizowany znak to 0
        jnz      next_char ;jesli nie zero -> kontynuuj, jesli 0 -> idz do fin

fin:
        mov     rbx, rdx  ;ebx to ptr na poczatek najdluzszej sekwencji
        add     rbx, rcx        ;dodaj dlugosc zeby otrzymac pointer na koniec stringa
        mov     byte [rbx], 0   ;zapisz 0 na koncu zwracanego stringa
        mov     rax, rdx  ;do eax pointer na zwracany string
        add     rsp, 256 ; zwolnienie miejsca na stosie
        pop     rbx
        pop     rsi
        pop     rdi
        pop     rbp     ; przywroc ebp
        ret