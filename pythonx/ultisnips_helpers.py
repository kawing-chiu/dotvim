"""Helper functions for ultisnips"""

def get_indent(snip, shift=1):
    old = snip.rv
    snip.rv += "\n"
    snip.shift(shift)
    indent = snip.mkline()                
    snip.rv = old                         
    return indent                         

def refresh(snip):
    snip.rv += ""                         

def add_str(snip, string):
    snip.rv += string

def add_str_if(snip, cond, string):
    if cond:
        snip.rv += string
    refresh(snip)

def add_newline_if_not_beginswith(snip, tabstop, indent):
    if tabstop:                        
        if not tabstop.startswith("\n"): 
            snip.rv += "\n" + indent          
                                        

