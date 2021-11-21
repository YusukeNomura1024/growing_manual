// スクロールすると文字が表示される
window.document.addEventListener('turbolinks:load', function(){
  const backTextShow = function(){
    const innerTitleBackText = document.getElementsByClassName('inner__title_back_text');

    const position = Math.floor(window.innerHeight * .75);

    for (let i = 0; i < innerTitleBackText.length; i++) {
      let offsetTop = Math.floor(innerTitleBackText[i].getBoundingClientRect().top);
      if (offsetTop < position) {
        innerTitleBackText[i].classList.add('text_move--slidein_y');
      }
    }
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
});