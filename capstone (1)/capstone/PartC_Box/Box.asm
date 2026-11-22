// Box.asm  (Roll no 2501010318, K = 18)
// Box: starts at row 18, 20 rows tall, 16 * ((18 mod 4) + 1) = 48 pixels wide (3 words)
// Key pressed  -> black box appears
// Key released -> box disappears
// First word of row 18 = SCREEN + 32*18 = 16384 + 576 = 16960

(LOOP)
    @KBD
    D=M
    @BLACK
    D;JNE               // key pressed -> go to BLACK
    @color
    M=0                 // no key -> white (0)
    @DRAW
    0;JMP
(BLACK)
    @color
    M=-1                // key pressed -> black (all 16 bits = 1)

(DRAW)
    @16960              // SCREEN + 32*18
    D=A
    @addr
    M=D                 // addr = first word of the box
    @20                 // 20 rows
    D=A
    @rows
    M=D

(ROWLOOP)
    @3                  // 3 words per row (48 pixels)
    D=A
    @cols
    M=D

(COLLOOP)
    @color
    D=M
    @addr
    A=M
    M=D                 // RAM[addr] = color
    @addr
    M=M+1               // next word in the same row
    @cols
    M=M-1
    D=M
    @COLLOOP
    D;JGT               // repeat until 3 words are done

    @29                 // 32 - 3 = 29, jump to the start of the next row
    D=A
    @addr
    M=D+M
    @rows
    M=M-1
    D=M
    @ROWLOOP
    D;JGT               // repeat until 20 rows are done

    @LOOP
    0;JMP
