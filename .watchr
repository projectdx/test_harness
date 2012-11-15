if __FILE__ == $0
  puts "Run with: watchr #{__FILE__}. \n\nRequired gems: watchr rev"
  exit 1
end

# --------------------------------------------------
# Convenience Methods
# --------------------------------------------------
def run(cmd)
  sleep(2)
  puts("%s %s [%s]" % ["|\n" * 5 , cmd , Time.now.to_s])
  $last_test = cmd
  system(cmd)
end

def run_all_specs
  run "bundle exec rake -s spec SPEC_OPTS='--order rand'"
end

def run_last_test
  run($last_test)
end

def run_single_spec *spec
  spec = spec.join(' ')
  run "bundle exec rspec  #{spec} --order rand"
end

def run_specs_with_shared_examples(shared_example_filename, spec_path = 'spec')

  # Returns the names of the shared examples in filename
  def shared_examples(filename)
    lines = File.readlines(filename)
    lines.grep(/shared_examples_for[\s'"]+(.+)['"]\s*[do|\{]/) do |matching_line|
      $1
    end
  end

  # Returns array with filenames of the specs using shared_example
  def specs_with_shared_example(shared_example, path)
    command = "grep -lrE 'it_should_behave_like .(#{shared_example}).' #{path}"
    `#{command}`.split
  end

  shared_examples(shared_example_filename).each do |shared_example|
    specs_to_run = specs_with_shared_example(shared_example, spec_path)
    run_single_spec(specs_to_run) unless specs_to_run.empty?
  end

end

def run_cucumber_scenario scenario_path
  if scenario_path !~ /.*\.feature$/
    scenario_path = $last_scenario
  end
  $last_scenario = scenario_path
  run "bundle exec cucumber #{scenario_path} --tags @dev"
end

# --------------------------------------------------
# Watchr Rules
# --------------------------------------------------
watch( '^spec/spec_helper\.rb'                    ) {     run_all_specs }
watch( '^spec/shared_behaviors/.*\.rb'            ) { |m| run_specs_with_shared_examples(m[0]) }
watch( '^spec/.*_spec\.rb'                        ) { |m| run_single_spec(m[0]) }
watch( '^app/lib/.*'                        ) { |m| run_last_test }
watch( '^spec/factories.*'                        ) { |m| run_last_test }
watch( '^test_harness/.*'                        ) { |m| run_last_test }
watch( '^app/(.*)\.rb'                            ) { |m| run_single_spec("spec/%s_spec.rb" % m[1]) }
watch( '^app/views/(.*)\.haml'                    ) { |m| run_single_spec("spec/views/%s.haml_spec.rb" % m[1]) }
watch( '^lib/(.*)\.rb'                            ) { |m| run_single_spec("spec/other/%s_spec.rb" % m[1] ) }
watch( '^features/*/.*'                           ) { |m| run_cucumber_scenario(m[0]) }
watch( '^test_harness/*/.*'                       ) { |m| run_cucumber_scenario(m[0]) }


# --------------------------------------------------
# Signal Handling
# --------------------------------------------------
# Ctrl-\
Signal.trap('QUIT') do
  puts " --- Running all tests ---\n\n"
  run_all_specs
end

# Ctrl-T
Signal.trap('TSTP') do
  puts " --- Running last test --\n\n"
  run_cucumber_scenario nil
end

# Ctrl-C
Signal.trap('INT') { abort("\n") }

puts "Watching.." 
