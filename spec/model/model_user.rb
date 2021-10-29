require 'rails_helper'

RSpec.describe Category, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
    let(:user){ FactoryBot.build(:user) }
    it "有効な内容の場合は保存されるか" do
      expect(user).to be_valid
    end
    describe 'email' do
      context '空白の場合' do
        let(:user__nil_email){ FactoryBot.build(:user, email: nil) }
        it '保存されない' do
          expect(user__nil_email).to be_invalid
          expect(user__nil_email.errors[:email]).to include("を入力してください")
        end
      end
      context '他のユーザーと重複していた場合' do
        it '保存されない' do
          FactoryBot.create(:user, email: "user@example.com")
          user2 = FactoryBot.build(:user, email: "user@example.com")
          expect(user2).to be_invalid
          expect(user2.errors[:email]).to include("はすでに存在します")
        end
      end
    end
    describe 'full_name' do
      context '空白の場合' do
        let(:user__nil_full_name){ FactoryBot.build(:user, full_name: nil) }
        it '保存されない' do
          expect(user__nil_full_name).to be_invalid
          expect(user__nil_full_name.errors[:full_name]).to include("を入力してください")
        end
      end
      context "#{User::FULL_NAME_MAXIMUM_LENGTH + 1}文字以上の場合" do
        it '保存されない' do
          user.full_name = Faker::Lorem.characters(number: User::FULL_NAME_MAXIMUM_LENGTH + 1)
          expect(user).to be_invalid
          expect(user.errors[:full_name]).to include("は#{User::FULL_NAME_MAXIMUM_LENGTH}文字以内で入力してください")
        end
      end
    end
    describe 'pen_name' do
      context '空白の場合' do
        it '保存されない' do
          user.pen_name = nil
          expect(user).to be_invalid
          expect(user.errors[:pen_name]).to include("を入力してください")
        end
      end
      context "#{User::PEN_NAME_MAXIMUM_LENGTH + 1}文字以上の場合" do
        it '保存されない' do
          user.pen_name = Faker::Lorem.characters(number: User::PEN_NAME_MAXIMUM_LENGTH + 1)
          expect(user).to be_invalid
          expect(user.errors[:pen_name]).to include("は#{User::PEN_NAME_MAXIMUM_LENGTH}文字以内で入力してください")
        end
      end
    end
    describe 'アソシエーションのテスト' do
      context 'bookmarks' do
        it '1:Nの関係' do
          expect(User.reflect_on_association(:bookmarks).macro).to eq :has_many
        end
      end
      context 'bookmarked_manuals' do
        it '1:Nの関係' do
          expect(User.reflect_on_association(:bookmarked_manuals).macro).to eq :has_many
        end
        it '紐づくクラスはManualである' do
          expect(User.reflect_on_association(:bookmarked_manuals).class_name).to eq "Manual"
        end
      end
      context 'manuals' do
        it '1:Nの関係' do
          expect(User.reflect_on_association(:manuals).macro).to eq :has_many
        end
      end
      context 'reviews' do
        it '1:Nの関係' do
          expect(User.reflect_on_association(:reviews).macro).to eq :has_many
        end
      end
      context 'messages' do
        it '1:Nの関係' do
          expect(User.reflect_on_association(:messages).macro).to eq :has_many
        end
      end
      context 'categories' do
        it '1:Nの関係' do
          expect(User.reflect_on_association(:categories).macro).to eq :has_many
        end
      end
      context 'memos' do
        it '1:Nの関係' do
          expect(User.reflect_on_association(:memos).macro).to eq :has_many
        end
      end
      context 'active_notifications' do
        it '1:Nの関係' do
          expect(User.reflect_on_association(:active_notifications).macro).to eq :has_many
        end
        it '紐づくクラスはNotificationである' do
          expect(User.reflect_on_association(:active_notifications).class_name).to eq "Notification"
        end
        it 'visitor_idとして扱われる' do
          expect(User.reflect_on_association(:active_notifications).foreign_key).to eq "visitor_id"
        end
      end
      context 'passive_notifications' do
        it '1:Nの関係' do
          expect(User.reflect_on_association(:passive_notifications).macro).to eq :has_many
        end
        it '紐づくクラスはNotificationである' do
          expect(User.reflect_on_association(:passive_notifications).class_name).to eq "Notification"
        end
        it 'visited_idとして扱われる' do
          expect(User.reflect_on_association(:passive_notifications).foreign_key).to eq "visited_id"
        end
      end
      context 'tags' do
        it '1:Nの関係' do
          expect(User.reflect_on_association(:tags).macro).to eq :has_many
        end
      end
    end
  end
end

