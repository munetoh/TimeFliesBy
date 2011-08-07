require 'spec_helper'

describe "tasks/index.html.erb" do
  before(:each) do
    assign(:tasks, [
      stub_model(Task, 
        :start => parse_us_date_time('3/1/2011 9:45:59'),
        :stop  => parse_us_date_time('3/1/2011 12:45'),
        :tags  => [
          stub_model(Tag, :name => 'Education'), 
          stub_model(Tag, :name => 'Read Book')
        ]
      ),
      stub_model(Task, 
        :start => parse_us_date_time('3/6/2011 7:45:59')
      ),
    ])
  end

  describe "#start" do
    it "shows nice format" do
      render
      rendered.should include('3/6/2011 07:45:59')
    end
  
    it "is in a Microformats hCalendar" do
      render
      assert_select '.vevent .dtstart', '3/6/2011 07:45:59'
    end
  
    it "has a Microformats hCalendar iso8601 title" do
      render
      assert_select '.vevent .dtstart .value-title' do |elements|
        elements.second['title'].should include('2011-03-06T07:45:59-06:00')
      end
    end
  end

  describe "#stop with value" do
    it "shows nice format" do
      render
      rendered.should include('3/1/2011 12:45:00')
    end
  
    it "is in a Microformats hCalendar" do
      render
      assert_select '.vevent .dtend', '3/1/2011 12:45:00'
    end
  
    it "has a Microformats hCalendar iso8601 title" do
      render
      assert_select '.vevent .dtend .value-title' do |elements|
        elements.first['title'].should include('2011-03-01T12:45:00-06:00')
      end
    end
  end
  
  describe "#stop being blank" do
    it "has 'Active' in Microformats hCalendar value" do
      render
      assert_select '.vevent .dtend', 'Active'
    end
  
    it "has no Microformats hCalendar iso8601 title value" do
      render
      assert_select '.vevent .dtend .value-title' do |elements|
        elements.second['title'].should_not include('T')
      end
    end
  end
  
  describe "#duration" do
    it "shows nice format" do
      render
      assert_select '.vevent .duration', '2h 59m 1s'
    end
  
    it "has a Microformats iso8601 title" do
      render
      assert_select '.vevent .duration .value-title' do |elements|
        elements[0]['title'].should include('PT2H59M1S')
      end
    end
  
  end
  
  describe "#tags" do
    it "shows tags" do
      render
      assert_select '.vevent [rel="tag"]' do |elements|
        elements[0].children.join(', ').should include('Education')
        elements[1].children.join(', ').should include('Read Book')
      end
    end
  end
  
end
