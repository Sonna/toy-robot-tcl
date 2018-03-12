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
}
