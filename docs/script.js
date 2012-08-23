(function($) {
  // $("#area").scrollspy({ on: 'tr', onChange: function(){} });
  $.fn.scrollspy = function(options) {
    var $this = $(this);

    $this.on('scroll', onscroll);
    function onscroll() {
      var y = $this.scrollTop();
      var percent = y / ($this[0].scrollHeight - $this.height());
      percent = Math.pow(percent, 3) * 0.9 + 0.1;
      var current = null;
      var stop = false;

      $(options.on).each(function() {
        if (stop) return;
        var min = $(this).position().top;
        var isVisible = (min < $this.height() * percent);
        if (isVisible) {
          current = this;
        } else {
          stop = true;
        }
      });

      if ((options.alwaysOn) && (!current)) {
        current = $($(options.on)[0]);
      }

      if ($this.data('scroll:current') != current) {
        $this.data('scroll:current', current);
        if (typeof options.onChange === 'function') {
          options.onChange.call($this, current);
        }
      }
    };

    onscroll.call($this);
    return this;
  };
})(jQuery);
(function() {

  function openSidebarTab(href) {
    $('#sidebar .tabs button').removeClass('active');
    $('#sidebar .tabs button[data-tab="'+href+'"]').addClass('active');

    $('#sidebar .list').hide();
    $('#sidebar .list.'+href).show();
  }

  $('#sidebar .tabs button').on('click', function() {
    var href = $(this).attr('data-tab');
    openSidebarTab(href);
  });

  /* Load file list */
  $(function() {
    if (window.location.hash === '#f') {
      openSidebarTab('files');
    }
  });

  /* Toggle */
  $(".files.list .folder").on('click', function() {
    $(this).toggleClass('expanded');
    var ul = $(this).closest('li').find('>ul');
    ul.slideToggle(200);
  });

  /* Scrollspy */
  $(function() {
   $("#area").scrollspy({
     on: 'tr.heading',
     alwaysOn: true,
     onChange: function(current) {
       var id = $(current).attr('id');
       $(".current-page a").removeClass('active');

       $("tr").removeClass('active');
       $(current).addClass('active');

       if ($(current).find('h1').length > 0) {
         $(".current-page a[href='#']").addClass('active');
       } else {
         $(".current-page a[href='#"+id+"']").addClass('active');
       }
     }
   });
  });

})();
