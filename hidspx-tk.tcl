#!/usr/bin/env wish

#
# Variable
#
set buf_info "Not Connect"
set buf_hidspx "hidspx"
set buf_cmdopt "-d1"
set buf_ex_mask "--"
set spawn_last_line ""
set title "hidspx-GUI/tk \[ver 0.5.0/0.1\]"

#
# top window
#
wm title . $title
wm geometry . "560x440"
wm resizable . false false
frame .main
frame .cons
frame .prog
frame .file
frame .conf

#
# menubar
#
menu .m -type menubar
. configure -menu .m
.m add cascade -label "File" -underline 0 -menu .m.file
.m add cascade -label "Edit" -underline 0 -menu .m.edit
.m add cascade -label "Device" -underline 0 -menu .m.device
.m add cascade -label "Settings" -underline 0 -menu .m.settings
.m add cascade -label "Help" -underline 0 -menu .m.help
#.m add checkbutton -label "Simple"

menu .m.file
.m.file add command -label "Open HEX file" -underline 0 -command "open_hex"
.m.file add command -label "CMD prompt" -underline 4 -command "cmd_prompt"
.m.file add command -label "Write(Both)" -underline 6 -command "write_both"
.m.file add command -label "Write(Flash)" -underline 6 -command "write_flash"
.m.file add command -label "Write(EEPROM)" -underline 6 -command "write_eeprom"
.m.file add command -label "Exit" -underline 1 -command "exit"

menu .m.edit
.m.edit add command -label "Log Copy" -underline 4 -command "log_copy"
.m.edit add command -label "Log Select All" -underline 4 -command "log_select"

menu .m.device
.m.device add command -label "Device Read" -underline 0 -command "dev_read"
.m.device add command -label "Fuse Info" -underline 0 -command "fuse_info"

menu .m.settings
.m.settings add command -label "Set programmer" -underline 4 -command "open_hidspx"
.m.settings add command -label "Simple mode" -underline 7 -command "simple"

menu .m.help
.m.help add command -label "FuseCalc" -underline 0 -command "fuse_calc"
.m.help add command -label "AVR document" -underline 0 -command "avr_doc"
.m.help add command -label "HIDaspx" -underline 0 -command "hidaspx"
.m.help add command -label "hidspx-Tips" -underline 7 -command "tips"
.m.help add command -label "News (Update info.)" -underline 0 -command "news"
.m.help add separator
.m.help add command -label "About hidspx/tk" -underline 0 -command "about"

#
# main
#
frame .main.left
label .main.left.info -relief sunken -borderwidth 1 -font {* 13 bold} -foreground blue -textvariable buf_info
button .main.left.read -text "Read" -command "fuse_info"
labelframe .main.fuse -text "Fuse (HEX)" -relief groove
label .main.fuse.l_lo -text "Lo"
entry .main.fuse.lo -textvariable buf_lo -width 2
label .main.fuse.l_hi -text "Hi"
entry .main.fuse.hi -textvariable buf_hi -width 2
label .main.fuse.l_ex -text "Ex"
entry .main.fuse.ex -textvariable buf_ex -width 2
label .main.fuse.dash -textvariable buf_ex_mask
button .main.fuse.write -text "Write" -command "write_fuse"
button .main.exit -text "Exit" -command "exit"

#
# console
#
text .cons.text -width 70 -height 8 -background black -foreground white -yscrollcommand ".cons.scry set" -wrap no
scrollbar .cons.scry -orient vertical -command ".cons.text yview"

#
# progress bar
#

#
# file
#
frame .file.left
labelframe .file.left.flash -text "Flash" -relief groove
frame .file.left.flash.top
entry .file.left.flash.top.flash -width 32 -textvariable buf_flash
button .file.left.flash.top.select -text "..." -command "open_hex"
frame .file.left.flash.bottom
button .file.left.flash.bottom.write -text "Write" -command "write_flash"
button .file.left.flash.bottom.verify -text "Verify" -command "verify_flash"
button .file.left.flash.bottom.dump -text "Dump" -command "dump_flash"
button .file.left.flash.bottom.save -text "Save" -command "save_flash"

labelframe .file.left.eeprom -text "EEPROM" -relief groove
frame .file.left.eeprom.top
entry .file.left.eeprom.top.eeprom -width 32 -textvariable buf_eeprom
button .file.left.eeprom.top.select -text "..." -command "open_eeprom"
frame .file.left.eeprom.bottom
button .file.left.eeprom.bottom.write -text "Write" -command "write_eeprom"
button .file.left.eeprom.bottom.verify -text "Verify" -command "verify_eeprom"
button .file.left.eeprom.bottom.dump -text "Dump" -command "dump_eeprom"
button .file.left.eeprom.bottom.save -text "Save" -command "save_eeprom"

frame .file.right
frame .file.right.top
button .file.right.top.logclr -text "Log CLR" -command "log_clr"
button .file.right.top.erase -text "ChipErase" -command "chip_erase"

labelframe .file.right.lock -text "Lock Bit" -relief groove
entry .file.right.lock.bit -width 2 -textvariable buf_lock
button .file.right.lock.write -text "Write" -command "write_lock"

labelframe .file.right.cmd -text "Command line Option" -relief groove
entry .file.right.cmd.opt -textvariable buf_cmdopt

#
# conf
#
labelframe .conf.hidspx -text "hidspx.exe File"
entry .conf.hidspx.exe -textvariable buf_hidspx
button .conf.hidspx.select -text "..." -command "open_hidspx"

labelframe .conf.cmd -text "Command Execute (for Expert)"
entry .conf.cmd.exe -width 25 -textvariable buf_cmdexe
bind .conf.cmd.exe <Return> {
	cmd_exe
}
button .conf.cmd.return -text "Enter" -command "cmd_exe"

#
# Layout
#
pack .main.left.info .main.left.read -side top -pady 3
pack .main.fuse.l_lo .main.fuse.lo .main.fuse.l_hi .main.fuse.hi .main.fuse.l_ex .main.fuse.ex .main.fuse.dash .main.fuse.write -side left -padx 5
pack .main.left .main.fuse -side left -padx 10
pack .main.exit -side right -padx 10
pack .cons.text .cons.scry -side left -fill both
pack .file.left.flash.top.flash .file.left.flash.top.select -side left
pack .file.left.flash.bottom.write .file.left.flash.bottom.verify .file.left.flash.bottom.dump .file.left.flash.bottom.save -side left -padx 5
pack .file.left.flash.top .file.left.flash.bottom
pack .file.left.eeprom.top.eeprom .file.left.eeprom.top.select -side left
pack .file.left.eeprom.bottom.write .file.left.eeprom.bottom.verify .file.left.eeprom.bottom.dump .file.left.eeprom.bottom.save -side left -padx 5
pack .file.left.eeprom.top .file.left.eeprom.bottom
pack .file.left.flash .file.left.eeprom -side top -pady 5
pack .file.right.top.logclr .file.right.top.erase -side left -padx 5
pack .file.right.lock.bit .file.right.lock.write -side left -padx 5
pack .file.right.cmd.opt -padx 5 -pady 5
pack .file.right.top .file.right.lock .file.right.cmd -pady 5
pack .file.left .file.right -side left -padx 5
pack .conf.hidspx.exe .conf.hidspx.select -side left -padx 5
pack .conf.cmd.exe .conf.cmd.return -side left -padx 5
pack .conf.hidspx .conf.cmd -side left -padx 5
pack .main .cons .file .conf -side top -padx 10 -pady 3

#
# Function
#
proc cons_put { message } {
#	.cons.text -state normal
	.cons.text insert end "$message"
	.cons.text yview moveto 1
#	.cons.text -state disabled
}

proc not_impl {} {
	cons_put "*** function not implemented. ***\n"
}

proc open_hex {} {
	global buf_flash
	set buf_flash [tk_getOpenFile -filetypes {{{Intel Hex File} {.hex}} {{All File} {*.*}}}]
	.file.left.flash.top.flash xview moveto 1
}

proc open_eeprom {} {
	global buf_eeprom
	set buf_eeprom [tk_getOpenFile -filetypes {{{EEPROM File} {.eep}} {{All File} {*.*}}}]
	.file.left.eeprom.top.eeprom xview moveto 1
}

proc open_hidspx {} {
	global buf_hidspx
	set buf_hidspx [tk_getOpenFile]
	.conf.hidspx.exe xview moveto 1
}

proc spawn { cmd } {
	global spawn_last_line
	cons_put ">$cmd\n"
	if [catch {open "|$cmd 2>@ stdout" r} fd] {
		cons_put "failed\n"
	} else {
		while {[gets $fd line] >= 0} {
			cons_put $line
			cons_put "\n"
			set spawn_last_line $line
		}
	}
}

proc spawn_spx { opt } {
	global buf_hidspx
	global buf_cmdopt
	spawn "$buf_hidspx $buf_cmdopt $opt"
}

proc help {} {
	global buf_hidspx
	spawn "$buf_hidspx -h"
}

proc cmd_prompt {} {
	not_impl
}

proc fuse_info {} {
	spawn_spx "-r"
	dev_read
	spawn_spx "-rf"
}

proc write_fuse {} {
	global title
	global buf_lo
	global buf_hi
	global buf_ex
	append hex $buf_lo $buf_hi $buf_ex
	set rc [regexp -- {[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F]} $hex]
	if {1 == $rc} {
		set rc [tk_messageBox -type yesno -default no -icon question -title "$title" -message "Fuses is ReWritten. Is it good ?"]
		if {"yes" == $rc} {
			append cmd "-fL0x" $buf_lo " -fH0x" $buf_hi " -fX0x" $buf_ex
			spawn_spx $cmd
		}
	} else {
		tk_messageBox -type ok -icon error -title "$title" -message "Please Set efuse by the hexadecimal number of 2 characters."
	}
}

proc write_both {} {
	not_impl
}

proc write_flash {} {
	global title
	global buf_flash
	if {"" != $buf_flash} {
		spawn_spx "$buf_flash"
	} else {
		tk_messageBox -type ok -icon error -title "$title" -message "Select Flash file"
	}
}

proc write_eeprom {} {
	global title
	global buf_eeprom
	if {"" != $buf_eeprom} {
		spawn_spx "$buf_eeprom"
	} else {
		tk_messageBox -type ok -icon error -title "$title" -message "Select Flash file"
	}
}

proc verify_flash {} {
	global title
	global buf_flash
	if {"" != $buf_flash} {
		spawn_spx "-v $buf_flash"
	} else {
		tk_messageBox -type ok -icon error -title "$title" -message "Select Flash file"
	}
}

proc dump_flash {} {
	not_impl
}

proc save_flash {} {
	not_impl
}

proc verify_eeprom {} {
	global title
	global buf_eeprom
	if {"" != $buf_eeprom} {
		spawn_spx "-v $buf_eeprom"
	} else {
		tk_messageBox -type ok -icon error -title "$title" -message "Select Flash file"
	}
}

proc dump_eeprom {} {
	not_impl
}

proc save_eeprom {} {
	not_impl
}

proc log_clr {} {
	not_impl
}

proc chip_erase {} {
	global title
	set rc [tk_messageBox -type yesno -default no -icon question -title "$title" -message "All the settings and data in the device are deleted. Is it good ?"]
	if {"yes" == $rc} {
		spawn_spx "-e"
	}
}

proc log_copy {} {
	not_impl
}

proc log_select {} {
	not_impl
}

proc write_lock {} {
	global title
	global buf_lock
	set rc [regexp -- {[0-9A-F][0-9A-F]} $buf_lock]
	if {1 == $rc} {
		set rc [tk_messageBox -type yesno -default no -icon question -title "$title" -message "Lock bit is ReWritten. Is it good ?"]
		if {"yes" == $rc} {
			append cmd "-l0x" $buf_lock
			spawn_spx $cmd
		}
	} else {
		tk_messageBox -type ok -icon error -title "$title" -message "Please Set Lock bit by the hexadecimal number of 2 characters."
	}
}

proc cmd_exe {} {
	not_impl
}

proc dev_read {} {
	global spawn_last_line
	global buf_info
	global buf_lo
	global buf_hi
	global buf_ex
	global buf_ex_mask
	global buf_lock
	spawn_spx "-rl"
	set rc [scan "$spawn_last_line" {%s %[0-9A-F]:%[0-9A-F] %[0-9A-F]:%[0-9A-F] %[0-9A-F]:%[0-9A-F] %[0-9A-F]} name lbuf lmask hbuf hmask xbuf xmask lock]
	if {8 == $rc} {
		set buf_info $name
		set buf_lo $lbuf
		set buf_hi $hbuf
		set buf_ex $xbuf
		set buf_ex_mask $xmask
		set buf_lock $lock
	} else {
		set buf_info "Not Connect"
	}
}

proc simple {} {
	not_impl
}

proc fuse_calc {} {
	not_impl
}

proc avr_doc {} {
	not_impl
}

proc hidaspx {} {
	not_impl
}

proc tips {} {
	not_impl
}

proc news {} {
	not_impl
}

proc about {} {
	not_impl
}

help
dev_read
.cons.text yview moveto 0

