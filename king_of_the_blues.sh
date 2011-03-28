#!/bin/sh -x

rvm use 1.9.2
/usr/bin/env ruby ~/bin/king_of_the_blues.rb > ~/Desktop/king_of_the_blues.rb.out 2>&1
