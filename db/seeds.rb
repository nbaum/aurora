# Copyright (c) 2016 Nathan Baum

Tariff.transaction do

	t = Tariff.create! name: "Free", core: 0, memory: 0, storage: 0, address: 0
	Tariff.create! name: "Default", core: 1, memory: 1, storage: 1, address: 1, default: true

	z = Zone.create! name: "Localzone", dns1: "8.8.8.8", dns2: "8.8.4.4"

	a = Account.create! name: "Orbital Informatics", balance: 0.0, tariff: t, zone: z

	User.create! name: "Nathan Baum", email: "nathan@orbitalinformatics.co.uk", account: a, administrator: true

	h = Host.create! name: "Localhost", url: "http://localhost:9000/", address: "127.0.0.1", zone: z, has_compute: true, has_storage: true

	StoragePool.create! name: "Standard", size: 2000, host: h
	StoragePool.create! name: "ISO Images", size: nil, host: h

end
