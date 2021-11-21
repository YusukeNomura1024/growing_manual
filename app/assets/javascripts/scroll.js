// スクロールすると文字や画像が表示される
window.document.addEventListener('turbolinks:load', function(){
  const backTextShow = function(){
    const innerTitleBackText = document.getElementsByClassName('inner__title_back_text');
    const innerImg = document.getElementsByClassName('inner__img');
    const innerDirection = document.getElementsByClassName('inner__direction');
    

    const position = Math.floor(window.innerHeight * .75);

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