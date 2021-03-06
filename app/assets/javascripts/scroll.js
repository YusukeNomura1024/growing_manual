/*global $*/


// スクロールすると文字や画像が表示される
window.document.addEventListener('turbolinks:load', function(){
  const backTextShow = function(){
    const innerTitleBackText = document.getElementsByClassName('inner__title_back_text');
    const innerImg = document.getElementsByClassName('inner__img');
    const innerDirection = document.getElementsByClassName('inner__direction');
    const caseRow = document.getElementsByClassName('case_row')[0];


    const position = Math.floor(window.innerHeight * .75);
    if(caseRow != null){
      for (let i = 0; i < innerTitleBackText.length; i++) {
        let offsetTop = Math.floor(innerTitleBackText[i].getBoundingClientRect().top);
        if (offsetTop < position) {
          innerTitleBackText[i].classList.add('text_move--slidein_y');
        }
      }
      for (let i = 0; i < innerImg.length; i++) {
        let offsetTop = Math.floor(innerImg[i].getBoundingClientRect().top);
        if (offsetTop < position) {
          innerImg[i].classList.add('img_move--slidein_x');
        }
      }
      for (let i = 0; i < innerDirection.length; i++) {
        let offsetTop = Math.floor(innerDirection[i].getBoundingClientRect().top);
        if (offsetTop < position) {
          innerDirection[i].classList.add('text_move--slidein_reverse_x');
        }
      }
      let offsetTop = Math.floor(caseRow.getBoundingClientRect().top);
      if (offsetTop < position) {
        const caseDl = document.getElementsByClassName('case_row__dl');
        for (let i = 0; i < caseDl.length; i++) {
          caseDl[i].classList.add('slide_move_y');
        }
      }
    };
  };
  const backTextHidden = function(){
    const innerTitleBackText = document.getElementsByClassName('inner__title_back_text');

    const position = Math.floor(window.innerHeight * .75);

    for (let i = 0; i < innerTitleBackText.length; i++) {
      let offsetTop = Math.floor(innerTitleBackText[i].getBoundingClientRect().top);
      if (offsetTop > position) {
        innerTitleBackText[i].classList.remove('text_move--slidein_y');
      }
    }
  };

  window.addEventListener('scroll', backTextShow, false);
  window.addEventListener('scroll', backTextHidden, false);

  // 要素を横スクロールさせる
  const tagRowListArea = document.getElementById('tag_row__list_area');
  const listScrollerRightBtn = document.getElementById('list_scroller__right_btn');
  const listScrollerLeftBtn = document.getElementById('list_scroller__left_btn');

  const areaSideScroll = function(){
    //ボタンを押すと右に0.3秒かけて500px移動
    if(listScrollerRightBtn != null) {
      listScrollerRightBtn.addEventListener('click', function(){
        $("#tag_row__list_area").animate({
          scrollLeft: tagRowListArea.scrollLeft + 500,
        },300);
        return false;
      });
    }
    //ボタンを押すと左に0.3秒かけて500px移動
    if(listScrollerLeftBtn != null) {
      listScrollerLeftBtn.addEventListener('click', function(){
        $("#tag_row__list_area").animate({
          scrollLeft: tagRowListArea.scrollLeft - 500,
        },300);
        return false;
      });
    }
  };
  areaSideScroll();
  //aboutページのタイトルのアニメーション
  const aboutTitle = document.querySelector('.animate_title');
  if (aboutTitle != null) {
    const aboutTitleStr = aboutTitle.innerHTML.trim().split('');
    aboutTitle.innerHTML = aboutTitleStr.reduce((acc, curr) => {
      curr = curr.replace(/\s+/, '&nbsp;');
      return `${acc}<span class="title_text__strong char">${curr}</span>`;
    }, "");
  };
});