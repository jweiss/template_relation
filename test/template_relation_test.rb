require File.dirname(__FILE__) + '/helper'
 
describe "TemplateRelation" do
  
  before(:all) do
    init_models
  end
  
  before(:each) do
    @sample = Sample.new
  end

  it "should have an images association" do
    @sample.should respond_to(:images)
  end
  
  it "should validate the assoc" do
    @sample.save.should equal(false)
    @sample.errors.on("images").should_not be_nil
    
    3.times do |i|
      img = Image.new(:name => "image #{i}")
      @sample.images << img
    end
    
    @sample.save.should equal(false)
    @sample.errors.on("images").should_not be_nil
    
    2.times do |i|
      img = Image.new(:name => "image #{i}")
      @sample.images << img
    end
    
    @sample.save!
    @sample.save.should equal(true)
        
  end
  
  
  describe "valid relation" do
    
    before(:each) do
      @sample = Sample.new
      create_images
    end
  
    it "should define getter methods" do
      5.times do |i|
        @sample.should respond_to("image_#{i+1}".to_sym)
        @sample.send("image_#{i+1}".to_sym).should equal(@sample.images[i])
      end  
    end
    
    it "should define setter methods" do
      5.times do |i|
        @sample.should respond_to("image_#{i+1}=".to_sym)
      end
    end
    
    it "should have working setter methods" do
      img = Image.new(:name => "foo")
      
      old_img = @sample.image_3
      @sample.image_3 = img
      @sample.save!
      @sample.reload
      
      img.reload
      img.sample.id.should equal(@sample.id)
      
      @sample.images.size.should equal(5)
      
      lambda{
        old_img.reload
      }.should raise_error(ActiveRecord::RecordNotFound)
    end
    
    it "should use setters to update same object" do
      img = Image.new(:name => "foo")
      
      img = @sample.image_3
      img.name = "FooMe"
      @sample.image_3 = img
      @sample.save!
      @sample.image_3.save!
      @sample.reload
      
      img.reload
      img.sample.id.should == @sample.id
      
      @sample.images.size.should == 5
      @sample.image_3.name.should == "FooMe"
    end
    
    it "should allow nested hash updates through setters" do
      @sample.update_attributes(:image_3 => {:name => 'BarMe'}).should == true
      @sample.reload
      @sample.image_3.name.should == 'BarMe'
    end

  end
  
  def create_images
    5.times do |i|
      img = Image.new(:name => "image #{i+1}")
      @sample.images << img
    end
    @sample.save!
    @sample = Sample.find(@sample.id)
  end
 
end