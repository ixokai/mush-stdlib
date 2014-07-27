# -----------------------------------------------------------------------------
# interface.mu
# -----------------------------------------------------------------------------
# 
# These functions are used by all my code to provide a common look and feel,
# but are isolated here so they can be easily overridden to match the style
# of other games.
#
# The three major functions are "ui-header", "ui-section", and "ui-footer". 
# These create the frame that all the systems display their interface, with
# the header being the top line and footer being the bottom. Section headers
# are used (sparingly) to provide vertical separation.
#
# These functions all take 0-N arguments, the first of which, if present, 
# will be highlighted and left aligned, while all other arguments are right
# aligned. Arguments can be in the form of x=y.
#
# These functions do not output any %r's.
#
# The other functions here, ui-succ, ui-fail, ui-info and ui-verify are used
# for anti-spoofing protection.
#
# -----------------------------------------------------------------------------


&UFUN_UI_ITEM #stdlib=
    switch(%0,
        *=*,
            [ansi(c,before(%0,=),hx,=,hc,after(%0,=))],
        [ansi(ifelse(t(%1),%1,hc),%0)]
    )

@set #stdlib/UFUN_UI_ITEM = visual

&UFUN_GATHER_UI_ITEMS #stdlib=iter(%0,u(#stdlib/UFUN_UI_ITEM,%i0),^,%b%b%b)

@set #stdlib/UFUN_GATHER_UI_ITEMS=visual


# ui-header(...) --> header
#   a 78 character top header line
&API_UI-HEADER #stdlib=
    @function/preserve/protect/notrace UI-HEADER=#stdlib/FN_UI-HEADER

&FN_UI-HEADER #stdlib=
    [ansi(c,%[)]%b
    [setq(L,)][setq(R,)]
    [case(1,
        and(eq(%+,1),not(v(0))), #// no arguments
            space(74),
        eq(%+,1), #// only one argument
            [setr(I,u(#stdlib/UFUN_UI_ITEM,%0))]
            [space(sub(74,strlenvis(%qI)))],
        #// otherwise
            [if(t(v(0)),
                [setr(I,u(#stdlib/UFUN_UI_ITEM,%0))]
                [setq(L,strlenvis(%qI))]
            )] 
            [setq(O,
                u(#stdlib/UFUN_GATHER_UI_ITEMS,
                    iter(lnum(1,sub(%+,1)),v(%i0),%b,^)
                )
            )]
            [space(
                sub(74,add(%qL,strlenvis(%qO)))
            )]%qO
        )]
    %b[ansi(c,%])]

    
# ui-footer(...) --> footer
#   a 78 character bottom footer line
&API_UI-FOOTER #stdlib=
    @function/preserve/protect/notrace UI-FOOTER=#stdlib/FN_UI-FOOTER

@cpattr #stdlib/FN_UI-HEADER=#stdlib/FN_UI-FOOTER


# ui-section(...) --> section header
#   a 78 character middle section header
&API_UI-SECTION #stdlib=
    @function/preserve/protect/notrace UI-SECTION=#stdlib/FN_UI-SECTION
    
@cpattr #stdlib/FN_UI-HEADER=#stdlib/FN_UI-SECTION

    
# ui-verify(person,class) --> verifiable status code
#   returns a status code based on the specified class (either SUCC, FAIL or 
#   INFO), along with the person's &verify code.
&API_FN_UI-VERIFY #stdlib=
    @function/preserve/notrace UI-VERIFY=#stdlib/FN_UI-VERIFY;
    @function/min UI-VERIFY=2;
    @function/max UI-VERIFY=2

&FN_UI-VERIFY #stdlib=
    [switch(%1,
        s*,
            ansi(h[setr(c,g)],SUCC),
        f*,
            ansi(h[setr(c,r)],FAIL),
        i*,
            ansi(h[setr(c,y)],INFO),
        
            ansi(h[setr(c,w)],[rjc(ucstr(%1),4)])
    )]
    [ansi(%qc,%()][default(%0/verify,&VERIFY)][ansi(%qc,%))]:
    
 
# ui-succ(person,message) --> verifiable message
#   convenience function to use ui-verify to send a success message for player
&API_UI-SUCC #stdlib=
    @function/notrace UI-SUCC=#stdlib/FN_UI-SUCC

&FN_UI-SUCC #stdlib=[ui-verify(%0,s)] %1


# ui-fail(person,message) --> verifiable message
#   convenience function to use ui-verify to send a failure message for player
&API_UI-FAIL #stdlib=@function/notrace UI-FAIL=#stdlib/FN_UI-FAIL

&FN_UI-FAIL #stdlib=[ui-verify(%0,f)] %1


# ui-succ(person,message) --> verifiable message
#   convenience function to use ui-verify to send a informational message for
#   player
&API_UI-INFO #stdlib=@function/notrace UI-INFO=#stdlib/FN_UI-INFO

&FN_UI-INFO #stdlib=[ui-verify(%0,i)] %1

