require 'rails_helper'

describe '[STEP1] ユーザログイン前のテスト' do
  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end

    describe '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
      it 'ログインリンクが表示される: 左上から5番目のリンクが「ログイン」である' do
        log_in_link = find_all('a')[4].native.text
        expect(log_in_link).to match(/ログイン/i)
      end
      it 'ログインリンクの内容が正しい' do
        log_in_link = find_all('a')[4].native.text
        expect(page).to have_link log_in_link, href: new_user_session_path
      end
      it '新規登録リンクが表示される: 左上から4番目のリンクが「新規登録」である' do
        sign_up_link = find_all('a')[3].native.text
        expect(sign_up_link).to match(/新規登録/i)
      end
      it '新規登録リンクの内容が正しい' do
        sign_up_link = find_all('a')[3].text
        expect(page).to have_link sign_up_link, href: new_user_registration_path
      end
    end
  end

  describe 'アバウト画面のテスト' do
    before do
      visit '/about'
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/about'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしていない場合' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'ロゴ画像が表示される' do
        img = find_all('img')[0]
        expect(img['src']).to include('/assets/growing_manual_logo')
      end
      it '公開一覧リンクが表示される: 左上から2番目のリンクが「公開一覧」である' do
        public_manual_list = find_all('a')[1].text
        expect(public_manual_list).to match(/公開一覧/i)
      end
      it 'Aboutリンクが表示される: 左上から3番目のリンクが「About」である' do
        about_link = find_all('a')[2].text
        expect(about_link).to match(/about/i)
      end
      it '新規登録リンクが表示される: 左上から4番目のリンクが「新規登録」である' do
        sign_up_link = find_all('a')[3].native.text
        expect(sign_up_link).to match(/新規登録/i)
      end
      it 'ログインリンクが表示される: 左上から5番目のリンクが「ログイン」である' do
        log_in_link = find_all('a')[4].native.text
        expect(log_in_link).to match(/ログイン/i)
      end
    end

    context 'リンクの内容を確認' do
      subject { current_path }
      it 'ロゴボタンを押すと、トップ画面に遷移する' do
        find_all('a')[0].click
        is_expected.to eq '/'
      end
      it '公開一覧リンクを押すと、トップ画面に遷移する' do
        find_all('a')[1].click
        is_expected.to eq '/'
      end
      it 'Aboutを押すと、アバウト画面に遷移する' do
        about_link = find_all('a')[2].text
        about_link = about_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link about_link
        is_expected.to eq '/about'
      end
      it '新規登録を押すと、新規登録画面に遷移する' do
        signup_link = find_all('a')[3].text
        signup_link = signup_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link signup_link
        is_expected.to eq '/users/sign_up'
      end
      it 'ログインを押すと、ログイン画面に遷移する' do
        login_link = find_all('a')[4].text
        login_link = login_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link login_link
        is_expected.to eq '/users/sign_in'
      end
    end
  end
  
  
end