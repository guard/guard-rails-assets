require 'guard'
require 'guard/guard'

module Guard
  class RailsAssets < Guard
    def initialize(watchers=[], options={})
      super
      @options = options || {}
      @options[:assets_prefix] ||= 'assets'
    end

    def start
      compile_assets if run_for? :start
    end

    def reload
      compile_assets if run_for? :reload
    end

    def run_all
      compile_assets if run_for? :all
    end

    def run_on_change(paths=[])
      compile_assets if run_for? :change
    end

    def compile_assets
      puts 'Compiling rails assets'
      result = system "rm -rf #{assets_dir} && bundle exec rake assets:precompile"
      if result
        Notifier::notify success_summary, :title => 'Assets compiled'
      else
        Notifier::notify 'see the details in the terminal', :title => "Can't compile assets", :image => :failed
      end
    end

    private

    def assets_dir
      @assets_dir ||= "public/#{@options[:assets_prefix]}"
    end

    def run_for? command
      run_on = @options[:run_on]
      run_on = [:start, :all, :change] if not run_on or run_on.empty? 
      run_on = [run_on] unless run_on.respond_to?(:include?)
      run_on.include?(command)
    end

    def success_summary
      if system_has_tree?
        tree = `tree #{assets_dir}`
        puts tree
        tree.split("\n").last
      else
        '(Install tree for additional information)'
      end
    end

    def system_has_tree?
      return @has_tree if instance_variable_defined?(:@has_tree)
      @has_tree = system "which tree"
    end
  end
end
