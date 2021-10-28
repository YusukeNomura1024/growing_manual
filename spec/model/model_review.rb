require 'rails_helper'

RSpec.describe Review, "モデルに関するテスト", type: :model do
  describe '保存テスト' do
    let(:review) { FactoryBot.build(:review) }
    context '通常の保存の場合' do
      it '保存される' do
        expect(review).to be_valid
      end
    end
    describe 'user_idに関して' do
      context 'user_idが空白の場合' do
        it '保存されずに、エラーメッセージが返る' do
          review.user_id = nil
          expect(review).to be_invalid
          expect(review.errors[:user_id]).to include("を入力してください")
        end
      end
    end
    describe 'manual_idに関して' do
      context 'manual_idが空白の場合' do
        it '保存されずに、エラーメッセージが返る' do
          review.manual_id = nil
          expect(review).to be_invalid
          expect(review.errors[:manual_id]).to include("を入力してください")
        end
      end
    end
    describe 'rateに関して' do
      context 'rateが空白の場合' do
        it '保存されずに、エラーメッセージが返る' do
          review.rate = nil
          expect(review).to be_invalid
          expect(review.errors[:rate]).to include("を入力してください")
        end
      end
      context 'rateに小数点が含まれる場合' do
        it '保存されずに、エラーメッセージが返る' do
          review.rate = 1.2
          expect(review).to be_invalid
          expect(review.errors[:rate]).to include("は整数で入力してください")
        end
      end
      context 'rateが負の数字の場合' do
        it '保存されずに、エラーメッセージが返る' do
          review.rate = -1
          expect(review).to be_invalid
          expect(review.errors[:rate]).to include("は0以上の値にしてください")
        end
      end
      context 'rateが6以上の場合' do
        it '保存されずに、エラーメッセージが返る' do
          review.rate = 6
          expect(review).to be_invalid
          expect(review.errors[:rate]).to include("は5以下の値にしてください")
        end
      end
    end
    describe 'commentに関して' do
      context '200文字以上の場合' do
        let(:review__comment_201) { FactoryBot.build(:review, comment: Faker::Lorem.characters(number: 201)) }
        it '保存されない' do
          expect(review__comment_201).to be_invalid
        end
        it 'エラーメッセージに「は200文字以内で入力してください」が含まれる' do
          review__comment_201.valid?
          expect(review__comment_201.errors[:comment]).to include("は200文字以内で入力してください")
        end
      end
    end
  end
  describe '削除テスト' do
    let(:review) { FactoryBot.create(:review) }
    context '通常削除した場合' do
      it '削除されて、検索するとActiveRecord::RecordNotFoundが返る' do
        review_id = review.id
        review.destroy
        expect{Review.find(review_id)}.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
    context 'messageと紐づくレコードを削除した場合' do
      it 'messageも一緒に削除されて、検索するとActiveRecord::RecordNotFoundが返る' do
        review_id = review.id
        message = FactoryBot.create(:message__target_review, review_id: review_id)
        message_id = message.id
        review.destroy
        expect{Review.find(review_id)}.to raise_exception(ActiveRecord::RecordNotFound)
        expect{Message.find(message_id)}.to raise_exception(ActiveRecord::RecordNotFound)
      end
      it 'messageも一緒に削除されて、レコード数が減っている' do
        FactoryBot.create(:message__target_review, review_id: review.id)
        count_review = Review.all.count
        count_message = Message.all.count
        review.destroy
        expect(Review.all.count).to eq (count_review - 1)
        expect(Message.all.count).to eq (count_message - 1)
      end
    end
    context 'notificationと紐づくレコードを削除した場合' do
      it 'notificationも一緒に削除されて、検索するとActiveRecord::RecordNotFoundが返る' do
        review_id = review.id
        notification = FactoryBot.create(:notification__reviewing, review_id: review_id)
        notification_id = notification.id
        review.destroy
        expect{Review.find(review_id)}.to raise_exception(ActiveRecord::RecordNotFound)
        expect{Message.find(notification_id)}.to raise_exception(ActiveRecord::RecordNotFound)
      end
      it 'notificationも一緒に削除されて、レコード数が減っている' do
        FactoryBot.create(:notification__reviewing, review_id: review.id)
        count_review = Review.all.count
        count_notification = Notification.all.count
        review.destroy
        expect(Review.all.count).to eq (count_review - 1)
        expect(Notification.all.count).to eq (count_notification - 1)
      end
    end
  end
  describe 'アソシエーションのテスト' do
    describe 'userとの関係性' do
      it 'N:1である' do
        expect(Review.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    describe 'manualとの関係性' do
      it 'N:1である' do
        expect(Review.reflect_on_association(:manual).macro).to eq :belongs_to
      end
    end
    describe 'messageとの関係性' do
      it '1:Nである' do
        expect(Review.reflect_on_association(:messages).macro).to eq :has_many
      end
    end
    describe 'notificationとの関係性' do
      it '1:Nである' do
        expect(Review.reflect_on_association(:notifications).macro).to eq :has_many
      end
    end
  end
end