require 'json'

def log(message)
  puts "======> #{message}"
end

desc '
Creates policy files from environment files.
Default option will create named policy files from every JSON file located under `test/environments`
Optionally, specify the path to a different location or specific environment file

Examples:

# Create policy files for each environment file located under `test/environments`
chef exec rake policyfiles_from_environment_files

# Create policy file for specific environment file
chef exec rake policyfiles_from_environment_files test/environments/env1.json

# Create policy files for all environment files under a path
chef exec rake policyfiles_from_environment_files some/other/path
'
task :policyfiles_from_environment_files do
  # grab the second arg from rake execution (will be path after task)
  #  or default to 'test/environments' directory
  env_file_path = ARGV[1] || 'test/environments'
  # If an arg was passed with json in the name for a specific file, use it
  #  otherwise append json matchers for glob
  if env_file_path !~ /\.json/
    env_file_path = "#{env_file_path}/**/*.json"
  end
  env_files = Dir.glob(env_file_path)

  # Read the default Policyfile from the cookbook to use as template
  raise 'Unable to read Policyfile.rb - does it exist?' unless ::File.exist?('Policyfile.rb')
  base_policyfile = ::File.read('Policyfile.rb')

  # Create policy files for each of the environments, using the base Policyfile.rb as a template.
  env_files.each do |env_file|
    env_data = JSON.parse(::File.read(env_file))
    env_name = env_data['name']
    policy_name = "policy_#{env_name}"
    policy_file = "#{policy_name}.rb"
    policy_attributes = {}
    (policy_attributes['default'] = env_data['default_attributes']) if env_data['default_attributes']
    (policy_attributes['override'] = env_data['override_attributes']) if env_data['override_attributes']
    log("Processing environment #{env_name} from #{env_file}")
    env_policyfile_content = base_policyfile.gsub(/^\s*\#.*/, '').gsub(/^$\n/, '')
    env_policyfile_content = env_policyfile_content.gsub(/^name.*/, "name '#{policy_name}'")
    ::File.write(policy_file, env_policyfile_content)
    log("Created #{policy_file}")
    next unless policy_attributes
    # Open in append mode to add content from environment data
    ::File.open(policy_file, 'a') do |f|
      f.puts '# attributes from environment file(s)'
      policy_attributes.each_key do |a|
        policy_attributes[a].each_key do |b|
          if policy_attributes[a][b].class == String
            f.write "#{a}['#{b}'] = '#{policy_attributes[a][b]}'\n"
          else
            f.write "#{a}['#{b}'] = #{policy_attributes[a][b]}\n"
          end
        end
      end
      f.close
    end
    log("Populated #{policy_file} with attributes from #{env_file}")
  end
end
