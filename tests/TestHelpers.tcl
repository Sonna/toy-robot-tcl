# == Sourced:
# - [tcl \- stdout redirection \- Stack Overflow]
#   (https://stackoverflow.com/questions/14530354/stdout-redirection/14538125#14538125)

# Use a class to simplify the capture code
#
# == Usage Example:
# Attach an instance of the capturing transform
#
#     set myBuffer ""
#     chan push stdout [CapturingTransform new myBuffer]
#
#     # ... call the problem code as normal ...
#
# Detach to return things to normal
#
#     chan pop stdout
#
oo::class create CapturingTransform {
    variable var
    constructor {varName} {
        # Make an alias from the instance variable to the global variable
        my eval [list upvar \#0 $varName var]
    }
    method initialize {handle mode} {
        if {$mode ne "write"} {error "can't handle reading"}
        return {finalize initialize write}
    }
    method finalize {handle} {
        # Do nothing, but mandatory that it exists
    }

    method write {handle bytes} {
        append var $bytes
        # Return the empty string, as we are swallowing the bytes
        return ""
    }
}

# == Sourced:
# - [refchan manual page \- Tcl Built\-In Commands]
#   (https://www.tcl.tk/man/tcl8.6/TclCmd/refchan.htm#M21)
#
# == Usage Example:
# Now we create an instance...
#
#     set string "The quick brown fox jumps over the lazy dog.\n"
#     set ch [chan create read [stringchan new $string]]
#
#     puts [gets $ch];   # Prints the whole string
#
#     seek $ch -5 end;
#     puts [read $ch];   # Prints just the last word
#
oo::class create stringchan {
    variable data pos
    constructor {string {encoding {}}} {
        if {$encoding eq ""} {set encoding [encoding system]}
        set data [encoding convertto $encoding $string]
        set pos 0
    }

    method initialize {ch mode} {
        return "initialize finalize watch read seek"
    }
    method finalize {ch} {
        my destroy
    }
    method watch {ch events} {
        # Must be present but we ignore it because we do not
        # post any events
    }

    # Must be present on a readable channel
    method read {ch count} {
        set d [string range $data $pos [expr {$pos+$count-1}]]
        incr pos [string length $d]
        return $d
    }

    # This method is optional, but useful for the example above
    method seek {ch offset base} {
        switch $base {
            start {
                set pos $offset
            }
            current {
                incr pos $offset
            }
            end {
                set pos [string length $data]
                incr pos $offset
            }
        }
        if {$pos < 0} {
            set pos 0
        } elseif {$pos > [string length $data]} {
            set pos [string length $data]
        }
        return $pos
    }
}
