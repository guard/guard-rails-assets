require 'spec_helper'
require 'guard/rails-assets'

describe Guard::RailsAssets do
  let(:options) { {} }
  subject { Guard::RailsAssets.new(['watchers'], options) }

  it 'should be able to create guard' do
    ::Guard::RailsAssets.new(['watchers'], {:options=>:here}).should_not be_nil
  end

  describe '#start' do
    it_behaves_like 'guard command', :command => :start,         :run => true
  end

  describe '#reload' do
    it_behaves_like 'guard command', :command => :reload,        :run => false
  end

  describe '#run_all' do
    it_behaves_like 'guard command', :command => :run_all,       :run => true
  end

  describe '#run_on_change' do
    it_behaves_like 'guard command', :command => :run_on_change, :run => true
  end

  def stub_system_with dir, result
    subject.should_receive(:system).with("rm -rf #{dir} && bundle exec rake assets:precompile").and_return result
  end

  describe 'asset compilation using CLI' do
    before(:each) do
      subject.stub(:system_has_tree?) { true }
    end

    it 'should notify on success' do
      stub_system_with 'public/assets', true
      subject.should_receive(:`).with('tree public/assets').and_return "a\nb\n1 directory, 2 files"
      Guard::Notifier.should_receive(:notify).with('1 directory, 2 files', :title => 'Assets compiled')
      subject.compile_assets
    end
    it 'should notify on failure' do
      stub_system_with 'public/assets', false
      subject.should_not_receive(:`) # don't obtain tree
      Guard::Notifier.should_receive(:notify).with('see the details in the terminal', :title => "Can't compile assets", :image => :failed)
      subject.compile_assets
    end
  end

  describe 'custom assets prefix' do
    before(:each) do
      options[:assets_prefix] = 'my/assets'
      subject.stub(:system_has_tree?) { true }
    end

    it 'should use given prefix for cleanup and compilation' do
      stub_system_with 'public/my/assets', true
      subject.should_receive(:`).with('tree public/my/assets').and_return "a\nb\n1 directory, 2 files"
      Guard::Notifier.should_receive(:notify).with('1 directory, 2 files', :title => 'Assets compiled')
      subject.compile_assets
    end
  end

  describe 'a system without the tree command' do
    before(:each) do
      subject.should_receive(:system_has_tree?).and_return false
    end

    it 'should still be able to generate assets' do
      stub_system_with 'public/assets', true
      subject.should_not_receive(:`)
      Guard::Notifier.should_receive(:notify).with('(Install tree for additional information)', :title => 'Assets compiled')
      subject.compile_assets
    end
  end
end
