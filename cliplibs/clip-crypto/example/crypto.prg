
msg:='Hello, World!'
key='asdf'

? evp_alg_list()
?

msg1:=evp_encrypt(msg, key)
msg2:=evp_decrypt(msg1, key)

? 'source   : "', msg, '"'
? 'encrypted: "', msg1, '"'
? 'decrypted: "', msg2, '"'
?
