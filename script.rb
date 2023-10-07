#!/usr/bin/env ruby

# Define the command to run your Swift CLI tool
swift_cli_command = "sailor"  # Replace with the actual command name

# Define the arguments you want to pass to your Swift CLI tool
arguments = "--version"

# Run the Swift CLI tool with the specified arguments
output = `#{swift_cli_command} #{arguments}`

# Check if the command was successful (exit status 0)
if $?.exitstatus.zero?
  puts output
else
  puts "Failed to run 'sailor --version'"
  puts "Error output: #{output}"
end
