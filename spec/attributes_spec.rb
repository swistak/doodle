require File.dirname(__FILE__) + '/spec_helper.rb'

describe Doodle::Attribute, 'basics' do
  temporary_constants :Foo, :Bar do
    before(:each) do
      class Foo
        include Doodle::Core
        has :ivar1, :default => 'Hello'
        class << self
          has :cvar1
        end
      end
      class Bar < Foo
        has :ivar2
        class << self
          has :cvar2
        end
      end
    
      @foo = Foo.new
      class << @foo
        has :svar1
      end
      @bar = Bar.new :ivar2 => 'Hi'
      class << @bar
        has :svar2
      end
    end

    after :each do
      @bar = nil
      @foo = nil
    end
    
    it 'should have attribute :ivar1 with default defined' do
      @foo.attributes[:ivar1].default.should == 'Hello'
    end

    it 'should have default name' do
      @foo.ivar1.should == 'Hello'
    end

    it 'should not have an instance variable for a default' do
      @foo.instance_variables.include?('@name').should == false
    end

    it 'should have name required == false (because has default)' do
      @foo.attributes[:ivar1].required?.should == false
    end

    it 'should have ivar2 required == true' do
      @bar.attributes[:ivar2].required?.should == true
    end

    it 'should have name.optional? == true (because has default)' do
      @foo.attributes[:ivar1].optional?.should == true
    end

    it 'should inherit attribute from parent' do
      @bar.attributes[:ivar1].should == @foo.attributes[:ivar1]
    end

    it 'should have ivar2.optional? == false' do
      @bar.attributes[:ivar2].optional?.should == false
    end

    it "should have parents in correct order" do
      Bar.parents.should == [Foo, Object]
    end
    
    it "should have Bar's singleton parents in reverse order of definition" do
      @bar.singleton_class.parents.should == []
    end

    it 'should have singleton_class attributes in order of definition' do
      Bar.singleton_class.attributes.keys.should == [:cvar2]
    end

    it 'should have inherited class_attributes in order of definition' do
      Bar.class_attributes.keys.should == [:cvar1, :cvar2]
    end

    it 'should have inherited class_attributes in order of definition' do
      @bar.class_attributes.keys.should == [:cvar1, :cvar2]
    end
    
    it 'should have local class attributes in order of definition' do
      Bar.singleton_class.attributes(false).keys.should == [:cvar2]
    end

    it 'should not inherit singleton local_attributes' do
      @bar.singleton_class.class_eval { collect_inherited(:local_attributes).map { |x| x[0]} }.should == []
    end

    it 'should not inherit singleton attributes#1' do
      @bar.singleton_class.attributes.map { |x| x[0]} .should == [:svar2]
    end
    
    it 'should not inherit singleton attributes#2' do
      @bar.singleton_class.attributes.keys.should == [:svar2]
    end

    it 'should not inherit singleton attributes#3' do
      @bar.singleton_class.attributes(false).keys.should == [:svar2]
    end

    it 'should show singleton attributes in attributes' do
      @bar.attributes.keys.should == [:ivar1, :ivar2, :svar2]
    end

  end
end

describe Doodle::Attribute, 'attribute order' do
  temporary_constants :A, :B, :C do
    before :each do
      class A < Doodle
        has :a
      end

      class B < A
        has :b
      end

      class C < B
        has :c
      end
    end
  
    it 'should keep order of inherited attributes' do
      C.parents.should == [B, A, Doodle, Object]
    end

    it 'should keep order of inherited attributes' do
      C.attributes.keys.should == [:a, :b, :c]
    end
  end
end
