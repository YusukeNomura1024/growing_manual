// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery

//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_directory
//= require_tree ./public

/*global $*/

window.document.addEventListener('turbolinks:load', function(){
  $(document).ready(function() {
    $(function() {
      $('.tab').click(function(){
        $('.tab-active').removeClass('tab-active');
        $(this).addClass('tab-active');
        $('.box-show').removeClass('box-show');
        var $this = $(this);
        $($this.attr('href')).addClass('box-show');
        const memo = document.getElementById('memo-display')
        memo.innerHTML = ""
        const memoListItem = document.getElementsByClassName('memo__list_item');
        for (let i=0; i < memoListItem.length; i++){
          memoListItem[i].classList.remove('memo__list_item--active');
        };
      });
    });
  });
  var jscrollOption = {
  loadingHtml: '読み込み中・・・', //記事読み込み中の表示
  autoTrigger: true, // 自動で読み込むか否か、trueで自動、falseでボタンクリックとなる。
  padding: 20, // 指定したコンテンツの下かた何pxで読み込むかを指定(autoTrigger: trueの場合のみ)
  contentSelector: '#jscroll', // 読み込む範囲の指定
  nextSelector: 'span.next a'
  };
  $(function() {
    $('#jscroll').jscroll(jscrollOption);
  });

  const memoListItem = document.getElementsByClassName('memo__list_item');
  for (let i=0; i < memoListItem.length; i++){
    memoListItem[i].addEventListener('click', function(){
      for (let j=0; j < memoListItem.length; j++){
        memoListItem[j].classList.remove('memo__list_item--active');
      };

      this.classList.add('memo__list_item--active');
    });
  };
  if(document.getElementsByClassName('column_form__input_file')[0]){
    const inputFile = document.getElementsByClassName('column_form__input_file')[0];
    inputFile.addEventListener('change', function(){
      const fileName = document.getElementById('select_file_name');
      fileName.textContent = inputFile.value.split( 'C:\\fakepath\\' ).join('ファイル名：');
      if(inputFile.value == null || inputFile.value == ""){
        fileName.textContent = "ファイルを選択してください";
      };
    });
  };
})

