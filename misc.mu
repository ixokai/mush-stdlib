# -----------------------------------------------------------------------------
# misc.mu
# -----------------------------------------------------------------------------
# 
# This is a mix of helper, convenience and functions that a game will want to
# override to match up with their setup.
#
# For example, the "game-isstaff" function is something every game will want
# to override depending on the game's staffers are determined.
#
# ----------------------------------------------------------------------------- 

# addq(register,value) --> nil
#   adds value to the current value in register, then sets that register with the
#   new value.
&API_ADDQ #stdlib=
    @function/notrace addq=#stdlib/FN_ADDQ

&FN_ADDQ #stdlib=letq(%0,add(r(%0),%1))


# appendq(register,content) --> nil
#   sets the register to the current value of the register followed by the value
&API_APPENDQ #stdlib=
    @function/notrace appendq=#stdlib/FN_APPENDQ

&FN_APPENDQ #stdlib=letq(%0,[r(%0)]%1)


# defq(name, value) --> nil
#   Like setq(), but uses the next available register and associates it with name
&API_DEFQ #stdlib=
    @function defq=#stdlib/FN_DEFQ

&FN_DEFQ #stdlib=setq(+,%1,%0)


# defr(name, value) --> value
#   Like setr(), but uses the next available register and associates it with name
&API_DEFR #stdlib=
    @function DEFR=#stdlib/FN_DEFR

&FN_DEFR #stdlib=setr(+,%1,%0)


# safe-attr(string) --> cleaned string
#   returns string after having sanitized it for use as an attribute name
&API_SAFE-ATTR #stdlib=
    @function/notrace safe-attr=#stdlib/FN_SAFE-ATTR

&FN_SAFE-ATTR #stdlib=edit(secure(trim(%0)),%b,_)

# game-isstaff(dbref) --> bool
#   returns 1 if the specified player is staff, otherwise 0
&API_GAME-ISSTAFF #stdlib=
    @function/notrace game-isstaff=#stdlib/FN_GAME-ISSTAFF
&FN_GAME-ISSTAFF #stdlib=hasflag(%0,staff)

# game-position(dbref) --> value
#   returns the given dbref player's position in the game
&API_GAME-POSITION #stdlib=
    @function/privileged/notrace game-position=#stdlib/FN_GAME-POSITION

&FN_GAME-POSITION #stdlib=xget(%0,game_position)

# aget(object/attribute) --> value
#   like get(), but checks if object is a cluster, and if so uses
#   cluster_get instead.
&API_AGET #stdlib=
    @function AGET=#stdlib/FN_AGET

&FN_AGET #stdlib=ifelse(iscluster(%0),cluster_get(%0),get(%0))
