Messages = new Meteor.Collection('messages');

if (Meteor.is_client) {

  var okcancel_events = function(selector) {
    return 'keyup '+selector+', keydown '+selector+', focusout '+selector;
  };

  var make_okcancel_handler = function(options) {
    var ok     = options.ok     || function() {};
    var cancel = options.cancel || function() {};

    return function(evt) {
      if (evt.type === "keydown" && evt.which === 27) {
        cancel.call(this, evt);
      } else if (evt.type === "keyup" && evt.which === 13) {
        var value = String(evt.target.value || "");
        if (value) {
          ok.call(this, value, evt);
        } else {
          cancel.call(this, evt);
        }
      }
    };
  };

  Template.entry.events = {};

  Template.entry.events[okcancel_events('#messageBox')] = make_okcancel_handler({
    ok: function(text, event) {
      var name = document.getElementById("name");
      var timestamp = Date.now() / 1000;
      if (name.value != "") {
        Messages.insert({name: name.value, message: text, time: timestamp});
        event.target.value = ""
      }
    }
  });

  Template.messages.messages = function(){
    return Messages.find({}, { sort: {time: -1} });
  };

}

