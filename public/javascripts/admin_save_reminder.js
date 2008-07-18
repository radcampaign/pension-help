/* Checks if assigned forms has been changed. */
function AdminFormObserver() {
  //forms that will be checked
  this.adminForms = new Array();
  //serialized forms(before any change)
  this.serializedForms = new Array();

  /* Checks if any form has been changed. */
  this.allowLeave = function() {
     return !this.formUpdated();
  };

  /* Checks if at least one form has been changed. */
  this.formUpdated = function() {
    var result = false;

    for (var i = 0; i < this.adminForms.length; i++) {
      /* tinyMCE fields does not store its text in textarea until save. */
      try { tinyMCE.triggerSave(true,true); } catch(err) {}

      var tempForm = Form.serialize(this.adminForms[i]);
      if (tempForm != this.serializedForms[i]) {
        result = true;
      }
    }

    return result;
  };

  /* Adds form which will be checked for updates. */
  this.addForm = function(form) {
    this.adminForms.push(form);
    this.serializedForms.push(Form.serialize(form));
  };
}

/* Finds links and buttons. */
function LinkButtonFinder() {
    /* this methods can be overriden */
    /* methods for checking if the link or button is on Ignored list */
    this.compareLinks = function(a,b) { return a == b.id || a == b.href || a == b.pathname};
    this.compareButtons = function(a,b){ return a == b.id || a == b.name};
    
    /* methods for looking up link and buttons */
    this.searchLinkMethod = function() { return $$('a')};
    this.searchButtonMethod = function() { return $$('input[type=submit]', 'input[type=button]')};
    
    /* Finds links and buttons, takes lists of element that should be ignored. */
    this.findAll = function(links, buttons) {
      this.ignoredLinks = links;
      this.ignoredButtons = buttons;

      this.findLinks();
      this.findButtons();

      return this.itemList;
    };

    /* PRIVATE */
    /* This should not be overriden */
    this.itemList = new Array();

    /* Checks if give link should be ignored. */
    this.linkOnIgnoredList = function(link) {
      return this.itemOnIgnoredList(link, this.ignoredLinks, this.compareLinks);
    };

    /* Checks if given button should be ignored. */
    this.buttonOnIgnoredList = function(button) {
      return this.itemOnIgnoredList(button, this.ignoredButtons, this.compareButtons);
    };

    /* Checks if givene element chould be ignored. */
    this.itemOnIgnoredList = function(item, list, compare) {
        var result = false;
        list.each(function(ignoredItem){
          if (compare(ignoredItem, item)) {
            result = true;
          }
        });
        return result;
    };

    this.findLinks = function() {
      //in 'each' loop 'this' applies to window object instead of LinkButtonFinder
      var self = this;
      this.searchLinkMethod().each(function(item) {
        if (!self.linkOnIgnoredList(item)) {
          self.itemList.push(item);
        }
      });
    };

    this.findButtons = function() {
      //in 'each' loop 'this' applies to window object instead of LinkButtonFinder
      var self = this;
      this.searchButtonMethod().each(function(item) {
        if (!self.buttonOnIgnoredList(item)) {
          self.itemList.push(item);
        }
      });
    };
    /* /END PRIVATE */
}

/* Monitors links and buttons on screen, shows pop-up if any form has been changed. */
function AdminSaveReminder() {
    this.finder = new LinkButtonFinder();
    this.observer = new AdminFormObserver();

    this.getForms = function(){ return $A(document.forms); };

    /*  */
    this.addObserverToLinkButtons = function(ignoredLinks, ignoredButtons) {
      var self = this;
      this.getForms().each(function(form) {
        self.observer.addForm(form);
      });

      this.finder.findAll(ignoredLinks,ignoredButtons).each(function(item) {
        item.observe('click', function(event) {
          if (!self.observer.allowLeave()) {
            if (!confirm('Form has been changed, leave without saving?')) {
              Event.stop(event);
            }
          }
        });
      });
    };
}
