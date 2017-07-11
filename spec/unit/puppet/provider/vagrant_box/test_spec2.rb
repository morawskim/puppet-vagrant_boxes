#! /usr/bin/env ruby
#require 'spec_helper'

describe Puppet::Type.type(:vagrant_box).provider(:vagrant) do
        before :each do
            puts described_class
            described_class.method(:stubs)
            #described_class.stubs
        end
        
         describe "test" do
             it "abc" do
                 expect(true).to eq described_class
             end
         end
end

