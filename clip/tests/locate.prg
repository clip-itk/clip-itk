use test
goto 5
* rddlocate rest for "i"$field->last next 10
rddlocate for "i"$field->last
while found()
*for i=1 to 1
   ? found(), recno(), last
   rddcontinue
* enddo
end
?
rddlocate rest for "a"$field->last next 5
while found()
   ? found(), recno(), last
   rddcontinue
enddo
?

