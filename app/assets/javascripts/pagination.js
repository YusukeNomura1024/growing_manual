window.document.addEventListener('turbolinks:load', function(){
  const next = document.querySelector('.pagination > .next > a');
  const first = document.querySelector('.pagination > .first > a');
  const prev = document.querySelector('.pagination > .prev > a');
  const last = document.querySelector('.pagination > .last > a');

  if(next){
    next.textContent = '次へ';
  }
  if(first){
    first.textContent = '最初'
  }
  if(prev){
    prev.textContent = '前へ'
  }
  if(last){
    last.textContent = '最後'
  }

});