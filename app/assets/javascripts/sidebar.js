window.document.addEventListener('turbolinks:load', function(){
  const sidebar = document.querySelector('.sidebar');
  const sidebarsecond = document.querySelector('.sidebar_second');
  const sidebarHiddenButton = document.querySelector('.sidebar__hidden_button');
  const sidebarVisibleButton = document.querySelector('.sidebar__visible_button');

  if(sidebar != null){
    sidebarHiddenButton.addEventListener('click',function(){
      sidebar.classList.add('sidebar--hidden');
      sidebarHiddenButton.classList.add('invisible');
      sidebarVisibleButton.classList.remove('invisible');
      if(sidebarsecond != null){
        sidebarsecond.classList.add('sidebar_second--hidden');
      };
    });

    sidebarVisibleButton.addEventListener('click', function(){
      sidebar.classList.remove('sidebar--hidden');
      sidebarVisibleButton.classList.add('invisible');
      sidebarHiddenButton.classList.remove('invisible');
      if(sidebarsecond != null){
        sidebarsecond.classList.remove('sidebar_second--hidden');
      };
    });
  };
});