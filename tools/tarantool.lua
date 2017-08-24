box.cfg{listen=3301}

box.once('hello', function() 
	box.schema.space.create('examples',{id=999})
	box.space.examples:create_index('primary', {type = 'hash', parts = {1, 'unsigned'}})
	box.schema.user.create('awesomeuser', {password = '123456'})
	box.schema.user.grant('guest','read,write','space','examples')
	box.schema.user.grant('guest','read','space','_space')
	box.space.examples:insert{41, "a"}
	box.space.examples:insert{42, "b"}
end)
require('console'):start()
