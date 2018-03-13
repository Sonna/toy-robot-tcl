# package require TclOO;

oo::class create Robot {
    variable TURN
    variable x
    variable y
    variable facing

    constructor {{dx 0} {dy 0} {dfacing "NORTH"}} {
        set TURN {
          NORTH {LEFT WEST RIGHT EAST}
          SOUTH {LEFT EAST RIGHT WEST}
          EAST {LEFT NORTH RIGHT SOUTH}
          WEST {LEFT SOUTH RIGHT NORTH}
        }
        set x $dx
        set y $dy
        set facing $dfacing
    }

    method getX {} { return $x }
    method getY {} { return $y }
    method getFacing {} { return $facing }

    method report {} {
      puts "$x,$y,$facing"
    }

    method left {} {
      set facing [dict get $TURN $facing LEFT]
    }

    method right {} {
      set facing [dict get $TURN $facing RIGHT]
    }
}
