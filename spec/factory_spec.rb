require File.dirname(__FILE__) + '/spec_helper.rb'

describe Doodle::Factory, " as part of Doodle::Base" do
  temporary_constant :Foo, :Bar do
    before(:each) do
      class Foo < Doodle::Base
        has :var1
      end
      class Bar < Foo
        has :var2
      end
    end

    it 'should provide factory function' do
      proc {
        foo = Foo("abcd") 
        foo.var1.should == "abcd"
        }.should_not raise_error
    end

    it 'should inherit factory function' do
      proc {
        bar = Bar("abcd", 1234) 
        bar.var1.should == "abcd"
        bar.var2.should == 1234
        }.should_not raise_error
    end
  end
end

describe Doodle::Factory, " included as module" do
  temporary_constant :Baz, :Qux, :MyDate do
    before(:each) do
      class Baz
        include Doodle::Helper
        include Doodle::Factory
        has :var1
      end
      class Qux < Baz
        has :var2
      end
      class MyDate < Date
        include Doodle::Factory
      end
    end

    it 'should provde factory function' do
      proc {
        foo = Baz("abcd") 
        foo.var1.should == "abcd"
        }.should_not raise_error
    end

    it 'should inherit factory function' do
      proc {
        qux = Qux("abcd", 1234) 
        qux.var1.should == "abcd"
        qux.var2.should == 1234
        }.should_not raise_error
    end

    it 'should be includeable in non-doodle classes' do
      proc {
        qux = MyDate(2008, 01, 01) 
        qux.to_s.should == "2008-01-01" 
        }.should_not raise_error
    end

  end
end

