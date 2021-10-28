require 'rails_helper'

RSpec.describe Procedure, "モデルに関するテスト", type: :model do
  describe '実際に保存してみる' do
    before :each do
      @procedure = FactoryBot.build(:procedure)
      max_position = Procedure.where(manual_id: @procedure.manual.id).maximum(:position)
      if max_position.nil?
        @procedure.position = 1
      end
    end
    describe 'titleカラムに関して' do
      context 'titleが空白の場合' do
        it '保存されずに、エラーメッセージに「を入力してください」が含まれる' do
          @procedure.title = nil
          expect(@procedure).to be_invalid
          expect(@procedure.errors[:title]).to include("を入力してください")
        end
      end
    end
    describe 'positionカラムに関して' do
      context 'positionが空白の場合' do
        it '保存されずに、エラーメッセージに「を入力してください」が含まれる' do
          @procedure.position = nil
          expect(@procedure).to be_invalid
          expect(@procedure.errors[:position]).to include("を入力してください")
        end
      end
      context 'positionが小数点を含む場合' do
        it '保存されずに、エラーメッセージに「は整数で入力してください」が含まれる' do
          @procedure.position = 3.5
          expect(@procedure).to be_invalid
          expect(@procedure.errors[:position]).to include("は整数で入力してください")
        end
      end
    end
  end
  describe '実際に削除を行う' do
    before :each do
      @procedure = FactoryBot.build(:procedure)
      max_position = Procedure.where(manual_id: @procedure.manual.id).maximum(:position)
      if max_position.nil?
        @procedure.position = 1
      end
    end
    context '削除をした場合' do
      it 'レコード数が１つ減る' do
        @procedure.save
        count = Procedure.all.count
        @procedure.destroy
        expect(Procedure.all.count).to eq (count - 1)
      end
    end
    context 'memo_linkと紐づくprocedureを削除した場合' do
      it 'procedureのレコードとそれに紐づくmemo_linkのレコードもRecordNotFoundが返る' do
        @procedure.save
        procedure_id = @procedure.id
        memo_link = FactoryBot.create(:memo_link, procedure_id: procedure_id)
        memo_link_id = memo_link.id
        @procedure.destroy
        expect{Procedure.find(procedure_id)}.to raise_exception(ActiveRecord::RecordNotFound)
        expect{MemoLink.find(memo_link_id)}.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end
  end
  describe 'アソシエーションのテスト' do
    describe 'memo_linkとの関係性' do
      it '1:Nである' do
        expect(Procedure.reflect_on_association(:memo_links).macro).to eq :has_many
      end
    end
    describe 'manualとの関係性' do
      it 'N:1である' do
        expect(Procedure.reflect_on_association(:manual).macro).to eq :belongs_to
      end
    end
  end
end