
b=10
e:=5
s:=-1
for i=b to e step s
	? 'for:', i
next

i:=0
j:=0
while .t.
	i++
	while .t.
        	j++
                ? i,j
                if j>3
                	exit
                end
        end
        ? "i=", i
        if i>4
        	exit
	end
end
