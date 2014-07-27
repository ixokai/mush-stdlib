# -----------------------------------------------------------------------------
# dict.mu
# -----------------------------------------------------------------------------
# 
# These functions are used to define a common key->value data structure
# to be used by larger systems. The basic format of the structure is:
#
#    key1->value1^key2->value2
# 
# Keys are unsorted, lower case, and can contain any characters besides
# "->" and "^". 
#
# Dictionaries are defined as object/attribute pairs. The object can be
# either a regular object's dbref, a cluster's dbref, or a #lambda --
# this is useful in caching attribute access when fetching numerous keys
# from the same dictionary.
#
# Generally speaking, dictionary keys should not begin with an underscore.
# These are considered 'internal' keys and are used to implement 
# advanced features
#
# Dictionaries support inheritance. If you use dict-fetch instead of
# dict-get, and if the dictionary has an '_inherits' key, it will attempt
# to get the key from the 'parent' chain if it doesn't exist in the 
# specified dictionary.
#
# -----------------------------------------------------------------------------

# dict-get(object/attribute,key) --> value
#   returns the value for the key, from the object/attribute dictionary. 
&API_DICT-GET #stdlib=
    @function/notrace DICT-GET=#stdlib/FN_DICT-GET

&FN_DICT-GET #stdlib=
    after(grab(aget(%0),%1->*,^),->)
    
    
# dict-set(object/attribute,key,value) --> dictionary
#   returns the specified dictionary with the key set to the value.
#   This is not a side effect! You must set the attribute. This is 
#   generally used as:
#       &attribute object=[dict-set(object/attribute,key,value)]
&API_DICT-SET #stdlib=
    @function/preserve/notrace DICT-SET=#stdlib/FN_DICT-SET

&FN_DICT-SET #stdlib=
    listunion(
        remove(
            setr(A,aget(%0)),
            grab(%qA,%1->*,^),
            ^
        ),
        %1->%2,
        ^
    )

    
# dict-keys(object/attribute) --> ^-list
#   returns a ^-delimited list of keys in the dictionary
&API_DICT-KEYS #stdlib=
    @function/notrace DICT-KEYS=#stdlib/FN_DICT-KEYS

&FN_DICT-KEYS #stdlib=iter(aget(%0),before(%i0,->),^,^)


# dict-del(object/attribute,key) --> dictionary
#   returns the specified dictionary with the key (and its value)
#   removed. Not a side-effect!
&API_DICT-DEL #stdlib=
    @function/preserve/notrace DICT-DEL=#stdlib/FN_DICT-DEL

&FN_DICT-DEL #stdlib=
    remove(
        setr(A,aget(%0)),
        grab(%qA,%1->*,^),
        ^
    )
    
# dict-fetch(object/attribute,key) --> value
#   This is like dict-get, but follows '_inherits' chains to find a value.
#   The _inherits key should be set to '#object/attribute' specifying 
#   another dictionary.
&API_DICT-FETCH #stdlib=
    @function/preserve DICT-FETCH=#stdlib/FN_DICT-FETCH

&FN_DICT-FETCH #stdlib=
    default(#lambda/[dict-get(%0,%1)],
        dict-get(dict-get(%0,_inherits),%1))

# dict-update(object/attribute,dictionary) --> dictionary
#   accepts a dictionary as an object/attribute pair, and a second dictionary
#   returns a combination of the two dictionaries with keys in the second
#   updating the dictionary in the first.
&API_DICT-UPDATE #stdlib=
    @function/preserve dict-update=#stdlib/FN_DICT-UPDATE

&FN_DICT-UPDATE #stdlib=
    [defq(existing,)]
    [iter(
        aget(%0),
            [setq(2,1)]
            [setq(1,before(%i0,->))]
            [ifelse(
                !!$setr(0,dict-get(#lambda/%1,%q1)),
                %q1->%q0,
                %i0
            )]
            [setq(4,
                setunion(%q4,%q1,^,^)
            )],
        ^,^
    )]
    [iter(
        setdiff(
            dict-keys(#lambda/%1),%q4,^,^
        ),
            [if(%q2,^)]
            [setq(2,)]%i0->[dict-get(#lambda/%1,%i0)],
        ^,^
    )]
        
        
# safe-dict(string) --> string
#   returns string sanitized to be a key or a value in a dictionary 
&API_SAFE-DICT #stdlib=
    @function/notrace safe-dict=#stdlib/FN_SAFE-DICT

&FN_SAFE-DICT Standard Library; stdlib=pedit(%0,->,,^,)

