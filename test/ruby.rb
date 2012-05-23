#!/usr/bin/ruby
# Test file for Ruby line counter
# 13 sloc total
	   
  # Color map
COLORS = { :black   => "000",
           :red     => "f00",
           :green   => "0f0",
           :yellow  => "ff0",
           :blue    => "00f",
           :white   => "fff" }
  
=begin
This is a multi-line comment.
Ruby ignores anything between "=begin" and "=end" tokens
These tokens should appear alone at the start of the line
=end

class String
    COLORS.each do |color,code|
        define_method "in_#{color}" do
            "<span style=\"color: ##{code}\">#{self}</span>"
        end
    end
end
