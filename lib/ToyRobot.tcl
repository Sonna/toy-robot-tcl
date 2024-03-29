# package require TclOO;

oo::class create Robot {
    variable x
    variable y
    variable facing

    constructor {{dx 0} {dy 0} {dfacing "NORTH"}} {
        set x $dx
        set y $dy
        set facing $dfacing
    }

    method getX {} { return $x }
    method getY {} { return $y }
    method getFacing {} { return $facing }

    method place {coordinates} {
      # lassign [regexp -all -inline {,} {coordinates}] x y facing
      lassign [split $coordinates ","] x y facing
    }

    method report {} {
      puts "$x,$y,$facing"
    }

    method left {} {
      set facing [dict get [my Turn] $facing LEFT]
    }

    method right {} {
      set facing [dict get [my Turn] $facing RIGHT]
    }

    method move {} {
      set x [expr {$x + [dict get [my Move] $facing x]}]
      set y [expr {$y + [dict get [my Move] $facing y]}]

      if {$x < 0 || $x > 4} {
        set x [expr {$x - [dict get [my Move] $facing x]}]
      }

      if {$y < 0 || $y > 4} {
        set y [expr {$y - [dict get [my Move] $facing y]}]
      }
    }

    method exec {{command ""} {args ""}} {
      switch $command {
        PLACE {my place $args}
        REPORT {my report}
        MOVE {my move}
        LEFT {my left}
        RIGHT {my right}
        default {
          # Do nothing
        }
      }
    }

    method Turn {} {
      return {
        NORTH {LEFT WEST RIGHT EAST}
        SOUTH {LEFT EAST RIGHT WEST}
        EAST {LEFT NORTH RIGHT SOUTH}
        WEST {LEFT SOUTH RIGHT NORTH}
      }
    }

    method Move {} {
      return {
        NORTH {x 0 y 1}
        SOUTH {x 0 y -1}
        EAST {x 1 y 0}
        WEST {x -1 y 0}
      }
    }
}

proc processInput {stream} {
    set robot [Robot new]

    while { [gets $stream line] >= 0 && $line != "EXIT" } {
        $robot exec {*}$line
    }
}

proc main {args} {
    set stream stdin

    if { [llength {*}$args] > 0 } {
        set fileName [lindex {*}$args 0]
        set stream [open $fileName r]
    }

    processInput $stream
    close $stream
}
