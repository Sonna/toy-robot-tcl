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
