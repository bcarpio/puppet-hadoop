# spec/classes/init_spec.rb
require 'spec_helper'

describe "hadoop::init" do
  context "CentOS" do
    let :facts do
      {
         :osfamily => 'RedHat',
         :operatingsystem => 'CentOS'
      }
    end
    it { should create_user('hdfs').with_uid('102')}
  end
end

