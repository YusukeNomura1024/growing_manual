require 'rails_helper'

RSpec.describe Message, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
    let(:message__type_contact) { (FactoryBot.build(:message__type_contact)) }
    let(:message__target_manual) { (FactoryBot.build(:message__target_manual)) }
    let(:message__target_review) { (FactoryBot.build(:message__target_review)) }
    let(:message__type_from_admin) { (FactoryBot.build(:message__type_from_admin)) }
    context 'typeがcontactの場合' do
      it '保存される' do
        expect(message__type_contact).to be_valid
      end
    end
    context 'typeがviolation_reporttでターゲットがmanualの場合' do
      it '保存される' do
        expect(message__target_manual).to be_valid
      end
    end
    context 'typeがviolation_reporttでターゲットがreviewの場合' do
      it '保存される' do
        expect(message__target_review).to be_valid
      end
    end
    context 'typeがfrom_adminの場合' do
      it '保存される' do
        expect(message__type_from_admin).to be_valid
      end
    end
    describe 'commentに関するバリデーションについて' do
      context '空白の場合は' do
        it '保存されず、エラーメッセージに「を入力してください」が含まれる' do
          message__type_contact.comment = nil
          expect(message__type_contact).to be_invalid
          expect(message__type_contact.errors[:comment]).to include("を入力してください")
        end
      end
      describe '文字数制限に関するバリデーションエラーについて' do
        context '文字数が１００文字以下の場合' do
          it '保存される' do
            message__type_contact.comment = Faker::Lorem.characters(number: 100)
            expect(message__type_contact).to be_valid
          end
        end
        context '文字数が１０１文字以上の場合' do
          it '保存されず、エラーメッセージに「は100文字以内で入力してください」が含まれる' do
            message__type_contact.comment = Faker::Lorem.characters(number: 101)
            expect(message__type_contact).to be_invalid
            expect(message__type_contact.errors[:comment]).to include("は100文字以内で入力してください")
          end
        end
      end
    end
    describe 'typeに関するバリデーションについて' do
      context '空白の場合は' do
        it '保存されず、エラーメッセージに「を入力してください」が含まれる' do
          message__type_contact.type = nil
          expect(message__type_contact).to be_invalid
          expect(message__type_contact.errors[:type]).to include("を入力してください")
        end
      end
    end
  end
  describe '実際に削除をする' do
    let!(:message__type_contact) { (FactoryBot.create(:message__type_contact)) }
    let!(:message__target_manual) { (FactoryBot.create(:message__target_manual)) }
    let!(:message__target_review) { (FactoryBot.create(:message__target_review)) }
    let!(:message__type_from_admin) { (FactoryBot.create(:message__type_from_admin)) }
    context '削除をした場合' do
      it '削除した数だけレコード数が減っている' do
        count = Message.all.count
        message__type_contact.destroy
        message__target_manual.destroy
        message__target_review.destroy
        message__type_from_admin.destroy
        expect(Message.all.count).to eq(count - 4)
      end
    end
    context '作成したuserが削除された場合' do
      let!(:user) {FactoryBot.create(:user) }
      it 'messageも一緒に削除され、検索しても見つからない' do
        message = FactoryBot.create(:message__type_contact, user_id: user.id)
        message_id = message.id
        user.destroy
        expect{Message.find(message_id)}.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
    context 'targetのmanualが削除された場合' do
      let!(:manual) {FactoryBot.create(:manual) }
      it 'messageも一緒に削除され、検索しても見つからない' do
        message = FactoryBot.create(:message__target_manual, manual_id: manual.id)
        message_id = message.id
        manual.destroy
        expect{Message.find(message_id)}.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
    context 'targetのreviewが削除された場合' do
      let!(:review) {FactoryBot.create(:review) }
      it 'messageも一緒に削除され、検索しても見つからない' do
        message = FactoryBot.create(:message__target_review, review_id: review.id)
        message_id = message.id
        review.destroy
        expect{Message.find(message_id)}.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end
  describe 'アソシエーションのテスト' do
    describe 'userとの関係性' do
      it 'N:1である' do
        expect(Message.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    describe 'manualとの関係性' do
      it 'N:1である' do
        expect(Message.reflect_on_association(:manual).macro).to eq :belongs_to
      end
    end
    describe 'reviewとの関係性' do
      it 'N:1である' do
        expect(Message.reflect_on_association(:review).macro).to eq :belongs_to
      end
    end
  end
  describe 'メソッドのテスト' do
    let!(:message__type_contact) { (FactoryBot.create(:message__type_contact)) }
    let!(:message__target_manual) { (FactoryBot.create(:message__target_manual)) }
    let!(:message__target_review) { (FactoryBot.create(:message__target_review)) }
    let!(:message__type_from_admin) { (FactoryBot.create(:message__type_from_admin)) }
    describe 'violation_report?メソッド' do
      context 'typeがviolation_reportの場合' do
        it 'trueが返る' do
          expect(message__target_manual.violation_report?).to be_truthy
          expect(message__target_review.violation_report?).to be_truthy
        end
      end
      context 'typeがviolation_report以外の場合' do
        it 'falseが返る' do
          expect(message__type_contact.violation_report?).to be_falsey
          expect(message__type_from_admin.violation_report?).to be_falsey
        end
      end
    end
    describe 'report_targetメソッド' do
      context 'targetがmanualの場合' do
        it 'manualのtileが返る' do
          manual = message__target_manual.manual
          manual.update(title: "タイトル")
          expect(message__target_manual.report_target).to include("タイトル")
        end
      end
      context 'targetがreviewの場合' do
        it 'レビュアーのペンネームが返る' do
          review = message__target_review.review
          user = review.user
          user.update(pen_name: "ペンネーム")
          expect(message__target_review.report_target).to include("ペンネーム")
        end
      end
      context '通報対象が空白（管理者宛てのメッセージ）の場合' do
        it '空白が返る' do
          expect(message__type_contact.report_target).to eq nil
        end
      end
      context '通報対象が空白（ユーザー宛てのメッセージ）の場合' do
        it '空白が返る' do
          expect(message__type_from_admin.report_target).to eq nil
        end
      end
    end
  end
end


# 動作確認のための記述
describe '四則演算' do
  context '足し算' do
    it '1 + 1 は 2 になる' do
      expect(1 + 1).to eq 2
    end
  end
end