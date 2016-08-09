module Mina
  module Backend
    class Remote
      attr_reader :commands
      include Configuration::DSL

      def initialize(commands)
        @commands = commands
      end

      def prepare
        if fetch(:simulate)
          [
            '#!/usr/bin/env bash', "# Executing the following via '#{ssh}':",
            '#', commands, ' '
          ].join("\n")
        else
          command = Shellwords.escape(commands)
          [ssh, '--', command].join(' ')
        end
      end

      def ssh
        ensure!(:domain)
        args = fetch(:domain)
        args = "#{fetch(:user)}@#{fetch(:domain)}" if set?(:user)
        args += " -i #{fetch(:identity_file)}" if set?(:identity_file)
        args += " -p #{fetch(:port)}" if set?(:port)
        args += ' -A' if set?(:forward_agent)
        args += " #{fetch(:ssh_options)}" if set?(:ssh_options)
        args += ' -tt'
        "ssh #{args}"
      end

    end
  end
end
