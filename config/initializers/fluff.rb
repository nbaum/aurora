# Copyright (c) 2016 Nathan Baum

Rack::Server.middleware["development"].delete([Rack::Lint])
