//clear screen
for i=0 to 15
	for j=3 to 15
        	ch=j*16+i
		if  ch<96
			?? str(ch,2)+' '+chr(ch)+' '
		elseif ch==127
			?? str(ch,3)+' '+' '+' '
		else
	        	?? str(ch,3)+' '+chr(ch)+' '
		end
     	next
        ?
next
