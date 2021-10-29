require 'rails_helper'

RSpec.describe Tag, "モデルに関するテスト", type: :model do
  describe '保存テスト' do
    let(:tag) { FactoryBot.build(:tag) }
    context "有効な内容の場合" do
      it '保存される' do
        expect(tag).to be_valid
      end
    end
    describe 'user_idに関して' do
      context '空白の場合' do
        before :each do
          tag.user_id = nil
        end
        it '保存されない' do
          expect(tag).to be_invalid
        end
        it 'エラーメッセージに「を入力してください」が含まれる' do
          tag.valid?
          expect(tag.errors[:user_id]).to include("を入力してください")
        end
      end
    end
    describe 'nameに関して' do
      context '空白の場合' do
        before :each do
          tag.name = nil
        end
        it '保存されない' do
          expect(tag).to be_invalid
        end
        it 'エラーメッセージに「を入力してください」が含まれる' do
          tag.invalid?
          expect(tag.errors[:name]).to include("を入力してください")
        end
      end
      context '２１文字以上の場合' do
        before :each do
          tag.name = Faker::Lorem.characters(number: 21)
        end
        it "保存されずに、エラーメッセージに「は#{Tag::NAME_MAXIMUM_LENGTH}文字以内で入力してください」が含まれる" do
          expect(tag).to be_invalid
          expect(tag.errors[:name]).to include("は#{Tag::NAME_MAXIMUM_LENGTH}文字以内で入力してください")
        end
      end
    end
  end
  describe '削除テスト' do
    let(:tag){ FactoryBot.create(:tag) }

    context '通常削除した場合' do
      it '検索してもActiveRecord::RecordNotFoundが返る' do
        tag_id = tag.id
        tag.destroy
        expect{Tag.find(tag_id)}.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
    context 'tag_mapsと紐づいているレコードを削除した場合' do
      it 'tag_mapを検索してもActiveRecord::RecordNotFoundが返る' do
        tag_id = tag.id
        tag_map = FactoryBot.create(:tag_map, tag_id: tag_id)
        tag_map_id = tag_map.id
        tag.destroy
        expect{TagMap.find(tag_map_id)}.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end
  describe 'アソシエーションの確認' do
    context 'tag_map' do
      it '1:Nの関係でhas_manyが返る' do
        expect(Tag.reflect_on_association(:tag_maps).macro).to eq :has_many
      end
      it '関連するクラス名はTagMapである' do
        expect(Tag.reflect_on_association(:tag_maps).class_name).to eq "TagMap"
      end
    end
    it 'manualとは多対多の関係で互いにhas_manyが返る' do
      expect(Tag.reflect_on_association(:manuals).macro).to eq :has_many
      expect(Manual.reflect_on_association(:tags).macro).to eq :has_many
    end
    it 'userとは多対多の関係でbelongs_toが返る' do
      expect(Tag.reflect_on_association(:user).macro).to eq :belongs_to
    end
  end
end
