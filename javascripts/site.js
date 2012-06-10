// Search
// ----------------------------------------------------------------------------

$(function () {
  // Get the relative prefix for pages.
  var urlPrefix = $("#logo").attr('href');
  urlPrefix = urlPrefix.substr(0, urlPrefix.length - 1);

  // Returns pages that match a given keyword.
  //
  //     search("git:clone")
  //     //=> [ { parent: 5, title: 'git:clone', type: 'Git' }, ... ]
  //
  function search(keyword) {
      var words = keyword.toLowerCase().match(/[A-Za-z0-9_]+/g);

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

  // Navigates to a given link href.
  function navigateTo(href) {
    var base = window.location.pathname;
    base = base.replace(/[^\/]*$/, '');
    var url = base + href;
    url = url.replace(/\/{2,}/, '/');
    window.location = url;
  }

  window.search = search;

  var template = _.template(
    "<li>" + 
      "<a href='<%= url %>'>" +
        "<strong>" + 
          "<%= title %> " +
          "<% if (type) { %><span><%= type %></span><% } %>" +
        "</strong>" +
      "</a>" +
    "</li>");

  // Perform a search and open the dropdown
  function doSearch(keyword) {
    var results = search(keyword); // Array of {title: __, url: __}

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
  }

  $("#search input").live('click', function(e) {
    e.preventDefault();
    e.stopPropagation();
    doSearch($(this).val());
  });

  $("#search input").live('keyup', function(e) {
    if (e.keyCode == 13) {
      var $a = $("#search .results > .active a");
      if ($a.length) {
        navigateTo($a.attr('href'));
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

    var keyword = $(this).val();
    doSearch(keyword);
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

// Pretty print
// Modify <pre>s to add the right classes.
// ----------------------------------------------------------------------------

$(function() {
  $("pre").each(function() {
    var text = $(this).text();
    text = text.replace(/^[ \n\t]*|[ \n\t]*$/g, '');
    var line = text.match(/^(.*?)[$\n]/)[1];

    // Terminalify those that begin with `$ `.
    if (text[0] == '$') {
      $(this).addClass('terminal');
      // Strip a first line that's only $
      var html = text.replace(/^\$*\n/, "");
      // Highlight the commands
      var html = html.replace(/((?:^|\n)(?:\$ |~)[^\n]+)$/mg, "<strong>$1</strong>");
      // Comments
      var html = html.replace(/((?:^|\n)#[^\n]*)$/mg, "<em>$1</em>");
      $(this).html(html);
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

// Search indices
// This is the data used by the search engine.
// ----------------------------------------------------------------------------

window.Indices = ({"pages":[{"title":"About deploy.rb","url":"about_deploy_rb.html","type":"Getting started","parent":12},{"title":"Command line options","url":"command_line_options.html","type":"API","parent":12},{"title":"Command queue","url":"command_queue.html","type":"Getting started","parent":12},{"title":"Deploying","url":"deploying.html","type":"Getting started","parent":12},{"title":"Directory structure","url":"directory_structure.html","type":"Getting started","parent":12},{"title":"echo_cmd","url":"helpers/echo_cmd.html","type":"Helpers","parent":6},{"title":"Helpers","url":"helpers/index.html","type":"API","parent":12},{"title":"invoke","url":"helpers/invoke.html","type":"Helpers","parent":6},{"title":"queue","url":"helpers/queue.html","type":"Helpers","parent":6},{"title":"simulate_mode","url":"helpers/simulate_mode.html","type":"Helpers","parent":6},{"title":"verbose_mode","url":"helpers/verbose_mode.html","type":"Helpers","parent":6},{"title":"logo.png","url":"images/logo.png","type":null,"parent":null},{"title":"Mina","url":"index.html","type":null,"parent":null},{"title":"site.js","url":"javascripts/site.js","type":null,"parent":null},{"title":"Setting up a project","url":"setting_up_a_project.html","type":"Getting started","parent":12},{"title":"current_path","url":"settings/current_path.html","type":"Deploy settings","parent":19},{"title":"deploy_to","url":"settings/deploy_to.html","type":"Deploy settings","parent":19},{"title":"domain","url":"settings/domain.html","type":"SSH settings","parent":19},{"title":"identity_file","url":"settings/identity_file.html","type":"SSH settings","parent":19},{"title":"Settings","url":"settings/index.html","type":"API","parent":12},{"title":"lock_file","url":"settings/lock_file.html","type":"Deploy settings","parent":19},{"title":"releases_path","url":"settings/releases_path.html","type":"Deploy settings","parent":19},{"title":"repository","url":"settings/repository.html","type":"Git settings","parent":19},{"title":"revision","url":"settings/revision.html","type":"Git settings","parent":19},{"title":"shared_path","url":"settings/shared_path.html","type":"Deploy settings","parent":19},{"title":"term_mode","url":"settings/term_mode.html","type":"General settings","parent":19},{"title":"user","url":"settings/user.html","type":"SSH settings","parent":19},{"title":"site.css","url":"stylesheets/site.css","type":null,"parent":null},{"title":"Subtasks","url":"subtasks.html","type":"Getting started","parent":12},{"title":"bundle:install","url":"tasks/bundle_install.html","type":"Bundler tasks","parent":32},{"title":"deploy:force_unlock","url":"tasks/deploy_force_unlock.html","type":"Deploy tasks","parent":32},{"title":"git:clone","url":"tasks/git_clone.html","type":"Git tasks","parent":32},{"title":"Tasks","url":"tasks/index.html","type":"API","parent":12},{"title":"rails:assets_precompile","url":"tasks/rails_assets_precompile.html","type":"Rails tasks","parent":32},{"title":"rails:db_migrate","url":"tasks/rails_db_migrate.html","type":"Rails tasks","parent":32},{"title":"run","url":"tasks/run.html","type":"Deploy tasks","parent":32},{"title":"setup","url":"tasks/setup.html","type":"Deploy tasks","parent":32}],"search":{"ab":{"0":33},"abo":{"0":33},"abou":{"0":33},"about":{"0":33},"de":{"0":33,"3":63,"16":63,"30":63},"dep":{"0":33,"3":63,"16":63,"30":63},"depl":{"0":33,"3":63,"16":63,"30":63},"deplo":{"0":33,"3":63,"16":63,"30":63},"deploy":{"0":33,"3":63,"16":63,"30":63},"co":{"1":33,"2":33},"com":{"1":33,"2":33},"comm":{"1":33,"2":33},"comma":{"1":33,"2":33},"comman":{"1":33,"2":33},"command":{"1":33,"2":33},"li":{"1":33},"lin":{"1":33},"line":{"1":33},"op":{"1":33},"opt":{"1":33},"opti":{"1":33},"optio":{"1":33},"option":{"1":33},"options":{"1":33},"qu":{"2":33,"8":63},"que":{"2":33,"8":63},"queu":{"2":33,"8":63},"queue":{"2":33,"8":63},"deployi":{"3":63},"deployin":{"3":63},"deploying":{"3":63},"di":{"4":33},"dir":{"4":33},"dire":{"4":33},"direc":{"4":33},"direct":{"4":33},"directo":{"4":33},"director":{"4":33},"directory":{"4":33},"st":{"4":33},"str":{"4":33},"stru":{"4":33},"struc":{"4":33},"struct":{"4":33},"structu":{"4":33},"structur":{"4":33},"structure":{"4":33},"ec":{"5":63},"ech":{"5":63},"echo":{"5":63},"echo_":{"5":63},"echo_c":{"5":63},"echo_cm":{"5":63},"echo_cmd":{"5":63},"he":{"6":63},"hel":{"6":63},"help":{"6":63},"helpe":{"6":63},"helper":{"6":63},"helpers":{"6":63},"in":{"7":63,"29":63},"inv":{"7":63},"invo":{"7":63},"invok":{"7":63},"invoke":{"7":63},"si":{"9":63,"13":63,"27":63},"sim":{"9":63},"simu":{"9":63},"simul":{"9":63},"simula":{"9":63},"simulat":{"9":63},"simulate":{"9":63},"simulate_":{"9":63},"simulate_m":{"9":63},"simulate_mo":{"9":63},"simulate_mod":{"9":63},"simulate_mode":{"9":63},"ve":{"10":63},"ver":{"10":63},"verb":{"10":63},"verbo":{"10":63},"verbos":{"10":63},"verbose":{"10":63},"verbose_":{"10":63},"verbose_m":{"10":63},"verbose_mo":{"10":63},"verbose_mod":{"10":63},"verbose_mode":{"10":63},"lo":{"11":63,"20":63},"log":{"11":63},"logo":{"11":63},"pn":{"11":63},"png":{"11":63},"mi":{"12":63},"min":{"12":63},"mina":{"12":63},"sit":{"13":63,"27":63},"site":{"13":63,"27":63},"se":{"14":33,"19":63,"36":63},"set":{"14":33,"19":63,"36":63},"sett":{"14":33,"19":63},"setti":{"14":33,"19":63},"settin":{"14":33,"19":63},"setting":{"14":33,"19":63},"pr":{"14":33},"pro":{"14":33},"proj":{"14":33},"proje":{"14":33},"projec":{"14":33},"project":{"14":33},"cu":{"15":63},"cur":{"15":63},"curr":{"15":63},"curre":{"15":63},"curren":{"15":63},"current":{"15":63},"current_":{"15":63},"current_p":{"15":63},"current_pa":{"15":63},"current_pat":{"15":63},"current_path":{"15":63},"deploy_":{"16":63},"deploy_t":{"16":63},"deploy_to":{"16":63},"do":{"17":63},"dom":{"17":63},"doma":{"17":63},"domai":{"17":63},"domain":{"17":63},"id":{"18":63},"ide":{"18":63},"iden":{"18":63},"ident":{"18":63},"identi":{"18":63},"identit":{"18":63},"identity":{"18":63},"identity_":{"18":63},"identity_f":{"18":63},"identity_fi":{"18":63},"identity_fil":{"18":63},"identity_file":{"18":63},"settings":{"19":63},"loc":{"20":63},"lock":{"20":63},"lock_":{"20":63},"lock_f":{"20":63},"lock_fi":{"20":63},"lock_fil":{"20":63},"lock_file":{"20":63},"re":{"21":63,"22":63,"23":63},"rel":{"21":63},"rele":{"21":63},"relea":{"21":63},"releas":{"21":63},"release":{"21":63},"releases":{"21":63},"releases_":{"21":63},"releases_p":{"21":63},"releases_pa":{"21":63},"releases_pat":{"21":63},"releases_path":{"21":63},"rep":{"22":63},"repo":{"22":63},"repos":{"22":63},"reposi":{"22":63},"reposit":{"22":63},"reposito":{"22":63},"repositor":{"22":63},"repository":{"22":63},"rev":{"23":63},"revi":{"23":63},"revis":{"23":63},"revisi":{"23":63},"revisio":{"23":63},"revision":{"23":63},"sh":{"24":63},"sha":{"24":63},"shar":{"24":63},"share":{"24":63},"shared":{"24":63},"shared_":{"24":63},"shared_p":{"24":63},"shared_pa":{"24":63},"shared_pat":{"24":63},"shared_path":{"24":63},"te":{"25":63},"ter":{"25":63},"term":{"25":63},"term_":{"25":63},"term_m":{"25":63},"term_mo":{"25":63},"term_mod":{"25":63},"term_mode":{"25":63},"us":{"26":63},"use":{"26":63},"user":{"26":63},"cs":{"27":63},"css":{"27":63},"su":{"28":63},"sub":{"28":63},"subt":{"28":63},"subta":{"28":63},"subtas":{"28":63},"subtask":{"28":63},"subtasks":{"28":63},"bu":{"29":63},"bun":{"29":63},"bund":{"29":63},"bundl":{"29":63},"bundle":{"29":63},"ins":{"29":63},"inst":{"29":63},"insta":{"29":63},"instal":{"29":63},"install":{"29":63},"fo":{"30":63},"for":{"30":63},"forc":{"30":63},"force":{"30":63},"force_":{"30":63},"force_u":{"30":63},"force_un":{"30":63},"force_unl":{"30":63},"force_unlo":{"30":63},"force_unloc":{"30":63},"force_unlock":{"30":63},"gi":{"31":63},"git":{"31":63},"cl":{"31":63},"clo":{"31":63},"clon":{"31":63},"clone":{"31":63},"ta":{"32":63},"tas":{"32":63},"task":{"32":63},"tasks":{"32":63},"ra":{"33":63,"34":63},"rai":{"33":63,"34":63},"rail":{"33":63,"34":63},"rails":{"33":63,"34":63},"as":{"33":63},"ass":{"33":63},"asse":{"33":63},"asset":{"33":63},"assets":{"33":63},"assets_":{"33":63},"assets_p":{"33":63},"assets_pr":{"33":63},"assets_pre":{"33":63},"assets_prec":{"33":63},"assets_preco":{"33":63},"assets_precom":{"33":63},"assets_precomp":{"33":63},"assets_precompi":{"33":63},"assets_precompil":{"33":63},"assets_precompile":{"33":63},"db":{"34":63},"db_":{"34":63},"db_m":{"34":63},"db_mi":{"34":63},"db_mig":{"34":63},"db_migr":{"34":63},"db_migra":{"34":63},"db_migrat":{"34":63},"db_migrate":{"34":63},"ru":{"35":63},"run":{"35":63},"setu":{"36":63},"setup":{"36":63}}});



