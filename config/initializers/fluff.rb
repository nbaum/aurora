# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

Rack::Server.middleware["development"].delete([Rack::Lint])
