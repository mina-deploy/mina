$(function () {
  // Get the relative prefix for pages based on the JavaScript's path. Hax!
  // "../javascripts/proscribe.js" means the prefix is "..".
  var urlPrefix = $("#proscribe-js").attr('src').match(/^(.*)\/?javascripts/)[1];

  // Returns pages that match a given keyword.
  //
  //     search("git:clone")
  //     //=> [ { parent: 5, title: 'git:clone', type: 'Git' }, ... ]
  //
  function search(keyword) {
      var words = keyword.toLowerCase().match(/[A-Za-z0-9]+/g);

      // Get results in the form of { page: score }
      // (eg { 5: 1, 6: 1 })
      var results = {};
      _.each(words, function(word) {
        _.each(Indices.search[word], function(score, id) {
          results[id] || (results[id] = 0);
          results[id] += score;
        });
      });

      return searchToPages(results);
  }

  // Converts { page: score } pairs to pages.
  //
  //     searchToPages({"0":4, "1":5})
  //     // this is a pair of { pageID: score }
  //     //=> Array of pages
  //
  function searchToPages(dict) {
    var list = _.map(dict, function(val, key) { return [key, val]; }); // {a:2,b:3} => [[a,2],[b,3]]
        list = _.sortBy(list, function(a) { return -1 * a[1]; });      // Sort by score
    var ids  = _.map(list, function(a) { return parseInt(a[0]); });    // Get array of page IDs
    return _.map(ids, function(id) { return Indices.pages[id] });      // Resolve to pages
  }

  window.search = search;

  $("#search input").live('keyup', function(e) {
    if (e.keyCode == 13) {
      var $a = $("#search .results > .active a");
      if ($a.length) {
        window.location = $a.attr('href');
        return false;
      };
    }
    if ((e.keyCode == 40) || (e.keyCode == 38)) { // DOWN and UP
      var dir = e.keyCode == 40 ? 'next' : 'prev';

      var links  = $("#search .results li");
      var active = $("#search .results .active");
      var next   = active[dir]();

      if (active.length && next.length) {
        active.removeClass('active');
        next.addClass('active');
      }

      return false;
    }

    var template = _.template(
      "<li>" + 
        "<a href='<%= url %>'>" +
          "<strong>" + 
            "<%= title %> " +
            "<% if (type) { %><span><%= type %></span><% } %>" +
          "</strong>" +
        "</a>" +
      "</li>");
    var keyword = $(this).val();
    results = search(keyword); // Array of {title: __, url: __}

    var $el = $("#search .results");
    $el.show();
    $el.html('');

    // Limit results
    results = results.slice(0, 12);

    _.each(results, function(page) {
      // Build the options for the tempalte
      o = _.extend({}, page);

      // Highlight.
      _.each(keyword.split(' '), function(word) {
        o.title = o.title.replace(new RegExp(word, 'i'), function (n) {
          return "<em class='highlight'>" + n + "</em>";
        });
      });

      o.url = urlPrefix + page.url;
      o.parent = Indices.search[page.parent];

      $el.append(template(o));
    });

    $el.find(':first-child').addClass('active');
  });

  $("#search .results li").live('hover', function() {
    var $results = $(this).closest('ul');
    $results.find('.active').removeClass('active');
    $(this).addClass('active');
  });

  $("#search .results").live('mouseout', function() {
    var $results = $(this);
    $results.find('.active').removeClass('active');
    $results.find('>:first-child').addClass('active');
  });

  $("body").live('click', function() {
    $("#search .results").hide();
  });
});

// ----------------------------------------------------------------------------
// Pretty print
// ----------------------------------------------------------------------------

$(function() {
  $("pre").each(function() {
    var text = $(this).text();
    text = text.replace(/^[ \n\t]*|[ \n\t]*$/g, '');
    var line = text.match(/^(.*?)[$\n]/)[1];

    // Terminalify those that begin with `$ `.
    if (text[0] == '$') {
      $(this).addClass('terminal');
    }

    // Those that have `# foo.rb` as the first line, highlight.
    var m = line.match(/^# (.*\.([a-z]{2,3}))$/);
    if (m) {
      var rest = text.match(/\n((?:.|\n)*)$/m)[1];
      $(this).addClass('prettyprint');
      $(this).addClass('lang-'+m[2]);
      $(this).addClass('has-caption');
      $(this).html("<h5>"+m[1]+"</h5>" + rest);
    }
  });

  prettyPrint();
});
