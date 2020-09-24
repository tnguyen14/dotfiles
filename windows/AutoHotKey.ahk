; Switch desktops
^+l::
        Send, ^#{Right}
return

^+h::
        Send, ^#{Left}
return

; Open task view
^+k::
        Send, #{Tab}
return

; Make Cpaslock work like Escape
Capslock::Esc

; make it more Mac-like
!q::
        Send, !{F4}
return
!w::
        Send, ^w
return
!t::
        Send, ^t
return
!r::
        Send, ^r
return
!c::
        Send, ^c
return
!v::
        Send, ^v
return
!x::
        Send, ^x
return
!l::
        Send, ^l
return
!a::
        Send, ^a
return
!f::
        Send, ^f
return
!k::
        Send, ^k
return
!e::
        Send, ^e
return
!s::
	Send, ^s
return
!+t::
        Send, ^+t
return
!+r::
	Send, ^+r
return
!g::
        Send, ^g
return
!+g::
        Send, ^+g
return
!LButton::
        Send, ^{Click}
return
!Enter::
        Send, ^{Enter}
return

; Clipboard
^+p::
        Send, #v
return

; Play Pause
!p::
        Send, {Media_Play_Pause}
return
![::
	Send, {Media_Prev}
return
!]::
	Send, {Media_Next}
return
