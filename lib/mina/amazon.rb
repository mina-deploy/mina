# a utility module for querying Amazon Web Services for a server with a specific role
require 'json'
require 'aws-sdk'

module Amazon
    @loaded = false
    def self.hosts_by_role( role, keysFile )
        @keysFile = keysFile
        load_keys
        puts "looking for hosts with role: #{role}..."
        relevant = AWS.ec2.instances.select do |instance|
            has_role( instance, role )
        end

        result = relevant.map { |instance| instance.dns_name }
        result
    end

private

    def self.has_role( instance, role )
        instance.tags['role'] && instance.tags['role'].split(',').include?( role )
    end

    def self.load_keys
        return if @loaded
        aws_keys = JSON.parse( IO.read( @keysFile ) )
        AWS.config(access_key_id: aws_keys['AWSAccessKeyId'], secret_access_key: aws_keys['AWSSecretKey'], region: 'us-west-2')
        @loaded = true
    end
end

desc "list hosts on amazon with specified role"
task :"amazon:list_hosts", [ :role ] do |task, args|
    result = Amazon.hosts_by_role( args[ :role ], amazon_keys_file! )
    puts "#{role} hosts: #{result.join( ' ' )}"
end
