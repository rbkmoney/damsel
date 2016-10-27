# Damsel

[![Build Status](http://ci.rbkmoney.com/buildStatus/icon?job=rbkmoney_private/damsel/master)](http://ci.rbkmoney.com/job/rbkmoney_private/job/damsel/job/master/)

Systemwide protocol collection.


# Требования к оформлению Thrift IDL файлов

- __Namespace:__ 

	В каждом файле нужно __обязательно__ указывать `namespace` для __JAVA__:
		
		namespace java com.rbkmoney.damsel.<name>
			
	Где `<name>` - имя, уникальное для Thrift IDL файлa в Damsel.
		

