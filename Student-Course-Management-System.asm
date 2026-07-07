.MODEL SMALL
.STACK 100H
.DATA  
    sign1       DB '********************************$'
    log_page    DB '         LOGIN PAGE$'
    ; Login prompts
    login_username  DB 'Enter Username: $'
    login_pass      DB 'Enter Password: $'
    wrong_username  DB 'Invalid Username or Password! Try Again$'
    ; Storage for user input
    name_       DB 8 DUP(?)    ; Array to store input username
    pass_       DB 5 DUP(?)    ; Array to store input password
    ; Predefined users and passwords
    admin       DB 'admin'     ; admin username
    adminpass   DB '12345'     ; admin password
    user1       DB 'user1'     ; user1 username
    user1pass   DB 'pass1'     ; user1 password
    user2       DB 'user2'     ; user2 username
    user2pass   DB 'pass2'     ; user2 password
    user3       DB 'user3'     ; user3 username
    user3pass   DB 'pass3'     ; user3 password

    ; === user 1 Information ===
    user1_header     DB '==== User 1 Information ====$'
    user1_name       DB 'Name: Taeyeon Kim$'
    user1_id         DB 'ID: 21301186$'
    user1_warn_txt   DB 'warnings: 0$' 
    user1_warnings   DB 0

    ; === user 2 Information ===
    user2_header     DB '==== User 2 Information ====$'
    user2_name       DB 'Name: Peter Parker$'
    user2_id         DB 'ID: 21201613$'
    user2_warn_txt   DB 'warnings: 3$'
    user2_warnings   DB 3

    ; === user 3 Information ===
    user3_header     DB '==== User 3 Information ====$'
    user3_name       DB 'Name: Harry Potter$'
    user3_id         DB 'ID: 21201149$'
    user3_warn_txt   DB 'warnings: 1$'
    user3_warnings   DB 1
    
    ; === Seat Information ===
    seat_header     DB 'Available Library Seats:$'
    seat1           DB 'Seat #1 (Window)$'
    seat2           DB 'Seat #2$'
    seat3           DB 'Seat #3$'
    seat4           DB 'Seat #4$'
    seat5           DB 'Seat #5$'
    seat6           DB 'Seat #6$'
    seat7           DB 'Seat #7 (Aisle)$' 
    selected_msg    DB 'Your Booked Seat: $'
    
    ; --- Seat Booking Messages ---
    reg_prompt      DB 'Enter seat number to book (0 to cancel): $'
    time_prompt     DB 'Enter booking hours (1-5): $'   ; ask booking hours
    max_hour_msg    DB 'Maximum booking hours (5) reached!$'
    done_msg        DB 'Booking Complete!$'

    ; --- User Managaes ---
    u_menu_1 DB '1. Book a Seat$'
    u_menu_2 DB '2. View My Seat$'
    u_menu_0 DB '0. Logout$'
    prompt_m DB 'Select an option: $'

    ; --- Admin Messages ---
    admin_header DB '=== Library Admin Control Panel ===$'
    a_menu_1     DB '1. View All Seats Status$'
    a_menu_2     DB '2. Reset Library (Close for the day)$'
    a_menu_0     DB '0. Logout$'
    reset_msg    DB 'All seats and bookings have been successfully reset!$'
    
    ; --- System Variables ---
    seat_status     DB 7 DUP(0)             ; current seat status (0: Empty, 1: In Use), initial seat status is 0
    seat_taken_msg  DB 'Sorry, this seat is already taken!$'
    
    
    ; Variables for seat selection
    user1_booked    DB 0           ; Seat number User 1 booked
    user2_booked    DB 0           ; Seat number User 2 booked
    user3_booked    DB 0           ; Seat number User 3 booked
    booking_hours   DB 0
    already_booked_msg DB 'You already booked a seat!$'
    warning_limit_msg  DB 'Warning limit reached! You cannot book a seat.$'
        
    ; return & login success message
    return_menu_msg    DB 'Returning to menu in: $'
    login_success_msg  DB 'Login Successful! Loading in: $'

    
    newline        DB 0DH, 0AH, '$'

.CODE
MAIN PROC
    ; Initialize DS
    MOV AX, @DATA
    MOV DS, AX  
    
show_login_page:
    mov ah, 2
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h  
    mov ah, 2
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h  
    mov ah, 9
    lea dx, sign1
    int 21h  
    mov ah, 2
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h  
    mov ah, 9
    lea dx, log_page
    int 21h  
    mov ah, 2
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h  
    mov ah, 9
    lea dx, sign1
    int 21h 
    jmp taking_input

; User input
againtry: 
    mov ah, 2
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h  
    mov ah, 2
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h  
    mov ah, 9
    lea dx, wrong_username
    int 21h  
    mov cx, 7 
    mov si, 0          ; Source index  
    
taking_input:
    ; Taking username from user
    mov ah, 2
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h  
    mov ah, 2
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h  
    mov ah, 2
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h
    mov ah, 9
    lea dx, login_username
    int 21h 
    mov cx, 5      ; every username is 5 letter
    mov si, 0 
    
take_name:
    mov ah, 1       
    int 21h     
    mov name_[si], al
    inc si
    loop take_name    
    mov ah, 2
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h  
    ; Taking password from the user
    mov ah, 9
    lea dx, login_pass
    int 21h  
    mov cx, 5
    mov si, 0 
    
takepass:
    mov ah, 1       
    int 21h
    mov pass_[si], al
    inc si
    loop takepass
    mov ah, 2
    mov dl, 0dh
    int 21h
    mov dl, 0ah
    int 21h
 
    ; For admin
check0:
    mov cx, 5      ; admin username length is 5 (admin)
    mov si, 0  
    
aduser:
    mov al, admin[si]
    mov bl, name_[si]
    cmp al, bl
    jne check1
    inc si
    loop aduser
    jmp admin_passcheck    ; This label is correct

check1:
    mov cx, 5     
    mov si, 0 
    
user1user:
    mov al, user1[si]
    mov bl, name_[si]
    cmp al, bl
    jne check2
    inc si
    loop user1user
    jmp user1_passcheck   ; This label is correct

check2: 
    mov cx, 5
    mov si, 0 
    
user2user:
    mov al, user2[si]
    mov bl, name_[si]
    cmp al, bl
    jne check3
    inc si
    loop user2user
    jmp user2_passcheck   ; This label is correct

check3: 
    mov cx, 5
    mov si, 0 
    
user3user:
    mov al, user3[si]
    mov bl, name_[si]
    cmp al, bl
    ;jne againtry
    je skip_jump1
    jmp againtry
    skip_jump1:

    inc si
    loop user3user
    jmp user3_passcheck   ; This label is correct

; For admin
admin_passcheck:
    mov cx, 5
    mov si, 0 
    
adpass:
    mov al, adminpass[si]
    mov bl, pass_[si]
    cmp al, bl
    ;jne againtry
    je skip_jump2
    jmp againtry
    skip_jump2:
    inc si
    loop adpass
    jmp admin_panel

; For user1
user1_passcheck:         ; This label exists and is correct
    mov cx, 5
    mov si, 0  
    
check_user1pass:
    mov al, BYTE PTR user1pass[si]
    mov bl, pass_[si]
    cmp al, bl
    ;jne againtry
    je skip_jump3
    jmp againtry
    skip_jump3:
    inc si
    loop check_user1pass
    jmp user1_panel

; For user2
user2_passcheck:         ; This label exists and is correct
    mov cx, 5
    mov si, 0
    
check_user2pass:
    mov al, BYTE PTR user2pass[si]
    mov bl, pass_[si]
    cmp al, bl
    ;jne againtry
    je skip_jump4
    jmp againtry
    skip_jump4:
    inc si
    loop check_user2pass
    jmp user2_panel

; For user3
user3_passcheck:         ; This label exists and is correct
    mov cx, 5
    mov si, 0
check_user3pass:
    mov al, BYTE PTR user3pass[si]
    mov bl, pass_[si]
    cmp al, bl
    ;jne againtry
    je skip_jump5
    jmp againtry
    skip_jump5:
    inc si
    loop check_user3pass
    jmp user3_panel
    
MAIN ENDP

; ==========================================
; 1-second system delay function (Utilizes BIOS INT 15h, AH=86h)

delay_1s PROC
    push ax
    push cx
    push dx

    mov ah, 86h         ; BIOS Wait Interrupt
    mov cx, 000Fh       ; Upper 16-bit of 1,000,000 microseconds
    mov dx, 4240h       ; Lower 16-bit of 1,000,000 microseconds (Total 1 second delay)
    int 15h             ; implement 1s system waiting 
    pop dx
    pop cx
    pop ax
    ret
delay_1s ENDP

; ==========================================
; show 5 seconds countdown funcion (5. 4. 3. 2. 1.)

countdown_5s PROC
    push ax
    push bx
    push cx
    push dx

    mov cx, 5           ; Loop counter for 5 seconds
    mov bl, '5'         ; starting number's ASCII code

cd_loop:
    ; 1. print current number
    mov dl, bl
    mov ah, 2
    int 21h

    ; 2. print ". "
    mov dl, '.'
    mov ah, 2
    int 21h
    mov dl, ' '
    mov ah, 2
    int 21h

    ; 3. call 1s waiting function
    call delay_1s

    ; 4. Decrement ASCII character and repeat loop
    dec bl              ; '5'->'4'
    loop cd_loop        ; loop until cx -> 0

    ; when finish countdown, newline
    lea dx, newline
    mov ah, 9
    int 21h

    pop dx
    pop cx
    pop bx
    pop ax
    ret
countdown_5s ENDP

; ==========================================
; ADMIN menu (master control)

admin_panel PROC
show_admin_panel:
    ; Clear the screen
    mov ah, 0
    mov al, 3
    int 10h

    ; admin header
    lea dx, admin_header
    mov ah, 9
    int 21h
    lea dx, newline
    int 21h
    lea dx, newline
    int 21h

    ; print admin header
    lea dx, a_menu_1
    int 21h
    lea dx, newline
    int 21h
    lea dx, a_menu_2
    int 21h
    lea dx, newline
    int 21h
    lea dx, a_menu_0
    int 21h
    lea dx, newline
    int 21h
    lea dx, newline
    int 21h
    lea dx, prompt_m    ; "Select an option: "
    int 21h

    ; enter the option
    mov ah, 1
    int 21h

    ; Branch based on user input
    cmp al, '1'
    je admin_view_seats
    cmp al, '2'
    je admin_reset
    cmp al, '0'
    je admin_exit
    jmp show_admin_panel

admin_view_seats:
    ; print whole seat status
    lea dx, newline
    mov ah, 9
    int 21h
    call display_available_seats  
    
    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, return_menu_msg
    mov ah, 9       
    int 21h
    call countdown_5s  ; countdown 5 seconds
    jmp show_admin_panel

admin_reset:
    ; Global variables are used to maintain booking states across different logins 
    ; This reset function clears all global seat states at the end of the day
    
    ; 1. initialize user 1, 2, 3's individual booking record to 0
    mov user1_booked, 0
    mov user2_booked, 0
    mov user3_booked, 0

    ; 2. all seats(1~7) resest(0) using loop 
    mov cx, 7
    mov si, 0
reset_loop:
    mov seat_status[si], 0
    inc si
    loop reset_loop

    ; print reset complete message
    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, reset_msg
    int 21h

    ; go back to menu
    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, return_menu_msg
    mov ah, 9
    int 21h
    call countdown_5s      ; countdown 5s
    jmp show_admin_panel

admin_exit:
    jmp taking_input

admin_panel ENDP

; =========================================
; User 1 seat booking management

manage_seat1 PROC
    push ax
    push bx
    push cx
    push dx
    push si

    ; 1. Enforce limitation: One seat per user
    mov al, user1_booked
    cmp al, 0
    je check_warnings1

    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, already_booked_msg
    int 21h
    jmp finish_booking

check_warnings1:
    ; 2. check 3 strikes out
    mov al, user1_warnings
    cmp al, 3
    jl show_seats

    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, warning_limit_msg
    int 21h
    jmp finish_booking

show_seats:
    call display_available_seats

prompt_seat:
    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, reg_prompt
    int 21h
    mov ah, 1
    int 21h
    sub al, '0'
    
    ; if select 0, jump to cancel area
    cmp al, 0
    je cancel_booking      

    cmp al, 1
    jl prompt_seat
    cmp al, 7
    jg prompt_seat

    ; 3. check it is empty (is it 1?)
    ; Convert ASCII input to integer and use it as an array index (0-based)
    mov ah, 0
    mov si, ax
    dec si                  ; Subtract 1 because arrays start at index 0
    mov bl, seat_status[si]
    cmp bl, 1              ; 1(use) -> error
    je seat_taken

    mov user1_booked, al
    push si

prompt_time:
    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, time_prompt
    int 21h
    mov ah, 1
    int 21h
    sub al, '0'

    cmp al, 1
    jl time_error
    cmp al, 5
    jg time_error

    ; 4. confirm booking & status change
    mov booking_hours, al
    pop si
    mov seat_status[si], 1 ; Mark the selected seat as in-use (1)

    ; print booking message
    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, done_msg
    int 21h
    
    ; display booking seat
    call display_user1_seat
    jmp finish_booking

seat_taken:
    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, seat_taken_msg
    int 21h
    jmp prompt_seat

time_error:
    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, max_hour_msg
    int 21h
    jmp prompt_time

cancel_booking:
    ; If cancel (0) is selected, exit without booking
finish_booking:
    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, newline
    int 21h
    lea dx, return_menu_msg
    mov ah, 9
    int 21h
    call countdown_5s

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
manage_seat1 ENDP

; user 2 & 3 is the same as user 1


; =========================================
; User 2 seat booking management

manage_seat2 PROC
    push ax
    push bx
    push cx
    push dx
    push si

    mov al, user2_booked
    cmp al, 0
    je check_warnings2      

    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, already_booked_msg
    int 21h
    jmp finish_booking2

check_warnings2:
    mov al, user2_warnings
    cmp al, 3
    jl show_seats2           
    
    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, warning_limit_msg
    int 21h
    jmp finish_booking2

show_seats2:
    call display_available_seats

prompt_seat2:
    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, reg_prompt      
    int 21h
    mov ah, 1
    int 21h
    sub al, '0'
    cmp al, 0
    je finish_booking2       

    cmp al, 1
    jl prompt_seat2
    cmp al, 7
    jg prompt_seat2

    mov ah, 0
    mov si, ax
    dec si
    mov bl, seat_status[si]
    cmp bl, 1
    je seat_taken2           

    mov user2_booked, al
    push si                 

prompt_time2:
    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, time_prompt     
    int 21h
    mov ah, 1
    int 21h
    sub al, '0'

    cmp al, 1
    jl time_error2
    cmp al, 5
    jg time_error2


    mov booking_hours, al   
    pop si                  
    mov seat_status[si], 1  

    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, done_msg
    int 21h
    jmp finish_booking2

seat_taken2:
    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, seat_taken_msg
    int 21h
    jmp prompt_seat2         

time_error2:
    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, max_hour_msg    
    int 21h
    jmp prompt_time2         

cancel_booking2:
finish_booking2:
    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, newline
    int 21h
    lea dx, return_menu_msg    
    mov ah, 9
    int 21h
    call countdown_5s
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
manage_seat2 ENDP

; =========================================
; User 3 seat booking management

manage_seat3 PROC
    push ax
    push bx
    push cx
    push dx
    push si

    mov al, user3_booked
    cmp al, 0
    je check_warnings3      

    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, already_booked_msg
    int 21h
    jmp finish_booking3

check_warnings3:
    mov al, user3_warnings
    cmp al, 3
    jl show_seats3           
    
    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, warning_limit_msg
    int 21h
    jmp finish_booking3

show_seats3:
    call display_available_seats

prompt_seat3:
    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, reg_prompt      
    int 21h
    mov ah, 1
    int 21h
    sub al, '0'
    cmp al, 0
    je finish_booking3       

    cmp al, 1
    jl prompt_seat3
    cmp al, 7
    jg prompt_seat3

    mov ah, 0
    mov si, ax
    dec si                  
    mov bl, seat_status[si]
    cmp bl, 1
    je seat_taken3           

    mov user3_booked, al    
    push si                 

prompt_time3:
    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, time_prompt     
    int 21h
    mov ah, 1
    int 21h
    sub al, '0'

    cmp al, 1
    jl time_error3
    cmp al, 5
    jg time_error3

    mov booking_hours, al   
    pop si                  
    mov seat_status[si], 1  

    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, done_msg
    int 21h
    jmp finish_booking3

seat_taken3:
    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, seat_taken_msg
    int 21h
    jmp prompt_seat3         

time_error3:
    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, max_hour_msg    
    int 21h
    jmp prompt_time3         

cancel_booking3:
finish_booking3:
    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, newline
    int 21h
    lea dx, return_menu_msg    
    mov ah, 9
    int 21h
    call countdown_5s
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
manage_seat3 ENDP

; Support procedures
display_available_seats PROC
    ; First, display header for available seats
    lea dx, seat_header
    mov ah, 9
    int 21h
    lea dx, newline
    mov ah, 9
    int 21h
    
    ; Display Seat 1 with seats
    lea dx, seat1
    mov ah, 9
    int 21h
    
    ; Display available seats for seat 1
    mov dl, ' '        ; Space after seat
    mov ah, 2
    int 21h
    mov dl, '['        ; Opening bracket
    mov ah, 2
    int 21h
    mov al, seat_status[0]  ; Get number of seats
    add al, '0'             ; Convert to ASCII
    mov dl, al
    mov ah, 2
    int 21h
    mov dl, ']'        ; Closing bracket
    mov ah, 2
    int 21h
    lea dx, newline
    mov ah, 9
    int 21h
    
    ; Display Seat 2 with seats
    lea dx, seat2
    mov ah, 9
    int 21h
    mov dl, ' '
    mov ah, 2
    int 21h
    mov dl, '['
    mov ah, 2
    int 21h
    mov al, seat_status[1]
    add al, '0'
    mov dl, al
    mov ah, 2
    int 21h
    mov dl, ']'
    mov ah, 2
    int 21h
    lea dx, newline
    mov ah, 9
    int 21h
    
    ; Display Seat 3 with seats
    lea dx, seat3
    mov ah, 9
    int 21h
    mov dl, ' '
    mov ah, 2
    int 21h
    mov dl, '['
    mov ah, 2
    int 21h
    mov al, seat_status[2]
    add al, '0'
    mov dl, al
    mov ah, 2
    int 21h
    mov dl, ']'
    mov ah, 2
    int 21h
    lea dx, newline
    mov ah, 9
    int 21h
    
    ; Display Seat 4 with seats
    lea dx, seat4
    mov ah, 9
    int 21h
    mov dl, ' '
    mov ah, 2
    int 21h
    mov dl, '['
    mov ah, 2
    int 21h
    mov al, seat_status[3]
    add al, '0'
    mov dl, al
    mov ah, 2
    int 21h
    mov dl, ']'
    mov ah, 2
    int 21h
    lea dx, newline
    mov ah, 9
    int 21h
    
    ; Display Seat 5 with seats
    lea dx, seat5
    mov ah, 9
    int 21h
    mov dl, ' '
    mov ah, 2
    int 21h
    mov dl, '['
    mov ah, 2
    int 21h
    mov al, seat_status[4]
    add al, '0'
    mov dl, al
    mov ah, 2
    int 21h
    mov dl, ']'
    mov ah, 2
    int 21h
    lea dx, newline
    mov ah, 9
    int 21h
    
    ; Display Seat 6 with seats
    lea dx, seat6
    mov ah, 9
    int 21h
    mov dl, ' '
    mov ah, 2
    int 21h
    mov dl, '['
    mov ah, 2
    int 21h
    mov al, seat_status[5]
    add al, '0'
    mov dl, al
    mov ah, 2
    int 21h
    
    mov dl, ']'
    mov ah, 2
    int 21h
    lea dx, newline
    mov ah, 9
    int 21h
    
    ; Display Seat 7 with seats
    lea dx, seat7
    mov ah, 9
    int 21h
    mov dl, ' '
    mov ah, 2
    int 21h
    mov dl, '['
    mov ah, 2
    int 21h
    mov al, seat_status[6]
    add al, '0'
    mov dl, al
    mov ah, 2
    int 21h
    mov dl, ']'
    mov ah, 2
    int 21h
    lea dx, newline
    mov ah, 9
    int 21h
    ret
    
display_available_seats ENDP

; --------------------------------------
; viewer for confirming booked seat (User 1)

display_user1_seat PROC
    push ax
    push dx
    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, selected_msg
    int 21h
    lea dx, newline
    int 21h

    mov al, user1_booked
    cmp al, 0
    je done_u1          ; if no booking, exit

    cmp al, 1
    je u1_s1
    cmp al, 2
    je u1_s2
    cmp al, 3
    je u1_s3
    cmp al, 4
    je u1_s4
    cmp al, 5
    je u1_s5
    cmp al, 6
    je u1_s6
    cmp al, 7
    je u1_s7
    jmp done_u1

u1_s1: lea dx, seat1
       jmp print_u1
u1_s2: lea dx, seat2
       jmp print_u1
u1_s3: lea dx, seat3
       jmp print_u1
u1_s4: lea dx, seat4
       jmp print_u1
u1_s5: lea dx, seat5
       jmp print_u1
u1_s6: lea dx, seat6
       jmp print_u1
u1_s7: lea dx, seat7

print_u1:
    mov ah, 9
    int 21h
    lea dx, newline
    int 21h
done_u1:
    pop dx
    pop ax
    ret
display_user1_seat ENDP 

; --------------------------------------
; viewer for confirming booked seat (User 2)

display_user2_seat PROC
    push ax
    push dx
    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, selected_msg
    int 21h
    lea dx, newline
    int 21h

    mov al, user2_booked
    cmp al, 0
    je done_u2

    cmp al, 1
    je u2_s1
    cmp al, 2
    je u2_s2
    cmp al, 3
    je u2_s3
    cmp al, 4
    je u2_s4
    cmp al, 5
    je u2_s5
    cmp al, 6
    je u2_s6
    cmp al, 7
    je u2_s7
    jmp done_u2

u2_s1: lea dx, seat1
       jmp print_u2
u2_s2: lea dx, seat2
       jmp print_u2
u2_s3: lea dx, seat3
       jmp print_u2
u2_s4: lea dx, seat4
       jmp print_u2
u2_s5: lea dx, seat5
       jmp print_u2
u2_s6: lea dx, seat6
       jmp print_u2
u2_s7: lea dx, seat7

print_u2:
    mov ah, 9
    int 21h
    lea dx, newline
    int 21h
done_u2:
    pop dx
    pop ax
    ret
display_user2_seat ENDP 

; --------------------------------------
; viewer for confirming booked seat (User 3)

display_user3_seat PROC
    push ax
    push dx
    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, selected_msg
    int 21h
    lea dx, newline
    int 21h

    mov al, user3_booked
    cmp al, 0
    je done_u3

    cmp al, 1
    je u3_s1
    cmp al, 2
    je u3_s2
    cmp al, 3
    je u3_s3
    cmp al, 4
    je u3_s4
    cmp al, 5
    je u3_s5
    cmp al, 6
    je u3_s6
    cmp al, 7
    je u3_s7
    jmp done_u3

u3_s1: lea dx, seat1
       jmp print_u3
u3_s2: lea dx, seat2
       jmp print_u3
u3_s3: lea dx, seat3
       jmp print_u3
u3_s4: lea dx, seat4
       jmp print_u3
u3_s5: lea dx, seat5
       jmp print_u3
u3_s6: lea dx, seat6
       jmp print_u3
u3_s7: lea dx, seat7

print_u3:
    mov ah, 9
    int 21h
    lea dx, newline
    int 21h
done_u3:
    pop dx
    pop ax
    ret
display_user3_seat ENDP

; ==========================================
; USER 1 menu

user1_panel PROC
show_panel1:
    ; 1. clear
    mov ah, 0
    mov al, 3
    int 10h

    ; 2. print user1 info
    lea dx, user1_header
    mov ah, 9
    int 21h
    lea dx, newline
    int 21h
    lea dx, user1_name
    mov ah, 9
    int 21h
    lea dx, newline
    int 21h
    lea dx, user1_id
    mov ah, 9
    int 21h
    lea dx, newline
    int 21h
    lea dx, user1_warn_txt
    mov ah, 9
    int 21h
    lea dx, newline
    int 21h

menu_loop1:
    ; 3. print menu
    lea dx, newline
    int 21h
    lea dx, u_menu_1
    int 21h
    lea dx, newline
    int 21h
    lea dx, u_menu_2
    int 21h
    lea dx, newline
    int 21h
    lea dx, u_menu_0
    int 21h
    lea dx, newline
    int 21h
    lea dx, newline
    int 21h
    lea dx, prompt_m
    int 21h

    ; 4. enter selection
    mov ah, 1
    int 21h

    ; 5. go to selected option
    cmp al, '1'
    je opt_book1
    cmp al, '2'
    je opt_view1
    cmp al, '0'
    je opt_exit1
    jmp menu_loop1      ; select invalid option -> select again

opt_book1:
    call manage_seat1   ; call seat manage
    jmp show_panel1     ; when finish, back to menu

opt_view1:
    call display_user1_seat ; call viewr for booked seat
    
    ; countdown 5s and then go to menu
    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, return_menu_msg
    int 21h
    call countdown_5s
    jmp show_panel1     ; go to menu

opt_exit1:
    jmp taking_input            ; if select 0, logout (back to login)

user1_panel ENDP
    
; ==========================================
; USER 2 menu

user2_panel PROC
show_panel2:
    mov ah, 0
    mov al, 3
    int 10h

    lea dx, user2_header
    mov ah, 9
    int 21h
    lea dx, newline
    int 21h
    lea dx, user2_name
    mov ah, 9
    int 21h
    lea dx, newline
    int 21h
    lea dx, user2_id
    mov ah, 9
    int 21h
    lea dx, newline
    int 21h
    lea dx, user2_warn_txt
    mov ah, 9
    int 21h
    lea dx, newline
    int 21h

menu_loop2:
    lea dx, newline
    int 21h
    lea dx, u_menu_1
    int 21h
    lea dx, newline
    int 21h
    lea dx, u_menu_2
    int 21h
    lea dx, newline
    int 21h
    lea dx, u_menu_0
    int 21h
    lea dx, newline
    int 21h
    lea dx, newline
    int 21h
    lea dx, prompt_m
    int 21h

    mov ah, 1
    int 21h

    cmp al, '1'
    je opt_book2
    cmp al, '2'
    je opt_view2
    cmp al, '0'
    je opt_exit2
    jmp menu_loop2

opt_book2:
    call manage_seat2   
    jmp show_panel2     

opt_view2:
    call display_user2_seat 
    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, return_menu_msg
    int 21h
    call countdown_5s
    jmp show_panel2     

opt_exit2:
    jmp taking_input            
user2_panel ENDP

; ==========================================
; USER 3 menu

user3_panel PROC
show_panel3:
    mov ah, 0
    mov al, 3
    int 10h

    lea dx, user3_header
    mov ah, 9
    int 21h
    lea dx, newline
    int 21h
    lea dx, user3_name
    mov ah, 9
    int 21h
    lea dx, newline
    int 21h
    lea dx, user3_id
    mov ah, 9
    int 21h
    lea dx, newline
    int 21h
    lea dx, user3_warn_txt
    mov ah, 9
    int 21h
    lea dx, newline
    int 21h
    lea dx, newline
    int 21h

menu_loop3:
    lea dx, newline
    int 21h
    lea dx, u_menu_1
    int 21h
    lea dx, newline
    int 21h
    lea dx, u_menu_2
    int 21h
    lea dx, newline
    int 21h
    lea dx, u_menu_0
    int 21h
    lea dx, newline
    int 21h
    lea dx, newline
    int 21h
    lea dx, prompt_m
    int 21h

    mov ah, 1
    int 21h

    cmp al, '1'
    je opt_book3
    cmp al, '2'
    je opt_view3
    cmp al, '0'
    je opt_exit3
    jmp menu_loop3

opt_book3:
    call manage_seat3   
    jmp show_panel3     

opt_view3:
    call display_user3_seat 
    lea dx, newline
    mov ah, 9
    int 21h
    lea dx, return_menu_msg
    int 21h
    call countdown_5s
    jmp show_panel3  

opt_exit3:
    jmp taking_input            
user3_panel ENDP
    
exit:
    MOV AX, 4C00H
    INT 21H 
    
END MAIN