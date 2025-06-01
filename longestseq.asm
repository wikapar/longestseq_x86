section .text
        global  longestseq

longestseq:
        push    ebp             ; ebp to stack
        mov     ebp, esp        ; set ebp to esp



fin:
        pop     ebp     ; restore ebp
        ret