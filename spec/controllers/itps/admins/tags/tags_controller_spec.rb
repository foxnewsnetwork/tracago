require 'spec_helper'

describe Itps::Admins::Tags::TagsController do
  describe '#create' do
    login_user
    let(:current_account) { controller.send :current_account }
    let(:tag) { controller.send :_tag }
    before do
      current_account.adminify!
      @parent_tag = JewFactory::Tag.mock
      @params = { presentation: 'Child Tag' }
      @create = lambda { post :create, tag_id: @parent_tag.permalink, itps_tag: @params }
    end
    it 'should create both a relationship' do
      @create.should change(Itps::TagsTags, :count).by(1)
    end
    it 'should create a tag' do
      @create.should change(Itps::Tag, :count).by(1)
    end
    it 'should be properly related' do
      @create.call
      @parent_tag.reload.children.should include tag
      tag.parent.should eq @parent_tag
    end
  end
end