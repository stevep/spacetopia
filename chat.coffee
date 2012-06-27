Messages = new Meteor.Collection 'messages'

if Meteor.is_client
  okcancel_events = (selector) ->
    'keyup '+selector+', keydown '+selector+', focusout '+selector


  make_okcancel_handler = (options) ->
    ok = options.ok || ->
    cancel = options.cancel || ->

    (evt) ->
      if evt.type == "keydown" && evt.which == 27
        cancel.call(this, evt)
      else if evt.type == "keyup" && evt.which == 13
        value = String(evt.target.value || "")
        if value
          ok.call(this, value, evt)
        else
          cancel.call(this, evt)

  Template.entry.events = {}

  Template.entry.events[okcancel_events('#messageBox')] = make_okcancel_handler(
    ok: (text, event) ->
      name = document.getElementById("name")
      timestamp = Date.now() / 1000
      if (name.value != "")
        Messages.insert({name: name.value, message: text, time: timestamp})
        event.target.value = ""
  )

  Template.messages.messages = ->
    Messages.find({}, { sort: {time: -1} })

