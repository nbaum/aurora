t = Tariff.create! name: "Free", core: 0, memory: 0, storage: 0, address: 0
Tariff.create! name: "Default", core: 1, memory: 1, storage: 1, address: 1, default: true

z = Zone.create! name: "Localzone", dns1: "8.8.8.8", dns2: "8.8.4.4"

a = Account.create! name: "Orbital Informatics", balance: 0.0, tariff: t, zone: z

User.create! name: "Nathan Baum", email: "nathan@orbitalinformatics.co.uk", account: a, administrator: true

h = Host.create! name: "Localhost", url: "http://localhost:9000/", address: "127.0.0.1", zone: z, compute: true, storage: true

n = Network.create! name: "Internet", bridge: "br0", prefix: 24, gateway: "192.168.1.254", first: "192.168.1.100", last: "192.168.1.200", zone: z
Network.create! name: "Private", bridge: "br0", prefix: 24, gateway: "192.168.2.254", first: "192.168.2.100", last: "192.168.2.200", account: a, zone: z

lb = Appliance.create! name: "Load Balancer", internal_class: "LoadBalancer"
vg = Appliance.create! name: "VPN Gateway", internal_class: "VPNGateway"

StoragePool.create! name: "Standard", size: 2000, host: h
StoragePool.create! name: "ISO Images", size: nil, host: h

w = %w"account act addition adjustment advertisement agreement air amount amusement animal answer apparatus approval argument art attack attempt attention attraction authority back balance base behavior belief birth bit bite blood blow body brass bread breath brother building burn burst business butter canvas care cause chalk chance change cloth coal color comfort committee company comparison competition condition connection control cook copper copy cork cotton cough country cover crack credit crime crush cry current curve damage danger daughter day death debt decision degree design desire destruction detail development digestion direction discovery discussion disease disgust distance distribution division doubt drink driving dust earth edge education effect end error event example exchange existence expansion experience expert fact fall family father fear feeling fiction field fight fire flame flight flower fold food force form friend front fruit glass gold government grain grass grip group growth guide harbor harmony hate hearing heat help history hole hope hour humor ice idea impulse increase industry ink insect instrument insurance interest invention iron jelly join journey judge jump kick kiss knowledge land language laugh law lead learning leather letter level lift light limit linen liquid list look loss love machine man manager mark market mass meal measure meat meeting memory metal middle milk mind mine minute mist money month morning mother motion mountain move music name nation need news night noise note number observation offer oil operation opinion order organization ornament owner page pain paint paper part paste payment peace person place plant play pleasure point poison polish porter position powder power price print process produce profit property prose protest pull punishment purpose push quality question rain range rate ray reaction reading reason record regret relation religion representative request respect rest reward rhythm rice river road roll room rub rule run salt sand scale science sea seat secretary selection self sense servant sex shade shake shame shock side sign silk silver sister size sky sleep slip slope smash smell smile smoke sneeze snow soap society son song sort sound soup space stage start statement steam steel step stitch stone stop story stretch structure substance sugar suggestion summer support surprise swim system talk taste tax teaching tendency test theory thing thought thunder time tin top touch trade transport trick trouble turn twist unit use value verse vessel view voice walk war wash waste water wave wax way weather week weight wind wine winter woman wood wool word work wound writing year angle ant apple arch arm army baby bag ball band basin basket bath bed bee bell berry bird blade board boat bone book boot bottle box boy brain brake branch brick bridge brush bucket bulb button cake camera card cart carriage cat chain cheese chest chin church circle clock cloud coat collar comb cord cow cup curtain cushion dog door drain drawer dress drop ear egg engine eye face farm feather finger fish flag floor fly foot fork fowl frame garden girl glove goat gun hair hammer hand hat head heart hook horn horse hospital house island jewel kettle key knee knife knot leaf leg library line lip lock map match monkey moon mouth muscle nail neck needle nerve net nose nut office orange oven parcel pen pencil picture pig pin pipe plane plate plough pocket pot potato prison pump rail rat receipt ring rod roof root sail school scissors screw seed sheep shelf ship shirt shoe skin skirt snake sock spade sponge spoon spring square stamp star station stem stick stocking stomach store street sun table tail thread throat thumb ticket toe tongue tooth town train tray tree trousers umbrella wall watch wheel whip whistle window wing wire worm"

100.times do
  Transaction.create! amount: 50 - Random.rand * 100, description: w.sample, account: a
end

b = Bundle.create! name: "Number Warehouse", account: a

Server.create! name: "Web Server 1", bundle: b, account: a
Server.create! name: "Web Server 2", bundle: b, account: a
Server.create! name: "Load Balancer", bundle: b, appliance: lb, account: a
Server.create! name: "Database Master", bundle: b, account: a
Server.create! name: "Database Slave", bundle: b, account: a
Server.create! name: "SSH Gateway", bundle: b, appliance: vg, account: a

