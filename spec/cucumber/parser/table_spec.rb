require File.dirname(__FILE__) + '/../../spec_helper'
require 'treetop'
require 'cucumber/parser/basic'
require 'cucumber/parser/table'
require 'cucumber/ast/table'

module Cucumber
  module Parser
    describe Table do
      before do
        @parser = TableParser.new
      end
      
      def parse(text)
        @parser.parse(text).build.raw || raise(@parser.failure_reason)
      end

      it "should parse a 1x2 table with newline" do
        parse(" | 1 | 2 | \n").should == [%w{1 2}]
      end

      it "should parse a 1x2 table without newline" do
        parse("| 1 | 2 |").should == [%w{1 2}]
      end

      it "should parse a 2x2 table" do
        parse("| 1 | 2 |\n| 3 | 4 |").should == [%w{1 2}, %w{3 4}]
      end

      it "should parse a 2x2 table with several newlines" do
        pending "FIX THIS PLEASE" do
          parse("| 1 | 2 |\n| 3 | 4 |\n\n\n").should == [%w{1 2}, %w{3 4}]
        end
      end

      it "should parse a 2x2 table with empty cells" do
        parse("| 1 |  |\n|| 4 |").should == [['1', nil], [nil, '4']]
      end

      it "should not parse tables with uneven rows" do
        lambda do
          parse("|1|\n|2|3|")
        end.should raise_error(IndexError, "element size differs (2 should be 1)")
      end
    end
  end
end