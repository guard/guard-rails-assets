require 'guard/compat/plugin'

module Guard
  class RailsAssets < Plugin
    def initialize(options = {})
      super
      @options = options || {}
      @run_on = @options[:run_on] || [:start, :change]
      @run_on = [@run_on] unless @run_on.respond_to?(:include?)
    end

    def start
      runner.start if runner.respond_to? :start
      compile_assets if run_for? :start
    end

    def reload
      runner.reload if runner.respond_to? :reload
      compile_assets if run_for? :reload
    end

    def run_all
      compile_assets if run_for? :all
    end

    def run_on_change(_paths = [])
      compile_assets if run_for? :change
    end

    def compile_assets
      puts "Compiling rails assets with #{runner.class.name}."
      result = runner.compile_assets

      if result
        Compat::UI.notify 'Assets compiled'
        puts 'Assets compiled.'
      else
        Compat::UI.notify 'see the details in the terminal', title: "Can't compile assets", image: :failed
        puts 'Failed to compile assets.'
      end
    end

    def runner
      @runner ||= begin
        runner_name = (@options[:runner] || :rails).to_s

        require "guard/rails-assets/#{runner_name}_runner"
        ::Guard::RailsAssets.const_get(runner_name.capitalize + 'Runner').new(@options)
      end
    end

    def run_for?(command)
      @run_on.include?(command)
    end

    def self.template(plugin_location)
      File.read(template_path(plugin_location))
    end

    def self.template_path(plugin_location)
      # workaround because Guard discards the '-' when detecting template path
      File.join(plugin_location, 'lib', 'guard', 'rails-assets', 'templates', 'Guardfile')
    end
  end
end
