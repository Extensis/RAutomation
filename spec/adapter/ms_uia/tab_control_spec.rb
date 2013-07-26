require 'spec_helper'

include RAutomation::Adapter

describe MsUia::TabControl do
  let(:window) { RAutomation::Window.new(:title => 'MainFormWindow', :adapter => :ms_uia) }
  let(:about) { RAutomation::Window.new(:title => 'About', :adapter => :ms_uia) }
  subject { about.tab_control(:id => 'tabControl') }

  before(:each) do
    window.button(:value => 'About').click { true }
  end

  it { should exist }

  it 'has tab items' do
    subject.items.count.should eq(2)
  end

  it 'knows the current tab' do
    subject.value.should eq('Info')
  end

  context('#items') do
    it 'has text' do
      subject.items.map(&:text).should eq(['Info', 'More Info'])
    end

    it 'has indices' do
      subject.items.map(&:index).should eq([0, 1])
    end

    it 'can be selected' do
      subject.items.find {|t| t.text == 'More Info'}.select
      subject.value.should eq('More Info')
    end

    it 'knows if it is selected' do
      subject.items.first.should be_selected
      subject.items.last.should_not be_selected
    end
  end
end
