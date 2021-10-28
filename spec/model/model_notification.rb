require 'rails_helper'

RSpec.describe Notification, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
    let(:notification__bookmarking) { FactoryBot.build(:notification__bookmarking) }
    let(:notification__reviewing) { FactoryBot.build(:notification__reviewing) }
    let(:notification__from_admin) { FactoryBot.build(:notification__from_admin) }
    describe 'typeカラムに関して' do
      context 'typeがbookmarkingの場合' do
        it '保存される' do
          expect(notification__bookmarking).to be_valid
        end
      end
      context 'typeがreviewingの場合' do
        it '保存される' do
          expect(notification__reviewing).to be_valid
        end
      end
      context 'typeがfrom_adminの場合' do
        it '保存される' do
          expect(notification__from_admin).to be_valid
        end
      end
      context 'typeが空白の場合' do
        it '保存されず、エラーメッセージに「を入力してください」が表示される' do
          notification__bookmarking.type = nil
          expect(notification__bookmarking).to be_invalid
          expect(notification__bookmarking.errors[:type]).to include("を入力してください")
        end
      end
    end
    describe 'is_checkedカラムに関して' do
      context '指定しない場合' do
        it 'デフォルトでfalseが返る' do
          expect(notification__bookmarking.is_checked).to be_falsey
        end
      end
    end
    describe 'manual_idカラムに関して' do
      context 'typeがbookmarkinで、manual_idが空白の場合' do
        it '保存されず、エラーメッセージに「を入力してください」がふくまれる' do
          notification__bookmarking.manual_id = nil
          expect(notification__bookmarking).to be_invalid
          expect(notification__bookmarking.errors[:manual_id]).to include("を入力してください")
        end
      end
    end
    describe 'review_idカラムに関して' do
      context 'typeがreviewingで、review_idが空白の場合' do
        it '保存されず、エラーメッセージに「を入力してください」がふくまれる' do
          notification__reviewing.review_id = nil
          expect(notification__reviewing).to be_invalid
          expect(notification__reviewing.errors[:review_id]).to include("を入力してください")
        end
      end
    end
  end
  describe 'アソシエーションのテスト' do
    describe 'visitorとの関係性' do
      it 'N:1である' do
        expect(Notification.reflect_on_association(:visitor).macro).to eq :belongs_to
      end
    end
    describe 'visitedとの関係性' do
      it 'N:1である' do
        expect(Notification.reflect_on_association(:visited).macro).to eq :belongs_to
      end
    end
    describe 'manualとの関係性' do
      it 'N:1である' do
        expect(Notification.reflect_on_association(:manual).macro).to eq :belongs_to
      end
    end
    describe 'reviewとの関係性' do
      it 'N:1である' do
        expect(Notification.reflect_on_association(:review).macro).to eq :belongs_to
      end
    end
  end
end