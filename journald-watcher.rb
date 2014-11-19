#!/usr/bin/env ruby

require 'daemons'

Daemons.run('journald-watcher-run.rb')
