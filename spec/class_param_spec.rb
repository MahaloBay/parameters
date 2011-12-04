require 'parameters/class_param'

require 'spec_helper'
require 'classes/custom_type'
require 'set'

describe Parameters::ClassParam do
  describe "type coercion" do
    it "should coerce values into Hashes" do
      param = described_class.new(:x,Hash)

      param.value = 2
      param.value.should == {2 => true}
    end

    it "should coerce keys and values within Hashes" do
      param = described_class.new(:x,Hash[Symbol => Object])

      param.value = {'a' => true}
      param.value.should == {:a => true}
    end

    it "should coerce values into Sets" do
      param = described_class.new(:x,Set)

      param.value = [1, 2, 3, 2]
      param.value.should == Set[1, 2, 3]
    end

    it "should coerce values into Sets with types" do
      param = described_class.new(:x,Set[Integer])

      param.value = ['x', '0', '1', '2', '3']
      param.value.should == Set[0, 1, 2, 3]
    end

    it "should coerce values into Arrays" do
      param = described_class.new(:x,Array)

      param.value = Set[1, 2, 3]
      param.value.should == [1, 2, 3]
    end

    it "should coerce values into Arrays with types" do
      param = described_class.new(:x,Array[Integer])

      param.value = Set['1', '2', '3']
      param.value.should =~ [1, 2, 3]
    end

    it "should coerce values into URIs" do
      param = described_class.new(:x,URI)

      param.value = 'http://bla.com/'
      param.value.should == URI::HTTP.build(:host => 'bla.com')
    end

    it "should coerce values into Regexp" do
      param = described_class.new(:x,Regexp)

      param.value = 'x*'
      param.value.should == /x*/
    end

    it "should coerce values into Times" do
      param = described_class.new(:x,Time)

      param.value = '2011-12-03 19:39:09 -0800'
      param.value.should == Time.at(1322969949)
    end

    it "should coerce values into Dates" do
      param = described_class.new(:x,Date)

      param.value = '2010-02-18'
      param.value.should == Date.new(2010,2,18)
    end

    it "should coerce values into DateTimes" do
      param = described_class.new(:x,DateTime)

      param.value = '2010-02-18T00:36:31-08:00'
      param.value.should == DateTime.new(2010,2,18,0,36,31,Rational(-1,3),2299161)
    end

    it "should coerce values into Symbols" do
      param = described_class.new(:x,Symbol)

      param.value = 'str'
      param.value.should == :str
    end

    it "should coerce values into Strings" do
      param = described_class.new(:x,String)

      param.value = :str
      param.value.should == 'str'
    end

    it "should coerce values into Floats" do
      param = described_class.new(:x,Float)

      param.value = '0.5'
      param.value.should == 0.5
    end

    it "should coerce values into Integers" do
      param = described_class.new(:x,Integer)

      param.value = '5'
      param.value.should == 5
    end

    it "should coerce values into hex Integers" do
      param = described_class.new(:x,Integer)

      param.value = '0xa'
      param.value.should == 10
    end

    it "should coerce values into octal Integers" do
      param = described_class.new(:x,Integer)

      param.value = '010'
      param.value.should == 8
    end

    it "should coerce values into true boolean values" do
      param = described_class.new(:x,true)

      param.value = true
      param.value.should == true
    end

    it "should coerce non-false boolean values as true" do
      param = described_class.new(:x,true)

      param.value = '1'
      param.value.should == true
    end

    it "should coerce 'true' boolean values into true" do
      param = described_class.new(:x,true)

      param.value = 'true'
      param.value.should == true
    end

    it "should coerce :true boolean values into true" do
      param = described_class.new(:x,true)

      param.value = :true
      param.value.should == true
    end

    it "should coerce values into false" do
      param = described_class.new(:x,true)

      param.value = false
      param.value.should == false
    end

    it "should coerce 'false' boolean values into false" do
      param = described_class.new(:x,true)

      param.value = 'false'
      param.value.should == false
    end

    it "should coerce :false boolean values into false" do
      param = described_class.new(:x,true)

      param.value = :false
      param.value.should == false
    end

    it "should coerce values using a Proc for the type" do
      coercion_logic = lambda { |x| x.to_i.floor }
      param = described_class.new(:x,coercion_logic)

      param.value = 2.5
      param.value.should == 2
    end

    it "should coerce values using custom Classes" do
      original_value = Object.new
      param = described_class.new(:x,CustomType)

      param.value = original_value
      param.value.class.should == CustomType
      param.value.value.should == original_value
    end

    it "should not coerce nil into a type" do
      param = described_class.new(:x,String)
      obj1 = Object.new

      param.value = nil
      param.value.should be_nil
    end

    it "should not coerce unknown types" do
      param = described_class.new(:x)
      obj1 = Object.new

      param.value = obj1
      param.value.should == obj1
    end
  end
end
